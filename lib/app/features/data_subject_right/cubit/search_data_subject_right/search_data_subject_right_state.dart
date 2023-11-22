// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_data_subject_right_cubit.dart';

class SearchDataSubjectRightState extends Equatable {
  const SearchDataSubjectRightState({
    required this.initialDataSubjectRights,
    required this.dataSubjectRights,
    required this.initialRequesterInputs,
    required this.requesterInputs,
  });

  final List<DataSubjectRightModel> initialDataSubjectRights;
  final List<DataSubjectRightModel> dataSubjectRights;
  final List<RequesterInputModel> initialRequesterInputs;
  final List<RequesterInputModel> requesterInputs;

  SearchDataSubjectRightState copyWith({
    List<DataSubjectRightModel>? initialDataSubjectRights,
    List<DataSubjectRightModel>? dataSubjectRights,
    List<RequesterInputModel>? initialRequesterInputs,
    List<RequesterInputModel>? requesterInputs,
  }) {
    return SearchDataSubjectRightState(
      initialDataSubjectRights: initialDataSubjectRights ?? this.initialDataSubjectRights,
      dataSubjectRights: dataSubjectRights ?? this.dataSubjectRights,
      initialRequesterInputs: initialRequesterInputs ?? this.initialRequesterInputs,
      requesterInputs: requesterInputs ?? this.requesterInputs,
    );
  }
  
  @override
  List<Object> get props => [
    initialDataSubjectRights,
    dataSubjectRights,
    initialRequesterInputs,
    requesterInputs,
  ];

}

