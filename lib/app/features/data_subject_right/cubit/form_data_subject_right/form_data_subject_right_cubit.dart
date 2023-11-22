// ignore: depend_on_referenced_packages

import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/power_verification_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_verification_model.dart';
import 'package:pdpa/app/data/repositories/general_repository.dart';

part 'form_data_subject_right_state.dart';

class FormDataSubjectRightCubit extends Cubit<FormDataSubjectRightState> {
  FormDataSubjectRightCubit({
    required GeneralRepository generalRepository,
  })  : _generalRepository = generalRepository,
        super(
          FormDataSubjectRightState(
            currentPage: 0,
            dataSubjectRight: DataSubjectRightModel.empty(),
          ),
        );

  final GeneralRepository _generalRepository;

  void setDataSubjectRight(DataSubjectRightModel dataSubjectRight) {
    emit(state.copyWith(dataSubjectRight: dataSubjectRight));
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
}
