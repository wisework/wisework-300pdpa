// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
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
    on<UpdateEditRequestReasonTpStateEvent>(
        _updateEditRequestReasonStateHandler);
  }

  final MasterDataRepository _masterDataRepository;

  Future<void> _getCurrentRequestReasonTpHandler(
    GetCurrentRequestReasonTpEvent event,
    Emitter<EditRequestReasonTpState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditRequestReasonTpError('Required company ID'));
      return;
    }

    emit(const GetingCurrentRequestReasonTp());

    // final result = await _masterDataRepository.getRequestReasonTemplateById(
    //   event.requestReasonTpId,
    //   event.companyId,
    // );

    // await Future.delayed(const Duration(milliseconds: 800));

    // result.fold(
    //   (failure) => emit(EditRequestReasonTpError(failure.errorMessage)),
    //   (requestReasonTp) => emit(GotCurrentRequestReasonTp(requestReasonTp)),
    // );

    final emptyRequestReason = RequestReasonTemplateModel.empty();
    RequestReasonTemplateModel gotRequestReason = emptyRequestReason;
    List<String> gotReasons = [];

    if (event.requestReasonTpId.isNotEmpty) {
      final requestReasonResult =
          await _masterDataRepository.getRequestReasonTemplateById(
        event.requestReasonTpId,
        event.companyId,
      );
      requestReasonResult.fold(
        (failure) {
          emit(EditRequestReasonTpError(failure.errorMessage));
          return;
        },
        (requestReason) {
          gotRequestReason = requestReason;
        },
      );
    }

    final reasonResult = await _masterDataRepository.getReasonTypes(
      event.companyId,
    );
    reasonResult.fold(
      (failure) {
        emit(EditRequestReasonTpError(failure.errorMessage));
        return;
      },
      (reasons) {
        gotReasons = reasons.map((e) => e.id).toList();
      },
    );

    if (gotRequestReason != emptyRequestReason) {
      final reasonIds =
          gotRequestReason.reasonTypesId.map((reason) => reason).toList();

      gotRequestReason = gotRequestReason.copyWith(
        reasonTypesId: gotReasons.where((reason) {
          return reasonIds.contains(reason);
        }).toList(),
      );
    }

    emit(GotCurrentRequestReasonTp(gotRequestReason, gotReasons));
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

    List<String> reasons = [];
    if (state is GotCurrentRequestReasonTp) {
      reasons = (state as GotCurrentRequestReasonTp).reasons;
    } else if (state is UpdatedCurrentRequestReasonTp) {
      reasons = (state as UpdatedCurrentRequestReasonTp).reasons;
    }

    emit(const UpdatingCurrentRequestReasonTp());

    final result = await _masterDataRepository.updateRequestReasonTemplate(
      event.requestReasonTp,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRequestReasonTpError(failure.errorMessage)),
      (_) => emit(UpdatedCurrentRequestReasonTp(
        event.requestReasonTp,
        reasons,
      )),
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

  Future<void> _updateEditRequestReasonStateHandler(
    UpdateEditRequestReasonTpStateEvent event,
    Emitter<EditRequestReasonTpState> emit,
  ) async {
    List<String> reasons = [];

    if (state is GotCurrentRequestReasonTp) {
      final requestReason =
          (state as GotCurrentRequestReasonTp).requestReasonTp;

      reasons = (state as GotCurrentRequestReasonTp)
          .reasons
          .map((reason) => reason)
          .toList();
      reasons.add(event.reason.id);

      emit(GotCurrentRequestReasonTp(requestReason, reasons));
    } else if (state is UpdatedCurrentRequestReasonTp) {
      final requestReason =
          (state as UpdatedCurrentRequestReasonTp).requestReasonTp;

      reasons = (state as UpdatedCurrentRequestReasonTp)
          .reasons
          .map((reason) => reason)
          .toList();
      reasons.add(event.reason.id);

      emit(UpdatedCurrentRequestReasonTp(requestReason, reasons));
    }
  }
}
