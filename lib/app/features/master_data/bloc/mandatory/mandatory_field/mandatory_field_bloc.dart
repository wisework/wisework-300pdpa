// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'mandatory_field_event.dart';
part 'mandatory_field_state.dart';

class MandatoryFieldBloc
    extends Bloc<MandatoryFieldEvent, MandatoryFieldState> {
  MandatoryFieldBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const MandatoryFieldInitial()) {
    on<GetMandatoryFieldsEvent>(_getMandatoryFieldsHandler);
    on<UpdateMandatoryFieldsEvent>(_updateMandatoryFieldsHandler);
  }

  final MasterDataRepository _masterDataRepository;

  Future<void> _getMandatoryFieldsHandler(
    GetMandatoryFieldsEvent event,
    Emitter<MandatoryFieldState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const MandatoryFieldError('Required company ID'));
      return;
    }

    emit(const GettingMandatoryFields());

    final result = await _masterDataRepository.getMandatoryFields(
      event.companyId,
    );

    result.fold(
      (failure) => emit(MandatoryFieldError(failure.errorMessage)),
      (mandatoryFields) => emit(GotMandatoryFields(
        mandatoryFields..sort((a, b) => b.priority.compareTo(a.priority)),
      )),
    );
  }

  Future<void> _updateMandatoryFieldsHandler(
    UpdateMandatoryFieldsEvent event,
    Emitter<MandatoryFieldState> emit,
  ) async {
    if (event.mandatoryFields.isEmpty) {
      emit(const MandatoryFieldError('Required mandatory fields'));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const MandatoryFieldError('Required company ID'));
      return;
    }

    emit(const GettingMandatoryFields());

    List<MandatoryFieldModel> mandatoryFields = [];

    for (MandatoryFieldModel mandatoryField in event.mandatoryFields) {
      final result = await _masterDataRepository.updateMandatoryField(
        mandatoryField,
        event.companyId,
      );

      result.fold(
        (failure) => emit(MandatoryFieldError(failure.errorMessage)),
        (_) => mandatoryFields.add(mandatoryField),
      );
    }

    emit(
      GotMandatoryFields(
        mandatoryFields..sort((a, b) => b.priority.compareTo(a.priority)),
      ),
    );
  }
}
