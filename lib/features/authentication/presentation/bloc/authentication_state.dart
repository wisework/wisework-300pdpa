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

class GettingCurrentUser extends AuthenticationState {
  const GettingCurrentUser();

  @override
  List<Object> get props => [];
}

class SigningInWithGoogle extends AuthenticationState {
  const SigningInWithGoogle();

  @override
  List<Object> get props => [];
}

class SignedIn extends AuthenticationState {
  const SignedIn(this.user);

  final UserEntity user;

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

class UpdatingUser extends AuthenticationState {
  const UpdatingUser();

  @override
  List<Object> get props => [];
}

class UpdatedUser extends AuthenticationState {
  const UpdatedUser();

  @override
  List<Object> get props => [];
}

class AuthenticationError extends AuthenticationState {
  const AuthenticationError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
