part of 'user_data_subject_right_form_bloc.dart';

abstract class UserDataSubjectRightFormEvent extends Equatable {
  const UserDataSubjectRightFormEvent();

  @override
  List<Object> get props => [];
}

class GetUserDataSubjectRightFormEvent extends UserDataSubjectRightFormEvent {
  const GetUserDataSubjectRightFormEvent({
    required this.companyId,
  });

  final String companyId;

  @override
  List<Object> get props => [companyId];
}

class SubmitUserDataSubjectRightFormEvent
    extends UserDataSubjectRightFormEvent {
  const SubmitUserDataSubjectRightFormEvent({
    required this.dataSubjectRight,
    required this.companyId,
  });

  final DataSubjectRightModel dataSubjectRight;
  final String companyId;

  @override
  List<Object> get props => [dataSubjectRight, companyId];
}
