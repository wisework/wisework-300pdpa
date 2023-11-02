part of 'consent_form_settings_bloc.dart';

abstract class ConsentFormSettingsEvent extends Equatable {
  const ConsentFormSettingsEvent();

  @override
  List<Object> get props => [];
}

class GetConsentFormSettingsEvent extends ConsentFormSettingsEvent {
  const GetConsentFormSettingsEvent({
    required this.consentFormId,
    required this.companyId,
  });

  final String consentFormId;
  final String companyId;

  @override
  List<Object> get props => [consentFormId, companyId];
}

class UpdateConsentFormSettingsEvent extends ConsentFormSettingsEvent {
  const UpdateConsentFormSettingsEvent({
    required this.consentForm,
    required this.companyId,
  });

  final ConsentFormModel consentForm;
  final String companyId;

  @override
  List<Object> get props => [consentForm, companyId];
}

class UpdateConsentThemesEvent extends ConsentFormSettingsEvent {
  const UpdateConsentThemesEvent({
    required this.consentTheme,
    required this.updateType,
  });

  final ConsentThemeModel consentTheme;
  final UpdateType updateType;

  @override
  List<Object> get props => [consentTheme, updateType];
}

class UpdateConsentFormEvent extends ConsentFormSettingsEvent {
  const UpdateConsentFormEvent({
    required this.consentForm,
    required this.consentTheme,
    required this.updateType,
  });

  final ConsentFormModel consentForm;
  final ConsentThemeModel consentTheme;
  final UpdateType updateType;

  @override
  List<Object> get props => [consentForm, consentTheme, updateType];
}
