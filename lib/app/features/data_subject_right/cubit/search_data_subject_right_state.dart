part of 'search_data_subject_right_cubit.dart';

class SearchDataSubjectRightState extends Equatable {
  const SearchDataSubjectRightState({
     required this.initialdataSubjectRights,
    required this.dataSubjectRights,
    required this.initialprocessRequests,
    required this.processRequests,
    required this.initialrequesterInputs,
    required this.requesterInputs,
    required this.initialrequesterVerifications,
    required this.requesterVerifications,
  });

  final List<DataSubjectRightModel> initialdataSubjectRights;
  final List<DataSubjectRightModel> dataSubjectRights;
  final List<ProcessRequestModel> initialprocessRequests;
  final List<ProcessRequestModel> processRequests;
  final List<RequesterInputModel> initialrequesterInputs;
  final List<RequesterInputModel> requesterInputs;
  final List<RequesterVerificationModel> initialrequesterVerifications;
  final List<RequesterVerificationModel> requesterVerifications;

    SearchDataSubjectRightState copyWith({
    final List<DataSubjectRightModel>? initialdataSubjectRights,
    final List<DataSubjectRightModel>? dataSubjectRights,
  final List<ProcessRequestModel>? initialprocessRequests,
  final List<ProcessRequestModel>? processRequests,
  final List<RequesterInputModel>? initialrequesterInputs,
  final List<RequesterInputModel>? requesterInputs,
  final List<RequesterVerificationModel>? initialrequesterVerifications,
  final List<RequesterVerificationModel>? requesterVerifications,

  }) {
    return SearchDataSubjectRightState(
      initialdataSubjectRights: initialdataSubjectRights ?? this.initialdataSubjectRights,
      dataSubjectRights: dataSubjectRights ?? this.dataSubjectRights,
      initialprocessRequests: initialprocessRequests ?? this.initialprocessRequests,
      processRequests: processRequests ?? this.processRequests,
      initialrequesterInputs: initialrequesterInputs ?? this.initialrequesterInputs,
      requesterInputs: requesterInputs ?? this.requesterInputs,
      initialrequesterVerifications: initialrequesterVerifications ?? this.initialrequesterVerifications,
      requesterVerifications: requesterVerifications ?? this.requesterVerifications,
    );
  }

  @override
  List<Object> get props => [
    initialdataSubjectRights,
    dataSubjectRights,
    initialprocessRequests,
    processRequests,
    initialrequesterInputs,
    requesterInputs,
    initialrequesterVerifications,
    requesterVerifications,
  ];
}
