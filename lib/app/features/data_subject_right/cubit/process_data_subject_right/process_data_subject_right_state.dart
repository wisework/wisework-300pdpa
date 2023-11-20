part of 'process_data_subject_right_cubit.dart';

class ProcessDataSubjectRightState extends Equatable {
  const ProcessDataSubjectRightState({
    required this.dataSubjectRight,
    required this.initialDataSubjectRight,
    required this.stepIndex,
    required this.requestExpanded,
    required this.verifyError,
    required this.considerError,
  });

  final DataSubjectRightModel dataSubjectRight;
  final DataSubjectRightModel initialDataSubjectRight;
  final int stepIndex;
  final List<String> requestExpanded;
  final bool verifyError;
  final List<String> considerError;

  ProcessDataSubjectRightState copyWith({
    DataSubjectRightModel? dataSubjectRight,
    DataSubjectRightModel? initialDataSubjectRight,
    int? stepIndex,
    List<String>? requestExpanded,
    bool? verifyError,
    List<String>? considerError,
  }) {
    return ProcessDataSubjectRightState(
      dataSubjectRight: dataSubjectRight ?? this.dataSubjectRight,
      initialDataSubjectRight:
          initialDataSubjectRight ?? this.initialDataSubjectRight,
      stepIndex: stepIndex ?? this.stepIndex,
      requestExpanded: requestExpanded ?? this.requestExpanded,
      verifyError: verifyError ?? this.verifyError,
      considerError: considerError ?? this.considerError,
    );
  }

  @override
  List<Object> get props {
    return [
      dataSubjectRight,
      initialDataSubjectRight,
      stepIndex,
      requestExpanded,
      verifyError,
      considerError,
    ];
  }
}
