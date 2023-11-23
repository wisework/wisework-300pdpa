// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'form_data_subject_right_cubit.dart';

class FormDataSubjectRightState extends Equatable {
  const FormDataSubjectRightState({
    required this.dataSubjectRight,
    required this.currentPage,
    required this.isAcknowledge,
  });

  final DataSubjectRightModel dataSubjectRight;
  final int currentPage;
  final bool isAcknowledge;

  FormDataSubjectRightState copyWith({
    DataSubjectRightModel? dataSubjectRight,
    int? currentPage,
    bool? isAcknowledge,
  }) {
    return FormDataSubjectRightState(
      dataSubjectRight: dataSubjectRight ?? this.dataSubjectRight,
      currentPage: currentPage ?? this.currentPage,
      isAcknowledge: isAcknowledge ?? this.isAcknowledge,
    );
  }

  @override
  List<Object> get props => [
        currentPage,
        dataSubjectRight,
        isAcknowledge,
      ];
}
