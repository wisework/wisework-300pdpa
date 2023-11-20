// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
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
    on<UpdateEditRequestRejectTpStateEvent>(
        _updateEditRequestRejectStateHandler);
  }

  final MasterDataRepository _masterDataRepository;

  Future<void> _getCurrentRequestRejectTpHandler(
    GetCurrentRequestRejectTpEvent event,
    Emitter<EditRequestRejectTpState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditRequestRejectTpError('Required company ID'));
      return;
    }

    emit(const GetingCurrentRequestRejectTp());

    // final result = await _masterDataRepository.getRequestRejectTemplateById(
    //   event.requestRejectTpId,
    //   event.companyId,
    // );

    // await Future.delayed(const Duration(milliseconds: 800));

    // result.fold(
    //   (failure) => emit(EditRequestRejectTpError(failure.errorMessage)),
    //   (requestRejectTp) => emit(GotCurrentRequestRejectTp(requestRejectTp)),
    // );

    final emptyRequestReject = RequestRejectTemplateModel.empty();
    RequestRejectTemplateModel gotRequestReject = emptyRequestReject;
    List<String> gotRejects = [];

    if (event.requestRejectTpId.isNotEmpty) {
      final requestRejectResult =
          await _masterDataRepository.getRequestRejectTemplateById(
        event.requestRejectTpId,
        event.companyId,
      );
      requestRejectResult.fold(
        (failure) {
          emit(EditRequestRejectTpError(failure.errorMessage));
          return;
        },
        (requestReject) {
          gotRequestReject = requestReject;
        },
      );
    }

    final rejectResult = await _masterDataRepository.getRejectTypes(
      event.companyId,
    );
    rejectResult.fold(
      (failure) {
        emit(EditRequestRejectTpError(failure.errorMessage));
        return;
      },
      (rejects) {
        gotRejects = rejects.map((e) => e.id).toList();
      },
    );

    if (gotRequestReject != emptyRequestReject) {
      final rejectIds =
          gotRequestReject.rejectTypesId.map((reject) => reject).toList();

      gotRequestReject = gotRequestReject.copyWith(
        rejectTypesId: gotRejects.where((reject) {
          return rejectIds.contains(reject);
        }).toList(),
      );
    }

    emit(GotCurrentRequestRejectTp(gotRequestReject, gotRejects));
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

    List<String> rejects = [];
    if (state is GotCurrentRequestRejectTp) {
      rejects = (state as GotCurrentRequestRejectTp).rejects;
    } else if (state is UpdatedCurrentRequestRejectTp) {
      rejects = (state as UpdatedCurrentRequestRejectTp).rejects;
    }

    emit(const UpdatingCurrentRequestRejectTp());

    final result = await _masterDataRepository.updateRequestRejectTemplate(
      event.requestRejectTp,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRequestRejectTpError(failure.errorMessage)),
      (_) => emit(UpdatedCurrentRequestRejectTp(
        event.requestRejectTp,
        rejects,
      )),
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

  Future<void> _updateEditRequestRejectStateHandler(
    UpdateEditRequestRejectTpStateEvent event,
    Emitter<EditRequestRejectTpState> emit,
  ) async {
    List<String> rejects = [];

    if (state is GotCurrentRequestRejectTp) {
      final requestReject =
          (state as GotCurrentRequestRejectTp).requestRejectTp;

      rejects = (state as GotCurrentRequestRejectTp)
          .rejects
          .map((reject) => reject)
          .toList();
      rejects.add(event.reject.id);

      emit(GotCurrentRequestRejectTp(requestReject, rejects));
    } else if (state is UpdatedCurrentRequestRejectTp) {
      final requestReject =
          (state as UpdatedCurrentRequestRejectTp).requestRejectTp;

      rejects = (state as UpdatedCurrentRequestRejectTp)
          .rejects
          .map((reject) => reject)
          .toList();
      rejects.add(event.reject.id);

      emit(UpdatedCurrentRequestRejectTp(requestReject, rejects));
    }
  }
}
