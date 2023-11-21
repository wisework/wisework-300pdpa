import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/repositories/data_subject_right_repository.dart';
import 'package:pdpa/app/data/repositories/general_repository.dart';
import 'package:pdpa/app/features/data_subject_right/models/process_request_loading_status.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'process_data_subject_right_state.dart';

class ProcessDataSubjectRightCubit extends Cubit<ProcessDataSubjectRightState> {
  ProcessDataSubjectRightCubit({
    required DataSubjectRightRepository dataSubjectRightRepository,
    required GeneralRepository generalRepository,
  })  : _dataSubjectRightRepository = dataSubjectRightRepository,
        _generalRepository = generalRepository,
        super(ProcessDataSubjectRightState(
          dataSubjectRight: DataSubjectRightModel.empty(),
          initialDataSubjectRight: DataSubjectRightModel.empty(),
          currentUser: UserModel.empty(),
          userEmails: const [],
          stepIndex: 0,
          requestExpanded: const [],
          verifyError: false,
          considerError: const [],
          loadingStatus: ProcessRequestLoadingStatus.initial,
        ));

  final DataSubjectRightRepository _dataSubjectRightRepository;
  final GeneralRepository _generalRepository;

  void initialSettings(
    DataSubjectRightModel dataSubjectRight,
    String processRequestSelected,
    UserModel currentUser,
    List<String> userEmails,
  ) {
    int stepIndex = 0;

    if (dataSubjectRight.verifyFormStatus != RequestResultStatus.none) {
      stepIndex = 1;
    }

    emit(
      state.copyWith(
        dataSubjectRight: dataSubjectRight,
        initialDataSubjectRight: dataSubjectRight,
        currentUser: currentUser,
        userEmails: userEmails,
        stepIndex: stepIndex,
        requestExpanded: [processRequestSelected],
      ),
    );
  }

  void onBackStepPressed() {
    if (state.stepIndex > 0) {
      emit(state.copyWith(stepIndex: state.stepIndex - 1));
    }
  }

  void onNextStepPressed(int stepLength) {
    if (state.stepIndex < (stepLength - 1)) {
      emit(state.copyWith(stepIndex: state.stepIndex + 1));
    }
  }

  Future<void> onVerifyFormValidate(int stepLength) async {
    //? If no option is selected, a warning should be displayed.
    if (state.dataSubjectRight.verifyFormStatus == RequestResultStatus.none) {
      emit(state.copyWith(verifyError: true));
      return;
    }

    //? Saving data subject right.
    if (state.initialDataSubjectRight.verifyFormStatus ==
        RequestResultStatus.none) {
      emit(
        state.copyWith(
          loadingStatus: state.loadingStatus.copyWith(
            verifyingForm: true,
          ),
        ),
      );

      final updated = state.dataSubjectRight.setUpdate(
        state.currentUser.email,
        DateTime.now(),
      );

      await _dataSubjectRightRepository.updateDataSubjectRight(
        updated,
        state.currentUser.currentCompany,
      );

      emit(
        state.copyWith(
          dataSubjectRight: updated,
          initialDataSubjectRight: updated,
          stepIndex: 1,
          loadingStatus: state.loadingStatus.copyWith(
            verifyingForm: false,
          ),
        ),
      );

      return;
    }

    onNextStepPressed(stepLength);
  }

  Future<void> submitConsiderRequest(String processRequestId) async {
    emit(
      state.copyWith(
        loadingStatus: state.loadingStatus.copyWith(
          consideringRequest: processRequestId,
        ),
      ),
    );

    final updated = state.dataSubjectRight.setUpdate(
      state.currentUser.email,
      DateTime.now(),
    );

    await _dataSubjectRightRepository.updateDataSubjectRight(
      updated,
      state.currentUser.currentCompany,
    );

    emit(
      state.copyWith(
        dataSubjectRight: updated,
        initialDataSubjectRight: updated,
        loadingStatus: state.loadingStatus.copyWith(
          consideringRequest: '',
        ),
      ),
    );

    return;
  }

  Future<void> submitProcessRequest(String processRequestId) async {
    emit(
      state.copyWith(
        loadingStatus: state.loadingStatus.copyWith(
          processingRequest: processRequestId,
        ),
      ),
    );

    final updated = state.dataSubjectRight.setUpdate(
      state.currentUser.email,
      DateTime.now(),
    );

    await _dataSubjectRightRepository.updateDataSubjectRight(
      updated,
      state.currentUser.currentCompany,
    );

    emit(
      state.copyWith(
        dataSubjectRight: updated,
        initialDataSubjectRight: updated,
        loadingStatus: state.loadingStatus.copyWith(
          processingRequest: '',
        ),
      ),
    );

    return;
  }

