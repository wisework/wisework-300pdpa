part of 'reset_password_bloc.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial();

  @override
  List<Object> get props => [];
}

class ResetPasswordError extends ResetPasswordState {
  const ResetPasswordError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class ChangingPassword extends ResetPasswordState {
  const ChangingPassword();

  @override
  List<Object> get props => [];
}

class ChangedPassword extends ResetPasswordState {
  const ChangedPassword(this.user, this.companies);

  final UserModel user;
  final List<CompanyModel> companies;

  @override
  List<Object> get props => [user, companies];
}
