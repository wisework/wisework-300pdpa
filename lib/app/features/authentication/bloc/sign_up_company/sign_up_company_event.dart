part of 'sign_up_company_bloc.dart';

abstract class SignUpCompanyEvent extends Equatable {
  const SignUpCompanyEvent();

  @override
  List<Object> get props => [];
}

class SubmitCompanySettingsEvent extends SignUpCompanyEvent {
  const SubmitCompanySettingsEvent({
    required this.user,
    required this.company,
    required this.mandatoryFields,
  });

  final UserModel user;
  final CompanyModel company;
  final List<MandatoryFieldModel> mandatoryFields;

  @override
  List<Object> get props => [user, company, mandatoryFields];
}
