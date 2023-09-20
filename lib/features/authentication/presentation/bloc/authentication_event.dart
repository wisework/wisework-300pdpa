part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentUserEvent extends AuthenticationEvent {
  const GetCurrentUserEvent();

  @override
  List<Object> get props => [];
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

class UpdateUserEvent extends AuthenticationEvent {
  const UpdateUserEvent({
    required this.user,
  });

  final UserEntity user;

  @override
  List<Object> get props => [user];
}
