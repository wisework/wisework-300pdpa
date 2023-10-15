// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'edit_request_type_event.dart';
part 'edit_request_type_state.dart';

class EditRequestTypeBloc
    extends Bloc<EditRequestTypeEvent, EditRequestTypeState> {
  EditRequestTypeBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const EditRequestTypeInitial()) {
    on<GetCurrentRequestTypeEvent>(_getCurrentRequestTypeHandler);
    on<CreateCurrentRequestTypeEvent>(_createCurrentRequestTypeHandler);
    on<UpdateCurrentRequestTypeEvent>(_updateCurrentRequestTypeHandler);
    on<DeleteCurrentRequestTypeEvent>(_deleteCurrentRequestTypeHandler);
  }

  final MasterDataRepository _masterDataRepository;

  Future<void> _getCurrentRequestTypeHandler(
    GetCurrentRequestTypeEvent event,
    Emitter<EditRequestTypeState> emit,
  ) async {
    if (event.requestTypeId.isEmpty) {
      emit(GotCurrentRequestType(RequestTypeModel.empty()));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const EditRequestTypeError('Required company ID'));
      return;
    }

    emit(const GetingCurrentRequestType());

    final result = await _masterDataRepository.getRequestTypeById(
      event.requestTypeId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRequestTypeError(failure.errorMessage)),
      (requestType) => emit(GotCurrentRequestType(requestType)),
    );
  }

  Future<void> _createCurrentRequestTypeHandler(
    CreateCurrentRequestTypeEvent event,
    Emitter<EditRequestTypeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditRequestTypeError('Required company ID'));
      return;
    }

    emit(const CreatingCurrentRequestType());

    final result = await _masterDataRepository.createRequestType(
      event.requestType,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRequestTypeError(failure.errorMessage)),
      (requestType) => emit(CreatedCurrentRequestType(requestType)),
    );
  }

  Future<void> _updateCurrentRequestTypeHandler(
    UpdateCurrentRequestTypeEvent event,
    Emitter<EditRequestTypeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditRequestTypeError('Required company ID'));
      return;
    }

    emit(const UpdatingCurrentRequestType());

    final result = await _masterDataRepository.updateRequestType(
      event.requestType,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRequestTypeError(failure.errorMessage)),
      (_) => emit(UpdatedCurrentRequestType(event.requestType)),
    );
  }

  Future<void> _deleteCurrentRequestTypeHandler(
    DeleteCurrentRequestTypeEvent event,
    Emitter<EditRequestTypeState> emit,
  ) async {
    if (event.requestTypeId.isEmpty) return;

    if (event.companyId.isEmpty) {
      emit(const EditRequestTypeError('Required company ID'));
      return;
    }

    emit(const DeletingCurrentRequestType());

    final result = await _masterDataRepository.deleteRequestType(
      event.requestTypeId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRequestTypeError(failure.errorMessage)),
      (_) => emit(DeletedCurrentRequestType(event.requestTypeId)),
    );
  }
}
