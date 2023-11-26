// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/data/presets/reason_types_preset.dart';
import 'package:pdpa/app/data/presets/reject_types_preset.dart';
import 'package:pdpa/app/data/presets/request_types_preset.dart';
import 'package:pdpa/app/data/repositories/data_subject_right_repository.dart';
import 'package:pdpa/app/data/repositories/general_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/data/repositories/user_repository.dart';

part 'edit_data_subject_right_event.dart';
part 'edit_data_subject_right_state.dart';

class EditDataSubjectRightBloc
    extends Bloc<EditDataSubjectRightEvent, EditDataSubjectRightState> {
  EditDataSubjectRightBloc({
    required DataSubjectRightRepository dataSubjectRightRepository,
    required MasterDataRepository masterDataRepository,
    required UserRepository userRepository,
    required GeneralRepository generalRepository,
  })  : _dataSubjectRightRepository = dataSubjectRightRepository,
        _masterDataRepository = masterDataRepository,
        _userRepository = userRepository,
        _generalRepository = generalRepository,
        super(const EditDataSubjectRightInitial()) {
    on<GetCurrentDataSubjectRightEvent>(_getCurrentDsrHandler);
    on<CreateCurrentDataSubjectRightEvent>(_createCurrentDsrHandler);
    on<UpdateCurrentDataSubjectRightEvent>(_updateCurrentDsrHandler);
    on<UpdateEditDataSubjectRightStateEvent>(_updateEditDsrStateHandler);
    on<DownloadDataSubjectRightFileEvent>(_downloadDsrFileHandler);
  }

  final DataSubjectRightRepository _dataSubjectRightRepository;
  final MasterDataRepository _masterDataRepository;
  final UserRepository _userRepository;
  final GeneralRepository _generalRepository;

  Future<void> _getCurrentDsrHandler(
    GetCurrentDataSubjectRightEvent event,
    Emitter<EditDataSubjectRightState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditDataSubjectRightError('Required company ID'));
      return;
    }

    emit(const GettingCurrentDataSubjectRight());

    final result = await _dataSubjectRightRepository.getDataSubjectRightById(
      event.dataSubjectRightId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    await result.fold((failure) {
      emit(EditDataSubjectRightError(failure.errorMessage));
    }, (dataSubjectRight) async {
      List<RequestTypeModel> gotRequestTypes = requestTypesPreset;
      final requestTypeResult = await _masterDataRepository.getRequestTypes(
        event.companyId,
      );
      requestTypeResult.fold(
        (failure) => emit(EditDataSubjectRightError(failure.errorMessage)),
        (requestTypes) => gotRequestTypes.addAll(requestTypes),
      );

      List<ReasonTypeModel> gotReasonTypes = reasonTypesPreset;
      final reasonTypeResult = await _masterDataRepository.getReasonTypes(
        event.companyId,
      );
      reasonTypeResult.fold(
        (failure) => emit(EditDataSubjectRightError(failure.errorMessage)),
        (reasonTypes) => gotReasonTypes.addAll(reasonTypes),
      );

      List<RejectTypeModel> gotRejectTypes = rejectTypesPreset;
      final rejectTypeResult = await _masterDataRepository.getRejectTypes(
        event.companyId,
      );
      rejectTypeResult.fold(
        (failure) => emit(EditDataSubjectRightError(failure.errorMessage)),
        (rejectTypes) => gotRejectTypes.addAll(rejectTypes),
      );

      List<String> gotEmails = [];
      final userResult = await _userRepository.getUsers();
      userResult.fold(
        (failure) => emit(EditDataSubjectRightError(failure.errorMessage)),
        (users) {
          for (UserModel user in users) {
            if (user.companies.contains(event.companyId)) {
              gotEmails.add(user.email);
            }
          }
        },
      );

      //? Sort Process Requests
      List<ProcessRequestModel> processRequestSorted = [];

      for (ProcessRequestModel request in dataSubjectRight.processRequests) {
        final reasonTypes = request.reasonTypes
          ..sort((a, b) => a.id.compareTo(b.id));
        processRequestSorted.add(request.copyWith(reasonTypes: reasonTypes));
      }

      processRequestSorted = processRequestSorted
        ..sort((a, b) => a.requestType.compareTo(b.requestType));

      emit(
        GotCurrentDataSubjectRight(
          dataSubjectRight.copyWith(
            dataRequester: dataSubjectRight.dataRequester
              ..sort(
                (a, b) => a.priority.compareTo(b.priority),
              ),
            dataOwner: dataSubjectRight.dataOwner
              ..sort(
                (a, b) => a.priority.compareTo(b.priority),
              ),
            processRequests: processRequestSorted,
          ),
          gotRequestTypes,
          gotReasonTypes,
          gotRejectTypes,
          gotEmails,
        ),
      );
    });
  }

  Future<void> _createCurrentDsrHandler(
    CreateCurrentDataSubjectRightEvent event,
    Emitter<EditDataSubjectRightState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditDataSubjectRightError('Required company ID'));
      return;
    }

    emit(const CreatingCurrentDataSubjectRight());

    final result = await _dataSubjectRightRepository.createDataSubjectRight(
      event.dataSubjectRight,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditDataSubjectRightError(failure.errorMessage)),
      (dataSubjectRight) => emit(
        CreatedCurrentDataSubjectRight(dataSubjectRight),
      ),
    );
  }

  Future<void> _updateCurrentDsrHandler(
    UpdateCurrentDataSubjectRightEvent event,
    Emitter<EditDataSubjectRightState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditDataSubjectRightError('Required company ID'));
      return;
    }

    List<RequestTypeModel> requestTypes = [];
    List<ReasonTypeModel> reasonTypes = [];
    List<RejectTypeModel> rejectTypes = [];
    List<String> emails = [];
    if (state is GotCurrentDataSubjectRight) {
      final settings = state as GotCurrentDataSubjectRight;

      requestTypes = settings.requestTypes;
      reasonTypes = settings.reasonTypes;
      rejectTypes = settings.rejectTypes;
      emails = settings.userEmails;
    } else if (state is UpdatedCurrentDataSubjectRight) {
      final settings = state as UpdatedCurrentDataSubjectRight;

      requestTypes = settings.requestTypes;
      reasonTypes = settings.reasonTypes;
      rejectTypes = settings.rejectTypes;
      emails = settings.userEmails;
    }

    emit(const UpdatingCurrentDataSubjectRight());

    final result = await _dataSubjectRightRepository.updateDataSubjectRight(
      event.dataSubjectRight,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditDataSubjectRightError(failure.errorMessage)),
      (_) => emit(
        UpdatedCurrentDataSubjectRight(
          event.dataSubjectRight,
          requestTypes,
          reasonTypes,
          rejectTypes,
          emails,
        ),
      ),
    );
  }

  Future<void> _updateEditDsrStateHandler(
    UpdateEditDataSubjectRightStateEvent event,
    Emitter<EditDataSubjectRightState> emit,
  ) async {
    List<RequestTypeModel> requestTypes = [];
    List<ReasonTypeModel> reasonTypes = [];
    List<RejectTypeModel> rejectTypes = [];
    List<String> emails = [];

    if (state is GotCurrentDataSubjectRight) {
      final settings = state as GotCurrentDataSubjectRight;

      requestTypes = settings.requestTypes;
      reasonTypes = settings.reasonTypes;
      rejectTypes = settings.rejectTypes;
      emails = settings.userEmails;

      emit(const UpdatingCurrentDataSubjectRight());

      await Future.delayed(const Duration(milliseconds: 800));

      emit(
        GotCurrentDataSubjectRight(
          event.dataSubjectRight,
          requestTypes,
          reasonTypes,
          rejectTypes,
          emails,
        ),
      );
    } else if (state is UpdatedCurrentDataSubjectRight) {
      final settings = state as GotCurrentDataSubjectRight;

      requestTypes = settings.requestTypes;
      reasonTypes = settings.reasonTypes;
      rejectTypes = settings.rejectTypes;
      emails = settings.userEmails;

      emit(const UpdatingCurrentDataSubjectRight());

      await Future.delayed(const Duration(milliseconds: 800));

      emit(
        UpdatedCurrentDataSubjectRight(
          event.dataSubjectRight,
          requestTypes,
          reasonTypes,
          rejectTypes,
          emails,
        ),
      );
    }
  }

  Future<void> _downloadDsrFileHandler(
    DownloadDataSubjectRightFileEvent event,
    Emitter<EditDataSubjectRightState> emit,
  ) async {
    await _generalRepository.downloadFirebaseStorageFile(event.path);
  }
}
