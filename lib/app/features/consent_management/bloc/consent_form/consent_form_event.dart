part of 'consent_form_bloc.dart';

abstract class ConsentFormEvent extends Equatable {
  const ConsentFormEvent();

  @override
  List<Object> get props => [];
}

class GetConsentFormsEvent extends ConsentFormEvent {
  const GetConsentFormsEvent({
    required this.companyId,
  });

  final String companyId;

  @override
  List<Object> get props => [companyId];
}

class UpdateConsentFormEvent extends ConsentFormEvent {
  const UpdateConsentFormEvent({
    required this.consentForm,
    required this.updateType,
  });

  final ConsentFormModel consentForm;
  final UpdateType updateType;

  @override
  List<Object> get props => [consentForm, updateType];
}
