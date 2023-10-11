// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'edit_reject_type_event.dart';
part 'edit_reject_type_state.dart';

class EditRejectTypeBloc
    extends Bloc<EditRejectTypeEvent, EditRejectTypeState> {
  EditRejectTypeBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const EditRejectTypeInitial()) {
    on<GetCurrentRejectTypeEvent>(_getCurrentRejectTypeHandler);
    on<CreateCurrentRejectTypeEvent>(_createCurrentRejectTypeHandler);
    on<UpdateCurrentRejectTypeEvent>(_updateCurrentRejectTypeHandler);
    on<DeleteCurrentRejectTypeEvent>(_deleteCurrentRejectTypeHandler);
  }

  final MasterDataRepository _masterDataRepository;

  Future<void> _getCurrentRejectTypeHandler(
    GetCurrentRejectTypeEvent event,
    Emitter<EditRejectTypeState> emit,
  ) async {
    if (event.rejectTypeId.isEmpty) {
      emit(GotCurrentRejectType(RejectTypeModel.empty()));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const EditRejectTypeError('Required company ID'));
      return;
    }

    emit(const GetingCurrentRejectType());

    final result = await _masterDataRepository.getRejectTypeById(
      event.rejectTypeId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRejectTypeError(failure.errorMessage)),
      (rejectType) => emit(GotCurrentRejectType(rejectType)),
    );
  }

  Future<void> _createCurrentRejectTypeHandler(
    CreateCurrentRejectTypeEvent event,
    Emitter<EditRejectTypeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditRejectTypeError('Required company ID'));
      return;
    }

    emit(const CreatingCurrentRejectType());

    final result = await _masterDataRepository.createRejectType(
      event.rejectType,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRejectTypeError(failure.errorMessage)),
      (rejectType) => emit(CreatedCurrentRejectType(rejectType)),
    );
  }

  Future<void> _updateCurrentRejectTypeHandler(
    UpdateCurrentRejectTypeEvent event,
    Emitter<EditRejectTypeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditRejectTypeError('Required company ID'));
      return;
    }

    emit(const UpdatingCurrentRejectType());

    final result = await _masterDataRepository.updateRejectType(
      event.rejectType,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRejectTypeError(failure.errorMessage)),
      (_) => emit(UpdatedCurrentRejectType(event.rejectType)),
    );
  }

  Future<void> _deleteCurrentRejectTypeHandler(
    DeleteCurrentRejectTypeEvent event,
    Emitter<EditRejectTypeState> emit,
  ) async {
    if (event.rejectTypeId.isEmpty) return;

    if (event.companyId.isEmpty) {
      emit(const EditRejectTypeError('Required company ID'));
      return;
    }

    emit(const DeletingCurrentRejectType());

    final result = await _masterDataRepository.deleteRejectType(
      event.rejectTypeId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRejectTypeError(failure.errorMessage)),
      (_) => emit(DeletedCurrentRejectType(event.rejectTypeId)),
    );
  }
}