  void setRequestExpand(String processRequestId) {
    if (!state.requestExpanded.contains(processRequestId)) {
      emit(
        state.copyWith(
          requestExpanded: state.requestExpanded.map((id) => id).toList()
            ..add(processRequestId),
        ),
      );
    } else {
      emit(
        state.copyWith(
          requestExpanded: state.requestExpanded.map((id) => id).toList()
            ..remove(processRequestId),
        ),
      );
    }
  }

  void setVerifyOption(RequestResultStatus value) {
    final updated = state.dataSubjectRight.copyWith(
      verifyFormStatus: value,
    );
    emit(
      state.copyWith(
        dataSubjectRight: updated,
        verifyError: value == RequestResultStatus.none,
      ),
    );
  }

  void setRejectVerifyReason(String value) {
    final updated = state.dataSubjectRight.copyWith(
      rejectVerifyReason: value.isNotEmpty ? value : '',
    );
    emit(state.copyWith(dataSubjectRight: updated));
  }

  void setConsiderOption(RequestResultStatus value, String processRequestId) {
    DataSubjectRightModel dataSubjectRight = state.dataSubjectRight;
    List<ProcessRequestModel> processRequests = [];

    for (ProcessRequestModel process in dataSubjectRight.processRequests) {
      if (process.id == processRequestId) {
        processRequests.add(
          process.copyWith(considerRequestStatus: value),
        );
      } else {
        processRequests.add(process);
      }
    }

    List<String> considerError = state.considerError.map((id) => id).toList();
    if (value == RequestResultStatus.none) {
      if (!considerError.contains(processRequestId)) {
        considerError.add(processRequestId);
      }
    } else {
      if (considerError.contains(processRequestId)) {
        considerError.remove(processRequestId);
      }
    }

    emit(
      state.copyWith(
        dataSubjectRight: dataSubjectRight.copyWith(
          processRequests: processRequests,
        ),
        considerError: considerError,
      ),
    );
  }

  void setRejectConsiderReason(String value, String processRequestId) {
    DataSubjectRightModel dataSubjectRight = state.dataSubjectRight;
    List<ProcessRequestModel> processRequests = [];

    for (ProcessRequestModel process in dataSubjectRight.processRequests) {
      if (process.id == processRequestId) {
        processRequests.add(
          process.copyWith(rejectConsiderReason: value.isNotEmpty ? value : ''),
        );
      } else {
        processRequests.add(process);
      }
    }

    emit(
      state.copyWith(
        dataSubjectRight: dataSubjectRight.copyWith(
          processRequests: processRequests,
        ),
      ),
    );
  }

  Future<void> uploadProofOfActionFile(
    Uint8List data,
    String fileName,
    String path,
    String processRequestId,
  ) async {
    final result = await _generalRepository.uploadFile(
      data,
      fileName,
      path,
    );

    result.fold(
      (failure) {},
      (fileUrl) {
        DataSubjectRightModel dataSubjectRight = state.dataSubjectRight;
        List<ProcessRequestModel> processRequests = [];

        for (ProcessRequestModel process in dataSubjectRight.processRequests) {
          if (process.id == processRequestId) {
            processRequests.add(
              process.copyWith(proofOfActionFile: fileUrl),
            );
          } else {
            processRequests.add(process);
          }
        }

        emit(
          state.copyWith(
            dataSubjectRight: dataSubjectRight.copyWith(
              processRequests: processRequests,
            ),
          ),
        );
      },
    );
  }

  Future<void> downloadProofFile(String path) async {
    await _generalRepository.downloadFirebaseStorageFile(path);
  }

  void setProofOfActionText(
    String value,
    String processRequestId,
  ) async {
    DataSubjectRightModel dataSubjectRight = state.dataSubjectRight;
    List<ProcessRequestModel> processRequests = [];

    for (ProcessRequestModel process in dataSubjectRight.processRequests) {
      if (process.id == processRequestId) {
        processRequests.add(
          process.copyWith(proofOfActionText: value),
        );
      } else {
        processRequests.add(process);
      }
    }

    emit(
      state.copyWith(
        dataSubjectRight: dataSubjectRight.copyWith(
          processRequests: processRequests,
        ),
      ),
    );
  }
}
