part of 'process_data_subject_right_cubit.dart';

class ProcessDataSubjectRightState extends Equatable {
  const ProcessDataSubjectRightState({
    required this.dataSubjectRight,
    required this.initialDataSubjectRight,
    required this.stepIndex,
    required this.progressedIndex,
    required this.verifySelected,
    required this.considerSelected,
    required this.verifyError,
    required this.considerError,
    required this.endProcess,
  });

  final DataSubjectRightModel dataSubjectRight;
  final DataSubjectRightModel initialDataSubjectRight;
  final int stepIndex;
  final int progressedIndex;
  final int verifySelected;
  final int considerSelected;
  final bool verifyError;
  final bool considerError;
  final bool endProcess;

  ProcessDataSubjectRightState copyWith({
    DataSubjectRightModel? dataSubjectRight,
    DataSubjectRightModel? initialDataSubjectRight,
    int? stepIndex,
    int? progressedIndex,
    int? verifySelected,
    int? considerSelected,
    bool? verifyError,
    bool? considerError,
    bool? endProcess,
  }) {
    return ProcessDataSubjectRightState(
      dataSubjectRight: dataSubjectRight ?? this.dataSubjectRight,
      initialDataSubjectRight:
          initialDataSubjectRight ?? this.initialDataSubjectRight,
      stepIndex: stepIndex ?? this.stepIndex,
      progressedIndex: progressedIndex ?? this.progressedIndex,
      verifySelected: verifySelected ?? this.verifySelected,
      considerSelected: considerSelected ?? this.considerSelected,
      verifyError: verifyError ?? this.verifyError,
      considerError: considerError ?? this.considerError,
      endProcess: endProcess ?? this.endProcess,
    );
  }

  @override
  List<Object> get props {
    return [
      dataSubjectRight,
      initialDataSubjectRight,
      stepIndex,
      progressedIndex,
      verifySelected,
      considerSelected,
      verifyError,
      considerError,
      endProcess,
    ];
  }
}
