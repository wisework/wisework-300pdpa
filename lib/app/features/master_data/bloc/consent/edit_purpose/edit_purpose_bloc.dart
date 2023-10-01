// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'edit_purpose_event.dart';
part 'edit_purpose_state.dart';

class EditPurposeBloc extends Bloc<EditPurposeEvent, EditPurposeState> {
  EditPurposeBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const EditPurposeInitial()) {
    on<GetCurrentPurposeEvent>(_getCurrentPurposeHandler);
    on<UpdateCurrentPurposeEvent>(_updateCurrentPurposeHandler);
  }

  final MasterDataRepository _masterDataRepository;

  Future<void> _getCurrentPurposeHandler(
    GetCurrentPurposeEvent event,
    Emitter<EditPurposeState> emit,
  ) async {
    if (event.purposeId.isEmpty) {
      emit(GotCurrentPurpose(PurposeModel.empty()));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const EditPurposeError('Required company ID'));
      return;
    }

    emit(const GetingCurrentPurpose());

    final result = await _masterDataRepository.getPurposeById(
      event.purposeId,
      event.companyId,
    );

    result.fold(
      (failure) => emit(EditPurposeError(failure.errorMessage)),
      (purpose) => emit(GotCurrentPurpose(purpose)),
    );
  }

  Future<void> _updateCurrentPurposeHandler(
    UpdateCurrentPurposeEvent event,
    Emitter<EditPurposeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditPurposeError('Required company ID'));
      return;
    }

    emit(UpdatingCurrentPurpose(event.purpose));

    final result = await _masterDataRepository.updatePurpose(
      event.purpose,
      event.companyId,
    );

    result.fold(
      (failure) => emit(EditPurposeError(failure.errorMessage)),
      (purpose) => emit(GotCurrentPurpose(purpose)),
    );
  }
}
