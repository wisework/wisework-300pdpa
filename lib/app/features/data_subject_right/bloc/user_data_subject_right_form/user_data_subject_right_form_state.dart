part of 'user_data_subject_right_form_bloc.dart';

abstract class UserDataSubjectRightFormState extends Equatable {
  const UserDataSubjectRightFormState();

  @override
  List<Object> get props => [];
}

class UserDataSubjectRightFormInitial extends UserDataSubjectRightFormState {
  const UserDataSubjectRightFormInitial();

  @override
  List<Object> get props => [];
}

class UserDataSubjectRightFormError extends UserDataSubjectRightFormState {
  const UserDataSubjectRightFormError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingUserDataSubjectRightForm extends UserDataSubjectRightFormState {
  const GettingUserDataSubjectRightForm();

  @override
  List<Object> get props => [];
}

class GotUserDataSubjectRightForm extends UserDataSubjectRightFormState {
  const GotUserDataSubjectRightForm(this.mandatoryFields);

  final List<MandatoryFieldModel> mandatoryFields;

  @override
  List<Object> get props => [mandatoryFields];
}

class SubmittingUserDataSubjectRightForm extends UserDataSubjectRightFormState {
  const SubmittingUserDataSubjectRightForm();

  @override
  List<Object> get props => [];
}

class SubmittedUserDataSubjectRightForm extends UserDataSubjectRightFormState {
  const SubmittedUserDataSubjectRightForm(
    this.dataSubjectRight,
  );

  final DataSubjectRightModel dataSubjectRight;

  @override
  List<Object> get props => [dataSubjectRight];
}
