// ignore: depend_on_referenced_packages
import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';

import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_verification_model.dart';
import 'package:pdpa/app/data/models/etc/user_input_text.dart';
import 'package:pdpa/app/data/repositories/data_subject_right_repository.dart';
import 'package:pdpa/app/data/repositories/general_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'form_data_subject_right_state.dart';

class FormDataSubjectRightCubit extends Cubit<FormDataSubjectRightState> {
  FormDataSubjectRightCubit({
    required GeneralRepository generalRepository,
    required DataSubjectRightRepository dataSubjectRightRepository,
  })  : _generalRepository = generalRepository,
        _dataSubjectRightRepository = dataSubjectRightRepository,
        super(
          FormDataSubjectRightState(
            currentPage: 0,
            dataSubjectRight: DataSubjectRightModel.empty(),
            isAcknowledge: false,
            requestFormState: RequestFormState.requesting,
          ),
        );

  final GeneralRepository _generalRepository;
  final DataSubjectRightRepository _dataSubjectRightRepository;

  void setDataSubjectRight(DataSubjectRightModel dataSubjectRight) {
    emit(state.copyWith(dataSubjectRight: dataSubjectRight));
  }

  void setAcknowledge(bool isCheck) {
    emit(state.copyWith(isAcknowledge: isCheck));
  }

  void setSubmited() {
    emit(state.copyWith(requestFormState: RequestFormState.summarize));
  }

  void nextPage(int page) {
    emit(state.copyWith(currentPage: page));
  }

  void previousPage(int page) {
    emit(state.copyWith(currentPage: page));
  }

  void formDataSubjectRightPowerChecked(String powerOfAttorneyId) {
    if (powerOfAttorneyId.isEmpty) return;
    List<RequesterVerificationModel> powerVerifications =
        state.dataSubjectRight.powerVerifications.isNotEmpty
            ? state.dataSubjectRight.powerVerifications
                .map((verification) => verification)
                .toList()
            : [];
    List<String> powerOfAttorneys =
        state.dataSubjectRight.powerVerifications.isNotEmpty
            ? state.dataSubjectRight.powerVerifications
                .map((verification) => verification.id)
                .toList()
            : [];

    if (powerOfAttorneys.contains(powerOfAttorneyId)) {
      powerVerifications
          .removeWhere((verification) => verification.id == powerOfAttorneyId);
    } else {
      final verification = const RequesterVerificationModel.empty()
          .copyWith(id: powerOfAttorneyId);
      powerVerifications.add(verification);
    }

    final update = state.dataSubjectRight.copyWith(
      powerVerifications: powerVerifications,
    );
    emit(state.copyWith(dataSubjectRight: update));
  }

  void formDataSubjectRightIdentityChecked(String powerOfAttorneyId) {
    if (powerOfAttorneyId.isEmpty) return;
    List<RequesterVerificationModel> identityVerifications =
        state.dataSubjectRight.identityVerifications.isNotEmpty
            ? state.dataSubjectRight.identityVerifications
                .map((verification) => verification)
                .toList()
            : [];
    List<String> powerOfAttorneys =
        state.dataSubjectRight.identityVerifications.isNotEmpty
            ? state.dataSubjectRight.identityVerifications
                .map((verification) => verification.id)
                .toList()
            : [];

    if (powerOfAttorneys.contains(powerOfAttorneyId)) {
      identityVerifications
          .removeWhere((verification) => verification.id == powerOfAttorneyId);
    } else {
      final verification = const RequesterVerificationModel.empty()
          .copyWith(id: powerOfAttorneyId);
      identityVerifications.add(verification);
    }

    final update = state.dataSubjectRight.copyWith(
      identityVerifications: identityVerifications,
    );
    emit(state.copyWith(dataSubjectRight: update));
  }

  void formDataSubjectRightProcessRequestChecked(String processRequestModelId) {
    if (processRequestModelId.isEmpty) return;
    List<ProcessRequestModel> processRequests =
        state.dataSubjectRight.processRequests.isNotEmpty
            ? state.dataSubjectRight.processRequests
                .map((verification) => verification)
                .toList()
            : [];
    List<String> requests = state.dataSubjectRight.processRequests.isNotEmpty
        ? state.dataSubjectRight.processRequests
            .map((verification) => verification.id)
            .toList()
        : [];

    if (requests.contains(processRequestModelId)) {
      processRequests.removeWhere(
          (verification) => verification.id == processRequestModelId);
    } else {
      final verification = ProcessRequestModel.empty().copyWith(
          id: processRequestModelId, requestType: processRequestModelId);
      processRequests.add(verification);
    }

    final update = state.dataSubjectRight.copyWith(
      processRequests: processRequests,
    );
    emit(state.copyWith(dataSubjectRight: update));
  }

