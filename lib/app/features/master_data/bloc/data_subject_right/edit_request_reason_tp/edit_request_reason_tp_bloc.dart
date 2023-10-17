// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/request_reason_template_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'edit_request_reason_tp_event.dart';
part 'edit_request_reason_tp_state.dart';

class EditRequestReasonTpBloc
    extends Bloc<EditRequestReasonTpEvent, EditRequestReasonTpState> {
  EditRequestReasonTpBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const EditRequestReasonTpInitial()) {
    on<GetCurrentRequestReasonTpEvent>(_getCurrentRequestReasonTpHandler);
    on<CreateCurrentRequestReasonTpEvent>(_createCurrentRequestReasonTpHandler);
    on<UpdateCurrentRequestReasonTpEvent>(_updateCurrentRequestReasonTpHandler);
    on<DeleteCurrentRequestReasonTpEvent>(_deleteCurrentRequestReasonTpHandler);
  }

  final MasterDataRepository _masterDataRepository;

  Future<void> _getCurrentRequestReasonTpHandler(
    GetCurrentRequestReasonTpEvent event,
    Emitter<EditRequestReasonTpState> emit,
  ) async {
    if (event.requestReasonTpId.isEmpty) {
      emit(GotCurrentRequestReasonTp(RequestReasonTemplateModel.empty()));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const EditRequestReasonTpError('Required company ID'));
      return;
    }

    emit(const GetingCurrentRequestReasonTp());

    final result = await _masterDataRepository.getRequestReasonTemplateById(
      event.requestReasonTpId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRequestReasonTpError(failure.errorMessage)),
      (requestReasonTp) => emit(GotCurrentRequestReasonTp(requestReasonTp)),
    );
  }

  Future<void> _createCurrentRequestReasonTpHandler(
    CreateCurrentRequestReasonTpEvent event,
    Emitter<EditRequestReasonTpState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditRequestReasonTpError('Required company ID'));
      return;
    }

    emit(const CreatingCurrentRequestReasonTp());

    final result = await _masterDataRepository.createRequestReasonTemplate(
      event.requestReasonTp,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRequestReasonTpError(failure.errorMessage)),
      (requestReasonTp) => emit(CreatedCurrentRequestReasonTp(requestReasonTp)),
    );
  }

  Future<void> _updateCurrentRequestReasonTpHandler(
    UpdateCurrentRequestReasonTpEvent event,
    Emitter<EditRequestReasonTpState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditRequestReasonTpError('Required company ID'));
      return;
    }

    emit(const UpdatingCurrentRequestReasonTp());

    final result = await _masterDataRepository.updateRequestReasonTemplate(
      event.requestReasonTp,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRequestReasonTpError(failure.errorMessage)),
      (_) => emit(UpdatedCurrentRequestReasonTp(event.requestReasonTp)),
    );
  }

  Future<void> _deleteCurrentRequestReasonTpHandler(
    DeleteCurrentRequestReasonTpEvent event,
    Emitter<EditRequestReasonTpState> emit,
  ) async {
    if (event.requestReasonTpId.isEmpty) return;

    if (event.companyId.isEmpty) {
      emit(const EditRequestReasonTpError('Required company ID'));
      return;
    }

    emit(const DeletingCurrentRequestReasonTp());

    final result = await _masterDataRepository.deleteRequestReasonTemplate(
      event.requestReasonTpId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRequestReasonTpError(failure.errorMessage)),
      (_) => emit(DeletedCurrentRequestReasonTp(event.requestReasonTpId)),
    );
  }
}
