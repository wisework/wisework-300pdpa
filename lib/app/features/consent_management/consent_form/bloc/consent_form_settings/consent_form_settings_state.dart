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
    this.mandatoryFields,
    this.purposeCategories,
    this.purposes,
    this.customFields,
    this.consentThemes,
    this.consentTheme,
  );

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<CustomFieldModel> customFields;
  final List<ConsentThemeModel> consentThemes;
  final ConsentThemeModel consentTheme;

  @override
  List<Object> get props {
    return [
      consentForm,
      mandatoryFields,
      purposeCategories,
      purposes,
      customFields,
      consentThemes,
      consentTheme,
    ];
  }
}

class UpdatingConsentFormSettings extends ConsentFormSettingsState {
  const UpdatingConsentFormSettings();

  @override
  List<Object> get props => [];
}

class UpdatedConsentFormSettings extends ConsentFormSettingsState {
  const UpdatedConsentFormSettings(
    this.consentForm,
    this.mandatoryFields,
    this.purposeCategories,
    this.purposes,
    this.customFields,
    this.consentThemes,
    this.consentTheme,
  );

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<CustomFieldModel> customFields;
  final List<ConsentThemeModel> consentThemes;
  final ConsentThemeModel consentTheme;

  @override
  List<Object> get props {
    return [
      consentForm,
      mandatoryFields,
      purposeCategories,
      purposes,
      customFields,
      consentThemes,
      consentTheme,
    ];
  }
}
