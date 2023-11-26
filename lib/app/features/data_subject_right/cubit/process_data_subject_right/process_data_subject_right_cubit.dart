import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/email_js/process_request_params.dart';
import 'package:pdpa/app/data/repositories/data_subject_right_repository.dart';
import 'package:pdpa/app/data/repositories/emailjs_repository.dart';
import 'package:pdpa/app/data/repositories/general_repository.dart';
import 'package:pdpa/app/features/data_subject_right/models/process_request_loading_status.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'process_data_subject_right_state.dart';

class ProcessDataSubjectRightCubit extends Cubit<ProcessDataSubjectRightState> {
  ProcessDataSubjectRightCubit({
    required DataSubjectRightRepository dataSubjectRightRepository,
    required GeneralRepository generalRepository,
    required EmailJsRepository emailJsRepository,
  })  : _dataSubjectRightRepository = dataSubjectRightRepository,
        _generalRepository = generalRepository,
        _emailJsRepository = emailJsRepository,
        super(ProcessDataSubjectRightState(
          dataSubjectRight: DataSubjectRightModel.empty(),
          initialDataSubjectRight: DataSubjectRightModel.empty(),
          processRequestSelected: '',
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
  final EmailJsRepository _emailJsRepository;

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
    if (dataSubjectRight.verifyFormStatus == RequestResultStatus.fail) {
      emit(
        state.copyWith(
          dataSubjectRight: dataSubjectRight,
          initialDataSubjectRight: dataSubjectRight,
          processRequestSelected: processRequestSelected,
          currentUser: currentUser,
          userEmails: userEmails,
          stepIndex: 2,
          requestExpanded: [processRequestSelected],
        ),
      );

      return;
    }

    for (ProcessRequestModel request in dataSubjectRight.processRequests) {
      if (request.id == processRequestSelected) {
        if (request.considerRequestStatus == RequestResultStatus.fail ||
            request.proofOfActionText.isNotEmpty) {
          stepIndex = 2;
        }
      }
    }

    emit(
      state.copyWith(
        dataSubjectRight: dataSubjectRight,
        initialDataSubjectRight: dataSubjectRight,
        processRequestSelected: processRequestSelected,
        currentUser: currentUser,
        userEmails: userEmails,
        stepIndex: stepIndex,
        requestExpanded: [processRequestSelected],
      ),
    );
  }

  void onBackStepPressed() {
    if (state.stepIndex == 2 &&
        state.dataSubjectRight.verifyFormStatus == RequestResultStatus.fail) {
      emit(state.copyWith(stepIndex: 0));
      return;
    }

    if (state.stepIndex > 0) {
      emit(state.copyWith(stepIndex: state.stepIndex - 1));
    }
  }

  void onNextStepPressed(int stepLength) {
    if (state.stepIndex < (stepLength - 1)) {
      emit(state.copyWith(stepIndex: state.stepIndex + 1));
    }
  }

  Future<void> onVerifyFormValidate(
    int stepLength, {
    ProcessRequestTemplateParams? emailParams,
  }) async {
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

      //? Update data subject right
      final updated = state.dataSubjectRight.setUpdate(
        state.currentUser.email,
        DateTime.now(),
      );

      await _dataSubjectRightRepository.updateDataSubjectRight(
        updated,
        state.currentUser.currentCompany,
      );

      //? Send email to requester
      if (emailParams != null) {
        await _emailJsRepository.sendEmail(
          AppConfig.verificationTemplateId,
          emailParams.toMap(),
        );
      }

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
    } else if (state.initialDataSubjectRight.verifyFormStatus ==
        RequestResultStatus.fail) {
      emit(state.copyWith(stepIndex: 2));

      return;
    }

    onNextStepPressed(stepLength);
  }

  Future<void> submitConsiderRequest(
    String processRequestId, {
    ProcessRequestTemplateParams? toRequesterParams,
    ProcessRequestTemplateParams? toUserParams,
  }) async {
    ProcessRequestModel currentRequest = ProcessRequestModel.empty();

    for (ProcessRequestModel request
        in state.dataSubjectRight.processRequests) {
      if (request.id == processRequestId) {
        currentRequest = request;

        final noOptionSelected =
            request.considerRequestStatus == RequestResultStatus.none;
        if (noOptionSelected) {
          List<String> considerError =
              state.considerError.map((id) => id).toList();

          if (!considerError.contains(processRequestId)) {
            considerError.add(processRequestId);
          } else {
            considerError.remove(processRequestId);
          }

          emit(state.copyWith(considerError: considerError));
          return;
        }
      }
    }

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

    //? Send email to requester
    if (toRequesterParams != null) {
      await _emailJsRepository.sendEmail(
        AppConfig.requestTemplateId,
        toRequesterParams.toMap(),
      );
    }

    //? Send email to another user
    if (toUserParams != null) {
      for (ProcessRequestModel request in updated.processRequests) {
        if (request.id == processRequestId) {
          for (String email in request.notifyEmail) {
            await _emailJsRepository.sendEmail(
              AppConfig.processDsrTemplateId,
              toUserParams.copyWith(toEmail: email).toMap(),
            );
          }
        }
      }
    }

    emit(
      state.copyWith(
        dataSubjectRight: updated,
        initialDataSubjectRight: updated,
        stepIndex:
            currentRequest.considerRequestStatus == RequestResultStatus.fail
                ? 2
                : state.stepIndex,
        loadingStatus: state.loadingStatus.copyWith(
          consideringRequest: '',
        ),
      ),
    );

    return;
  }

  Future<void> submitProcessRequest(
    String processRequestId, {
    ProcessRequestTemplateParams? toRequesterParams,
    ProcessRequestTemplateParams? toUserParams,
  }) async {
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

    //? Send email to requester
    if (toRequesterParams != null) {
      await _emailJsRepository.sendEmail(
        toRequesterParams.link.isNotEmpty
            ? AppConfig.requestWithProofTemplateId
            : AppConfig.requestTemplateId,
        toRequesterParams.toMap(),
      );
    }

    //? Send email to another user
    if (toUserParams != null) {
      for (ProcessRequestModel request in updated.processRequests) {
        if (request.id == processRequestId) {
          for (String email in request.notifyEmail) {
            await _emailJsRepository.sendEmail(
              AppConfig.processDsrTemplateId,
              toUserParams.copyWith(toEmail: email).toMap(),
            );
          }
        }
      }
    }

    emit(
      state.copyWith(
        dataSubjectRight: updated,
        initialDataSubjectRight: updated,
        stepIndex: 2,
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

  void selectNotifyEmail(String email, String processRequestId) {
    DataSubjectRightModel dataSubjectRight = state.dataSubjectRight;
    List<ProcessRequestModel> processRequests = [];

    for (ProcessRequestModel request in dataSubjectRight.processRequests) {
      if (request.id == processRequestId) {
        List<String> notifyEmail =
            request.notifyEmail.map((email) => email).toList();

        if (!notifyEmail.contains(email)) {
          notifyEmail.add(email);
        } else {
          notifyEmail.remove(email);
        }

        processRequests.add(
          request.copyWith(notifyEmail: notifyEmail),
        );
      } else {
        processRequests.add(request);
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

  Future<void> downloadFile(String path) async {
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
