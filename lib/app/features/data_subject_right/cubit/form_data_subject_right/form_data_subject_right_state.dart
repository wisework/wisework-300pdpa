// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'form_data_subject_right_cubit.dart';

class FormDataSubjectRightState extends Equatable {
  const FormDataSubjectRightState({
    required this.dataSubjectRight,
    required this.currentPage,
    required this.isAcknowledge,
    required this.requestFormState,
  });

  final DataSubjectRightModel dataSubjectRight;
  final int currentPage;
  final bool isAcknowledge;
  final RequestFormState requestFormState;

  FormDataSubjectRightState copyWith({
    DataSubjectRightModel? dataSubjectRight,
    int? currentPage,
    bool? isAcknowledge,
    RequestFormState? requestFormState,
  }) {
    return FormDataSubjectRightState(
      dataSubjectRight: dataSubjectRight ?? this.dataSubjectRight,
      currentPage: currentPage ?? this.currentPage,
      isAcknowledge: isAcknowledge ?? this.isAcknowledge,
      requestFormState: requestFormState ?? this.requestFormState,
    );
  }

  @override
  List<Object> get props => [
        currentPage,
        dataSubjectRight,
        isAcknowledge,
        requestFormState,
      ];
}
