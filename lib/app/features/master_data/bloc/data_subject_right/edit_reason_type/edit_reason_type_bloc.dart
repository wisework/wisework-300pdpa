// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'edit_reason_type_event.dart';
part 'edit_reason_type_state.dart';

class EditReasonTypeBloc
    extends Bloc<EditReasonTypeEvent, EditReasonTypeState> {
  EditReasonTypeBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const EditReasonTypeInitial()) {
    on<GetCurrentReasonTypeEvent>(_getCurrentReasonTypeHandler);
    on<CreateCurrentReasonTypeEvent>(_createCurrentReasonTypeHandler);
    on<UpdateCurrentReasonTypeEvent>(_updateCurrentReasonTypeHandler);
    on<DeleteCurrentReasonTypeEvent>(_deleteCurrentReasonTypeHandler);
  }

  final MasterDataRepository _masterDataRepository;

  Future<void> _getCurrentReasonTypeHandler(
    GetCurrentReasonTypeEvent event,
    Emitter<EditReasonTypeState> emit,
  ) async {
    if (event.reasonTypeId.isEmpty) {
      emit(GotCurrentReasonType(ReasonTypeModel.empty()));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const EditReasonTypeError('Required company ID'));
      return;
    }

    emit(const GetingCurrentReasonType());

    final result = await _masterDataRepository.getReasonTypeById(
      event.reasonTypeId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditReasonTypeError(failure.errorMessage)),
      (reasonType) => emit(GotCurrentReasonType(reasonType)),
    );
  }

  Future<void> _createCurrentReasonTypeHandler(
    CreateCurrentReasonTypeEvent event,
    Emitter<EditReasonTypeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditReasonTypeError('Required company ID'));
      return;
    }

    emit(const CreatingCurrentReasonType());

    final result = await _masterDataRepository.createReasonType(
      event.reasonType,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditReasonTypeError(failure.errorMessage)),
      (reasonType) => emit(CreatedCurrentReasonType(reasonType)),
    );
  }

  Future<void> _updateCurrentReasonTypeHandler(
    UpdateCurrentReasonTypeEvent event,
    Emitter<EditReasonTypeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditReasonTypeError('Required company ID'));
      return;
    }

    emit(const UpdatingCurrentReasonType());

    final result = await _masterDataRepository.updateReasonType(
      event.reasonType,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditReasonTypeError(failure.errorMessage)),
      (_) => emit(UpdatedCurrentReasonType(event.reasonType)),
    );
  }

  Future<void> _deleteCurrentReasonTypeHandler(
    DeleteCurrentReasonTypeEvent event,
    Emitter<EditReasonTypeState> emit,
  ) async {
    if (event.reasonTypeId.isEmpty) return;

    if (event.companyId.isEmpty) {
      emit(const EditReasonTypeError('Required company ID'));
      return;
    }

    emit(const DeletingCurrentReasonType());

    final result = await _masterDataRepository.deleteReasonType(
      event.reasonTypeId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditReasonTypeError(failure.errorMessage)),
      (_) => emit(DeletedCurrentReasonType(event.reasonTypeId)),
    );
  }
}
