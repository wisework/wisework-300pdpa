part of 'consent_form_settings_bloc.dart';

abstract class ConsentFormSettingsState extends Equatable {
  const ConsentFormSettingsState();

  @override
  List<Object> get props => [];
}

class ConsentFormSettingsInitial extends ConsentFormSettingsState {
  const ConsentFormSettingsInitial();

  @override
  List<Object> get props => [];
}

class ConsentFormSettingsError extends ConsentFormSettingsState {
  const ConsentFormSettingsError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingConsentFormSettings extends ConsentFormSettingsState {
  const GettingConsentFormSettings();

  @override
  List<Object> get props => [];
}

class GotConsentFormSettings extends ConsentFormSettingsState {
  const GotConsentFormSettings(
    this.consentForm,
    this.customFields,
    this.purposeCategories,
    this.purposes,
    this.consentThemes,
  );

  final ConsentFormModel consentForm;
  final List<CustomFieldModel> customFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<ConsentThemeModel> consentThemes;

  @override
  List<Object> get props => [];
}
