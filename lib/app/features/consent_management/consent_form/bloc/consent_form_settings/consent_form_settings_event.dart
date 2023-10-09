part of 'consent_form_settings_bloc.dart';

abstract class ConsentFormSettingsEvent extends Equatable {
  const ConsentFormSettingsEvent();

  @override
  List<Object> get props => [];
}

class GetConsentFormSettingsEvent extends ConsentFormSettingsEvent {
  const GetConsentFormSettingsEvent({
    required this.consentId,
    required this.companyId,
  });

  final String consentId;
  final String companyId;

  @override
  List<Object> get props => [consentId, companyId];
}

class UpdateCurrentFormSettingsEvent extends ConsentFormSettingsEvent {
  const UpdateCurrentFormSettingsEvent({
    required this.consentForm,
  });

  final ConsentFormModel consentForm;

  @override
  List<Object> get props => [consentForm];
}

class UpdateCurrentThemeSettingsEvent extends ConsentFormSettingsEvent {
  const UpdateCurrentThemeSettingsEvent({
    required this.consentForm,
    required this.consentTheme,
  });

  final ConsentFormModel consentForm;
  final ConsentThemeModel consentTheme;

  @override
  List<Object> get props => [consentForm, consentTheme];
}

class UpdateConsentFormSettingsEvent extends ConsentFormSettingsEvent {
  const UpdateConsentFormSettingsEvent({
    required this.companyId,
  });

  final String companyId;

  @override
  List<Object> get props => [companyId];
}
