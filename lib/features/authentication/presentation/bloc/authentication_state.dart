part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();

  @override
  List<Object> get props => [];
}

class SigningInWithEmailAndPassword extends AuthenticationState {
  const SigningInWithEmailAndPassword();

  @override
  List<Object> get props => [];
}

class SignedInWithEmailAndPassword extends AuthenticationState {
  const SignedInWithEmailAndPassword(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class SigningInWithGoogle extends AuthenticationState {
  const SigningInWithGoogle();

  @override
  List<Object> get props => [];
}

class SignedInWithGoogle extends AuthenticationState {
  const SignedInWithGoogle(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class SigningOut extends AuthenticationState {
  const SigningOut();

  @override
  List<Object> get props => [];
}

class SignedOut extends AuthenticationState {
  const SignedOut();

  @override
  List<Object> get props => [];
}

class AuthenticationError extends AuthenticationState {
  const AuthenticationError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
