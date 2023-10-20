// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/request_reject_template_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'edit_request_reject_tp_event.dart';
part 'edit_request_reject_tp_state.dart';

class EditRequestRejectTpBloc
    extends Bloc<EditRequestRejectTpEvent, EditRequestRejectTpState> {
  EditRequestRejectTpBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const EditRequestRejectTpInitial()) {
    on<GetCurrentRequestRejectTpEvent>(_getCurrentRequestRejectTpHandler);
    on<CreateCurrentRequestRejectTpEvent>(_createCurrentRequestRejectTpHandler);
    on<UpdateCurrentRequestRejectTpEvent>(_updateCurrentRequestRejectTpHandler);
    on<DeleteCurrentRequestRejectTpEvent>(_deleteCurrentRequestRejectTpHandler);
  }
  final MasterDataRepository _masterDataRepository;
  Future<void> _getCurrentRequestRejectTpHandler(
    GetCurrentRequestRejectTpEvent event,
    Emitter<EditRequestRejectTpState> emit,
  ) async {
    if (event.requestRejectTpId.isEmpty) {
      emit(GotCurrentRequestRejectTp(RequestRejectTemplateModel.empty()));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const EditRequestRejectTpError('Required company ID'));
      return;
    }

    emit(const GetingCurrentRequestRejectTp());

    final result = await _masterDataRepository.getRequestRejectTemplateById(
      event.requestRejectTpId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRequestRejectTpError(failure.errorMessage)),
      (requestRejectTp) => emit(GotCurrentRequestRejectTp(requestRejectTp)),
    );
  }

  Future<void> _createCurrentRequestRejectTpHandler(
    CreateCurrentRequestRejectTpEvent event,
    Emitter<EditRequestRejectTpState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditRequestRejectTpError('Required company ID'));
      return;
    }

    emit(const CreatingCurrentRequestRejectTp());

    final result = await _masterDataRepository.createRequestRejectTemplate(
      event.requestRejectTp,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRequestRejectTpError(failure.errorMessage)),
      (requestRejectTp) => emit(CreatedCurrentRequestRejectTp(requestRejectTp)),
    );
  }

  Future<void> _updateCurrentRequestRejectTpHandler(
    UpdateCurrentRequestRejectTpEvent event,
    Emitter<EditRequestRejectTpState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditRequestRejectTpError('Required company ID'));
      return;
    }

    emit(const UpdatingCurrentRequestRejectTp());

    final result = await _masterDataRepository.updateRequestRejectTemplate(
      event.requestRejectTp,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRequestRejectTpError(failure.errorMessage)),
      (_) => emit(UpdatedCurrentRequestRejectTp(event.requestRejectTp)),
    );
  }

  Future<void> _deleteCurrentRequestRejectTpHandler(
    DeleteCurrentRequestRejectTpEvent event,
    Emitter<EditRequestRejectTpState> emit,
  ) async {
    if (event.requestRejectTpId.isEmpty) return;

    if (event.companyId.isEmpty) {
      emit(const EditRequestRejectTpError('Required company ID'));
      return;
    }

    emit(const DeletingCurrentRequestRejectTp());

    final result = await _masterDataRepository.deleteRequestRejectTemplate(
      event.requestRejectTpId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRequestRejectTpError(failure.errorMessage)),
      (_) => emit(DeletedCurrentRequestRejectTp(event.requestRejectTpId)),
    );
  }
}
