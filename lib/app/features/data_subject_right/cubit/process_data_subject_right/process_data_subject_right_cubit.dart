import 'dart:io';
import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/repositories/general_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'process_data_subject_right_state.dart';

class ProcessDataSubjectRightCubit extends Cubit<ProcessDataSubjectRightState> {
  ProcessDataSubjectRightCubit({
    required GeneralRepository generalRepository,
  })  : _generalRepository = generalRepository,
        super(ProcessDataSubjectRightState(
          dataSubjectRight: DataSubjectRightModel.empty(),
          initialDataSubjectRight: DataSubjectRightModel.empty(),
          stepIndex: 0,
          progressedIndex: 0,
          verifySelected: 0,
          considerSelected: 0,
          verifyError: false,
          considerError: false,
          endProcess: false,
        ));

  final GeneralRepository _generalRepository;

  void initialSettings(DataSubjectRightModel dataSubjectRight) {
    emit(
      state.copyWith(
        dataSubjectRight: dataSubjectRight,
        initialDataSubjectRight: dataSubjectRight,
      ),
    );
  }

  void onNextStepPressed(int stepLength) {
    //? Validate each step
    if (state.stepIndex == 0) {
      if (state.verifySelected == 0) {
        emit(state.copyWith(verifyError: state.verifySelected == 0));
        return;
      }

      //? If choose reject, reject verify reason should not empty
      if (state.verifySelected == 2 &&
          state.dataSubjectRight.rejectVerifyReason.isEmpty) {
        return;
      }

      //? If choose reject verify, should be end process
      if (state.verifySelected == 2 &&
          state.dataSubjectRight.rejectVerifyReason.isNotEmpty) {
        emit(
          state.copyWith(
            progressedIndex: 1,
            endProcess: true,
          ),
        );
        return;
      }
    } else if (state.stepIndex == 1) {
      if (state.considerSelected == 0) {
        emit(state.copyWith(considerError: state.considerSelected == 0));
        return;
      }

      // //? If choose reject, reject consider reason should not empty
      // if (state.considerSelected == 2 &&
      //     state.dataSubjectRight.rejectConsiderReason.isEmpty) {
      //   return;
      // }

      // //? If choose reject consider, should be end process
      // if (state.considerSelected == 2 &&
      //     state.dataSubjectRight.rejectConsiderReason.isNotEmpty) {
      //   emit(state.copyWith(
      //     progressedIndex: 2,
      //     endProcess: true,
      //   ));
      //   return;
      // }
    } else if (state.stepIndex == 2) {}

    //? Update progress index
    if (state.stepIndex < stepLength) {
      emit(
        state.copyWith(
          stepIndex: state.stepIndex + 1,
          progressedIndex: state.progressedIndex + 1,
        ),
      );
    }
  }

  void setVerifyOption(int value) {
    final updated = state.dataSubjectRight.copyWith(
      verifyFormStatus: value == 0
          ? RequestResultStatus.none
          : value == 1
              ? RequestResultStatus.pass
              : RequestResultStatus.fail,
    );
    emit(
      state.copyWith(
        dataSubjectRight: updated,
        verifySelected: value,
        verifyError: value == 0,
      ),
    );
  }

  void setConsiderOption(int value) {
    // final updated = state.dataSubjectRight.copyWith(
    //   considerFormStatus: value == 0
    //       ? RequestResultStatus.none
    //       : value == 1
    //           ? RequestResultStatus.pass
    //           : RequestResultStatus.fail,
    // );
    // emit(
    //   state.copyWith(
    //     dataSubjectRight: updated,
    //     considerSelected: value,
    //     considerError: value == 0,
    //   ),
    // );
  }

  void setRejectVerifyReason(String value) {
    final updated = state.dataSubjectRight.copyWith(
      rejectVerifyReason: value.isNotEmpty ? value : '',
    );
    emit(state.copyWith(dataSubjectRight: updated));
  }

  void setRejectConsiderReason(String value) {
    // final updated = state.dataSubjectRight.copyWith(
    //   rejectConsiderReason: value.isNotEmpty ? value : '',
    // );
    // emit(state.copyWith(dataSubjectRight: updated));
  }

  Future<void> uploadProofFile(
    File? file,
    Uint8List? data,
    String fileName,
    String path,
    String processRequestId,
  ) async {
    final result = await _generalRepository.uploadFile(
      file,
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
    await _generalRepository.downloadFile(path);
  }

  void setProofText(
    String text,
    String processRequestId,
  ) async {
    DataSubjectRightModel dataSubjectRight = state.dataSubjectRight;
    List<ProcessRequestModel> processRequests = [];

    for (ProcessRequestModel process in dataSubjectRight.processRequests) {
      if (process.id == processRequestId) {
        processRequests.add(
          process.copyWith(proofOfActionText: text),
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
