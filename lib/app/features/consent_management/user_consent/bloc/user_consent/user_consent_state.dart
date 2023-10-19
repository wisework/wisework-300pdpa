part of 'user_consent_bloc.dart';

abstract class UserConsentState extends Equatable {
  const UserConsentState();

  @override
  List<Object> get props => [];
}

class UserConsentInitial extends UserConsentState {
  const UserConsentInitial();

  @override
  List<Object> get props => [];
}

class UserConsentError extends UserConsentState {
  const UserConsentError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingUserConsents extends UserConsentState {
  const GettingUserConsents();

  @override
  List<Object> get props => [];
}

class GotUserConsents extends UserConsentState {
  const GotUserConsents(
    this.userConsents,
  );

  final List<UserConsentModel> userConsents;

  @override
  List<Object> get props => [
        userConsents,
      ];
}
