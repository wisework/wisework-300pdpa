part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {
  const SignInInitial();

  @override
  List<Object> get props => [];
}

class SignInError extends SignInState {
  const SignInError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class SignedInUser extends SignInState {
  const SignedInUser(
    this.user,
    this.companies,
  );

  final UserModel user;
  final List<CompanyModel> companies;

  @override
  List<Object> get props => [user, companies];
}

class SigningInWithEmailAndPassword extends SignInState {
  const SigningInWithEmailAndPassword();

  @override
  List<Object> get props => [];
}

class SigningInWithGoogle extends SignInState {
  const SigningInWithGoogle();

  @override
  List<Object> get props => [];
}

class SigningOut extends SignInState {
  const SigningOut();

  @override
  List<Object> get props => [];
}

class SendingPasswordReset extends SignInState {
  const SendingPasswordReset();

  @override
  List<Object> get props => [];
}

class SentPasswordReset extends SignInState {
  const SentPasswordReset();

  @override
  List<Object> get props => [];
}

class GettingCurrentUser extends SignInState {
  const GettingCurrentUser();

  @override
  List<Object> get props => [];
}
