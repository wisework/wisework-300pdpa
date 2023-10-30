part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInWithEmailAndPasswordEvent extends SignInEvent {
  const SignInWithEmailAndPasswordEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class SignInWithGoogleEvent extends SignInEvent {
  const SignInWithGoogleEvent();

  @override
  List<Object> get props => [];
}

class SignOutEvent extends SignInEvent {
  const SignOutEvent();

  @override
  List<Object> get props => [];
}

class SendPasswordResetEvent extends SignInEvent {
  const SendPasswordResetEvent({
    required this.email,
  });

  final String email;

  @override
  List<Object> get props => [email];
}

class GetCurrentUserEvent extends SignInEvent {
  const GetCurrentUserEvent();

  @override
  List<Object> get props => [];
}

class UpdateCurrentUserEvent extends SignInEvent {
  const UpdateCurrentUserEvent({
    required this.user,
    required this.companies,
  });

  final UserModel user;
  final List<CompanyModel> companies;

  @override
  List<Object> get props => [user, companies];
}
