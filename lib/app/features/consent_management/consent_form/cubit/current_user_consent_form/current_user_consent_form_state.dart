part of 'current_user_consent_form_cubit.dart';

class CurrentUserConsentFormState extends Equatable {
  const CurrentUserConsentFormState({
    required this.userConsent,
  });

  final UserConsentModel userConsent;

  CurrentUserConsentFormState copyWith({
    UserConsentModel? userConsent,
  }) {
    return CurrentUserConsentFormState(
      userConsent: userConsent ?? this.userConsent,
    );
  }

  @override
  List<Object> get props => [userConsent];
}
