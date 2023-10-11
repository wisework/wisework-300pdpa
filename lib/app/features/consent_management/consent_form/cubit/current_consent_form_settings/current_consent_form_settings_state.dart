part of 'current_consent_form_settings_cubit.dart';

class CurrentConsentFormSettingsState extends Equatable {
  const CurrentConsentFormSettingsState({
    required this.settingTabs,
    required this.consentForm,
    required this.consentTheme,
  });

  final int settingTabs;
  final ConsentFormModel consentForm;
  final ConsentThemeModel consentTheme;

  CurrentConsentFormSettingsState copyWith({
    int? settingTabs,
    ConsentFormModel? consentForm,
    ConsentThemeModel? consentTheme,
  }) {
    return CurrentConsentFormSettingsState(
      settingTabs: settingTabs ?? this.settingTabs,
      consentForm: consentForm ?? this.consentForm,
      consentTheme: consentTheme ?? this.consentTheme,
    );
  }

  @override
  List<Object> get props => [settingTabs, consentForm, consentTheme];
}
