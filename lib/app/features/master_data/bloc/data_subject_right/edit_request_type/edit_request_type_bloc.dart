// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/data/presets/reject_types_preset.dart';
import 'package:pdpa/app/data/repositories/data_subject_right_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'edit_request_type_event.dart';
part 'edit_request_type_state.dart';

class EditRequestTypeBloc
    extends Bloc<EditRequestTypeEvent, EditRequestTypeState> {
  EditRequestTypeBloc({
    required MasterDataRepository masterDataRepository,
    required DataSubjectRightRepository dataSubjectRightRepository,
  })  : _masterDataRepository = masterDataRepository,
        _dataSubjectRightRepository = dataSubjectRightRepository,
        super(const EditRequestTypeInitial()) {
    on<GetCurrentRequestTypeEvent>(_getCurrentRequestTypeHandler);
    on<CreateCurrentRequestTypeEvent>(_createCurrentRequestTypeHandler);
    on<UpdateCurrentRequestTypeEvent>(_updateCurrentRequestTypeHandler);
    on<DeleteCurrentRequestTypeEvent>(_deleteCurrentRequestTypeHandler);
    on<UpdateEditRequestTypeStateEvent>(_updateEditRequestTypeStateHandler);
  }

  final DataSubjectRightRepository _dataSubjectRightRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getCurrentRequestTypeHandler(
    GetCurrentRequestTypeEvent event,
    Emitter<EditRequestTypeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditRequestTypeError('Required company ID'));
      return;
    }

    emit(const GetingCurrentRequestType());

    final emptyRequestType = RequestTypeModel.empty();
    RequestTypeModel gotRequestType = emptyRequestType;
    List<RejectTypeModel> gotRejects = [];

    if (event.requestTypeId.isNotEmpty) {
      final requestTypeResult = await _masterDataRepository.getRequestTypeById(
        event.requestTypeId,
        event.companyId,
      );

      requestTypeResult.fold(
        (failure) {
          emit(EditRequestTypeError(failure.errorMessage));
          return;
        },
        (requestType) {
          gotRequestType = requestType;
        },
      );
    }

    final rejectResult = await _masterDataRepository.getRejectTypes(
      event.companyId,
    );

    rejectResult.fold(
      (failure) {
        emit(EditRequestTypeError(failure.errorMessage));
        return;
      },
      (rejects) {
        gotRejects.addAll(rejectTypesPreset);
        gotRejects.addAll(rejects);
      },
    );

    if (gotRequestType != emptyRequestType) {
      final rejectIds =
          gotRequestType.rejectTypes.map((reject) => reject.id).toList();

      gotRequestType = gotRequestType.copyWith(
        rejectTypes: gotRejects.where((reject) {
          return rejectIds.contains(reject.id);
        }).toList(),
      );
    }

    List<DataSubjectRightModel> gotDSR = [];
    if (event.companyId.isNotEmpty) {
      final resultDSR = await _dataSubjectRightRepository.getDataSubjectRights(
        event.companyId,
      );

      resultDSR.fold(
        (failure) => emit(EditRequestTypeError(failure.errorMessage)),
        (dsr) => gotDSR.addAll(dsr),
      );
    }

    await Future.delayed(const Duration(milliseconds: 800));

    emit(GotCurrentRequestType(
      gotRequestType,
      gotRejects,
      gotDSR,
    ));
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

    List<RejectTypeModel> rejectTypes = [];
    List<DataSubjectRightModel> dsr = [];
    if (state is GotCurrentRequestType) {
      rejectTypes = (state as GotCurrentRequestType).rejectTypes;
      dsr = (state as GotCurrentRequestType).dataSubjectRights;
    } else if (state is UpdatedCurrentRequestType) {
      rejectTypes = (state as UpdatedCurrentRequestType).rejectTypes;
      dsr = (state as UpdatedCurrentRequestType).dataSubjectRights;
    }

    emit(const UpdatingCurrentRequestType());

    final result = await _masterDataRepository.updateRequestType(
      event.requestType,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditRequestTypeError(failure.errorMessage)),
      (_) => emit(UpdatedCurrentRequestType(
        event.requestType,
        rejectTypes,
        dsr,
      )),
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

  Future<void> _updateEditRequestTypeStateHandler(
    UpdateEditRequestTypeStateEvent event,
    Emitter<EditRequestTypeState> emit,
  ) async {
    List<RejectTypeModel> rejectTypes = [];

    if (state is GotCurrentRequestType) {
      final gotRequestType = state as GotCurrentRequestType;

      rejectTypes = (state as GotCurrentRequestType)
          .rejectTypes
          .map((reject) => reject)
          .toList();
      rejectTypes.add(event.reject);

      emit(GotCurrentRequestType(
        gotRequestType.requestType,
        rejectTypes,
        gotRequestType.dataSubjectRights,
      ));
    } else if (state is UpdatedCurrentRequestType) {
      final gotRequestType = state as GotCurrentRequestType;

      rejectTypes = (state as UpdatedCurrentRequestType)
          .rejectTypes
          .map((reject) => reject)
          .toList();
      rejectTypes.add(event.reject);

      emit(UpdatedCurrentRequestType(
        gotRequestType.requestType,
        rejectTypes,
        gotRequestType.dataSubjectRights,
      ));
    }
  }
}
