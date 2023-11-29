part of 'process_data_subject_right_cubit.dart';

class ProcessDataSubjectRightState extends Equatable {
  const ProcessDataSubjectRightState({
    required this.dataSubjectRight,
    required this.initialDataSubjectRight,
    required this.rejectTypes,
    required this.processRequestSelected,
    required this.currentUser,
    required this.userEmails,
    required this.stepIndex,
    required this.requestExpanded,
    required this.verifyError,
    required this.considerError,
    required this.rejectError,
    required this.loadingStatus,
  });

  final DataSubjectRightModel dataSubjectRight;
  final DataSubjectRightModel initialDataSubjectRight;
  final List<RejectTypeModel> rejectTypes;
  final String processRequestSelected;
  final UserModel currentUser;
  final List<String> userEmails;
  final int stepIndex;
  final List<String> requestExpanded;
  final bool verifyError;
  final List<String> considerError;
  final bool rejectError;
  final ProcessRequestLoadingStatus loadingStatus;

  ProcessDataSubjectRightState copyWith({
    DataSubjectRightModel? dataSubjectRight,
    DataSubjectRightModel? initialDataSubjectRight,
    List<RejectTypeModel>? rejectTypes,
    String? processRequestSelected,
    UserModel? currentUser,
    List<String>? userEmails,
    int? stepIndex,
    List<String>? requestExpanded,
    bool? verifyError,
    List<String>? considerError,
    bool? rejectError,
    ProcessRequestLoadingStatus? loadingStatus,
  }) {
    return ProcessDataSubjectRightState(
      dataSubjectRight: dataSubjectRight ?? this.dataSubjectRight,
      initialDataSubjectRight:
          initialDataSubjectRight ?? this.initialDataSubjectRight,
      rejectTypes: rejectTypes ?? this.rejectTypes,
      processRequestSelected:
          processRequestSelected ?? this.processRequestSelected,
      currentUser: currentUser ?? this.currentUser,
      userEmails: userEmails ?? this.userEmails,
      stepIndex: stepIndex ?? this.stepIndex,
      requestExpanded: requestExpanded ?? this.requestExpanded,
      verifyError: verifyError ?? this.verifyError,
      considerError: considerError ?? this.considerError,
      rejectError: rejectError ?? this.rejectError,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }

  @override
  List<Object> get props {
    return [
      dataSubjectRight,
      initialDataSubjectRight,
      rejectTypes,
      processRequestSelected,
      currentUser,
      userEmails,
      stepIndex,
      requestExpanded,
      verifyError,
      considerError,
      rejectError,
      loadingStatus,
    ];
  }
}
