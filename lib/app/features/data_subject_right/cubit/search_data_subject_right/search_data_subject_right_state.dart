part of 'search_data_subject_right_cubit.dart';

class SearchDataSubjectRightState extends Equatable {
  const SearchDataSubjectRightState({
    required this.initialDataSubjectRightForms,
    required this.dataSubjectRightForms,
    required this.requestTypes,
  });

  final List<DataSubjectRightModel> initialDataSubjectRightForms;
  final List<DataSubjectRightModel> dataSubjectRightForms;
  final List<RequestTypeModel> requestTypes;

  SearchDataSubjectRightState copyWith({
    List<DataSubjectRightModel>? initialDataSubjectRightForms,
    List<DataSubjectRightModel>? dataSubjectRightForms,
    List<RequestTypeModel>? requestTypes,
  }) {
    return SearchDataSubjectRightState(
      initialDataSubjectRightForms:
          initialDataSubjectRightForms ?? this.initialDataSubjectRightForms,
      dataSubjectRightForms:
          dataSubjectRightForms ?? this.dataSubjectRightForms,
      requestTypes: requestTypes ?? this.requestTypes,
    );
  }

  @override
  List<Object> get props => [
        initialDataSubjectRightForms,
        dataSubjectRightForms,
        requestTypes,
      ];
}
