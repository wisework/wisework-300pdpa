part of 'user_consent_form_bloc.dart';

abstract class UserConsentFormEvent extends Equatable {
  const UserConsentFormEvent();

  @override
  List<Object> get props => [];
}

class GetUserConsentFormEvent extends UserConsentFormEvent {
  const GetUserConsentFormEvent({
    required this.consentFormId,
    required this.companyId,
  });

  final String consentFormId;
  final String companyId;

  @override
  List<Object> get props => [consentFormId, companyId];
}

class SubmitUserConsentFormEvent extends UserConsentFormEvent {
  const SubmitUserConsentFormEvent({
    required this.userConsent,
    required this.consentForm,
    required this.companyId,
  });

  final UserConsentModel userConsent;
  final ConsentFormModel consentForm;
  final String companyId;

  @override
  List<Object> get props => [userConsent, consentForm, companyId];
}
