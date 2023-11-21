// ignore: depend_on_referenced_packages

import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
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
}
