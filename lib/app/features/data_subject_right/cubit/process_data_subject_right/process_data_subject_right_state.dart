part of 'process_data_subject_right_cubit.dart';

class ProcessDataSubjectRightState extends Equatable {
  const ProcessDataSubjectRightState({
    required this.dataSubjectRight,
    required this.initialDataSubjectRight,
    required this.processRequestSelected,
    required this.currentUser,
    required this.userEmails,
    required this.stepIndex,
    required this.requestExpanded,
    required this.verifyError,
    required this.considerError,
    required this.loadingStatus,
  });

  final DataSubjectRightModel dataSubjectRight;
  final DataSubjectRightModel initialDataSubjectRight;
  final String processRequestSelected;
  final UserModel currentUser;
  final List<String> userEmails;
  final int stepIndex;
  final List<String> requestExpanded;
  final bool verifyError;
  final List<String> considerError;
  final ProcessRequestLoadingStatus loadingStatus;

  ProcessDataSubjectRightState copyWith({
    DataSubjectRightModel? dataSubjectRight,
    DataSubjectRightModel? initialDataSubjectRight,
    String? processRequestSelected,
    UserModel? currentUser,
    List<String>? userEmails,
    int? stepIndex,
    List<String>? requestExpanded,
    bool? verifyError,
    List<String>? considerError,
    ProcessRequestLoadingStatus? loadingStatus,
  }) {
    return ProcessDataSubjectRightState(
      dataSubjectRight: dataSubjectRight ?? this.dataSubjectRight,
      initialDataSubjectRight:
          initialDataSubjectRight ?? this.initialDataSubjectRight,
      processRequestSelected:
          processRequestSelected ?? this.processRequestSelected,
      currentUser: currentUser ?? this.currentUser,
      userEmails: userEmails ?? this.userEmails,
      stepIndex: stepIndex ?? this.stepIndex,
      requestExpanded: requestExpanded ?? this.requestExpanded,
      verifyError: verifyError ?? this.verifyError,
      considerError: considerError ?? this.considerError,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }

  @override
  List<Object> get props {
    return [
      dataSubjectRight,
      initialDataSubjectRight,
      processRequestSelected,
      currentUser,
      userEmails,
      stepIndex,
      requestExpanded,
      verifyError,
      considerError,
      loadingStatus,
    ];
  }
}
