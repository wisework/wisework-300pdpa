part of 'sign_up_company_bloc.dart';

sealed class SignUpCompanyState extends Equatable {
  const SignUpCompanyState();

  @override
  List<Object> get props => [];
}

final class SignUpCompanyInitial extends SignUpCompanyState {
  const SignUpCompanyInitial();

  @override
  List<Object> get props => [];
}

class SignUpCompanyError extends SignUpCompanyState {
  const SignUpCompanyError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class SigningUpCompany extends SignUpCompanyState {
  const SigningUpCompany();

  @override
  List<Object> get props => [];
}

class SignedUpCompany extends SignUpCompanyState {
  const SignedUpCompany(this.user, this.companies);

  final UserModel user;
  final List<CompanyModel> companies;

  @override
  List<Object> get props => [user, companies];
}
