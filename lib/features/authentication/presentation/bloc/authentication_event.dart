part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class SignInWithEmailAndPasswordEvent extends AuthenticationEvent {
  const SignInWithEmailAndPasswordEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class SignInWithGoogleEvent extends AuthenticationEvent {
  const SignInWithGoogleEvent();

  @override
  List<Object> get props => [];
}

class SignOutEvent extends AuthenticationEvent {
  const SignOutEvent();

  @override
  List<Object> get props => [];
}
