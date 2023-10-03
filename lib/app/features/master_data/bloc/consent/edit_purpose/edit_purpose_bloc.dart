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
    on<CreateCurrentPurposeEvent>(_createCurrentPurposeHandler);
    on<UpdateCurrentPurposeEvent>(_updateCurrentPurposeHandler);
    on<DeleteCurrentPurposeEvent>(_deleteCurrentPurposeHandler);
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

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditPurposeError(failure.errorMessage)),
      (purpose) => emit(GotCurrentPurpose(purpose)),
    );
  }

  Future<void> _createCurrentPurposeHandler(
    CreateCurrentPurposeEvent event,
    Emitter<EditPurposeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditPurposeError('Required company ID'));
      return;
    }

    emit(const CreatingCurrentPurpose());

    final result = await _masterDataRepository.createPurpose(
      event.purpose,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditPurposeError(failure.errorMessage)),
      (purpose) => emit(CreatedCurrentPurpose(purpose)),
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

    emit(const UpdatingCurrentPurpose());

    final result = await _masterDataRepository.updatePurpose(
      event.purpose,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditPurposeError(failure.errorMessage)),
      (_) => emit(UpdatedCurrentPurpose(event.purpose)),
    );
  }

  Future<void> _deleteCurrentPurposeHandler(
    DeleteCurrentPurposeEvent event,
    Emitter<EditPurposeState> emit,
  ) async {
    if (event.purposeId.isEmpty) return;

    if (event.companyId.isEmpty) {
      emit(const EditPurposeError('Required company ID'));
      return;
    }

    emit(const DeletingCurrentPurpose());

    final result = await _masterDataRepository.deletePurpose(
      event.purposeId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditPurposeError(failure.errorMessage)),
      (_) => emit(DeletedCurrentPurpose(event.purposeId)),
    );
  }
}