  void formDataSubjectRightReasonChecked(
    String requestId,
    String reasonId,
  ) {
    List<ProcessRequestModel> processRequests = [];
    for (ProcessRequestModel request
        in state.dataSubjectRight.processRequests) {
      if (request.requestType == requestId) {
        List<UserInputText> reasonInputs =
            request.reasonTypes.map((reason) => reason).toList();
        final isReasonFound =
            reasonInputs.map((reason) => reason.id).toList().contains(reasonId);

        if (isReasonFound) {
          reasonInputs.removeWhere((reason) => reason.id == reasonId);
        } else {
          final reasonInput = UserInputText(
            id: reasonId,
            text: '',
          );
          reasonInputs.add(reasonInput);
        }
        processRequests.add(request.copyWith(
          reasonTypes: reasonInputs,
        ));
      } else {
        processRequests.add(request);
      }
    }
    final newDataRequest = state.dataSubjectRight.copyWith(
      processRequests: processRequests,
    );
    emit(state.copyWith(
      dataSubjectRight: newDataRequest,
    ));
  }

  void formDataSubjectRightReasonInput(
    String text,
    String requestId,
    String reasonId,
  ) {
    List<ProcessRequestModel> processRequests = [];
    for (ProcessRequestModel request
        in state.dataSubjectRight.processRequests) {
      List<UserInputText> reasonInputs = [];
      for (UserInputText reason in request.reasonTypes) {
        if (reason.id == reasonId) {
          reasonInputs.add(reason.copyWith(
            text: text,
          ));
        } else {
          reasonInputs.add(reason);
        }
      }
      processRequests.add(request.copyWith(
        reasonTypes: reasonInputs,
      ));
    }
    final newDataRequest = state.dataSubjectRight.copyWith(
      processRequests: processRequests,
    );

    emit(state.copyWith(
      dataSubjectRight: newDataRequest,
    ));
  }

  Future<void> uploadPowerVerificationFile(
    Uint8List data,
    String fileName,
    String path,
    String powerVerificationId,
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
        List<RequesterVerificationModel> requesterVerification = [];

        for (RequesterVerificationModel form
            in dataSubjectRight.powerVerifications) {
          if (form.id == powerVerificationId) {
            requesterVerification.add(
              form.copyWith(imageUrl: fileUrl),
            );
          } else {
            requesterVerification.add(form);
          }
        }

        emit(
          state.copyWith(
            dataSubjectRight: dataSubjectRight.copyWith(
              powerVerifications: requesterVerification,
            ),
          ),
        );
      },
    );
  }

  Future<void> uploadIdentityProofingFile(
    Uint8List data,
    String fileName,
    String path,
    String identityProofingId,
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
        List<RequesterVerificationModel> requesterVerification = [];

        for (RequesterVerificationModel form
            in dataSubjectRight.identityVerifications) {
          if (form.id == identityProofingId) {
            requesterVerification.add(
              form.copyWith(imageUrl: fileUrl),
            );
          } else {
            requesterVerification.add(form);
          }
        }

        emit(
          state.copyWith(
            dataSubjectRight: dataSubjectRight.copyWith(
              identityVerifications: requesterVerification,
            ),
          ),
        );
      },
    );
  }

  Future<void> removeIdentityProofingFile(
    String identityProofingId,
  ) async {
    DataSubjectRightModel dataSubjectRight = state.dataSubjectRight;
    List<RequesterVerificationModel> requesterVerification = [];

    for (RequesterVerificationModel form
        in dataSubjectRight.identityVerifications) {
      if (form.id == identityProofingId) {
        requesterVerification.add(
          form.copyWith(imageUrl: ''),
        );
      } else {
        requesterVerification.add(form);
      }
    }

    emit(
      state.copyWith(
        dataSubjectRight: dataSubjectRight.copyWith(
          identityVerifications: requesterVerification,
        ),
      ),
    );
  }

  Future<void> removePowerVerificationFile(
    String powerVerificationId,
  ) async {
    DataSubjectRightModel dataSubjectRight = state.dataSubjectRight;
    List<RequesterVerificationModel> requesterVerification = [];

    for (RequesterVerificationModel form
        in dataSubjectRight.powerVerifications) {
      if (form.id == powerVerificationId) {
        requesterVerification.add(
          form.copyWith(imageUrl: ''),
        );
      } else {
        requesterVerification.add(form);
      }
    }

    emit(
      state.copyWith(
        dataSubjectRight: dataSubjectRight.copyWith(
          powerVerifications: requesterVerification,
        ),
      ),
    );
  }

  Future<void> createDatasubjectRight(
    String companyId,
  ) async {
    final requester = state.dataSubjectRight.dataRequester.first.text;
    final dataSubjectRight = state.dataSubjectRight.copyWith(
      dataOwner: state.dataSubjectRight.isDataOwner
          ? state.dataSubjectRight.dataRequester
          : state.dataSubjectRight.dataOwner,
      requestExpirationDate: DateTime.now().add(const Duration(days: 30)),
      createdBy: requester,
      createdDate: DateTime.now(),
      updatedBy: '',
      updatedDate: DateTime.now(),
    );

    final result = await _dataSubjectRightRepository.createDataSubjectRight(
        dataSubjectRight, companyId);
    await Future.delayed(const Duration(milliseconds: 800));
    result.fold(
      (failure) {},
      (fileUrl) {
        DataSubjectRightModel dataSubjectRight = state.dataSubjectRight;

        emit(
          state.copyWith(dataSubjectRight: dataSubjectRight),
        );
      },
    );
  }
}
