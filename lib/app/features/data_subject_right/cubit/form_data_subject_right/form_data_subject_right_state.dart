// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'form_data_subject_right_cubit.dart';

class FormDataSubjectRightState extends Equatable {
  const FormDataSubjectRightState({
    required this.dataSubjectRight,
    required this.currentPage,
  });

  final DataSubjectRightModel dataSubjectRight;
  final int currentPage;

  FormDataSubjectRightState copyWith({
    int? currentPage,
    DataSubjectRightModel? dataSubjectRight,
  }) {
    return FormDataSubjectRightState(
      currentPage: currentPage ?? this.currentPage,
      dataSubjectRight: dataSubjectRight ?? this.dataSubjectRight,
    );
  }

  @override
  List<Object> get props => [
        currentPage,
        dataSubjectRight,
      ];
}
