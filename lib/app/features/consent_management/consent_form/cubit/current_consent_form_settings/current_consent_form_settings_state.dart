part of 'current_consent_form_settings_cubit.dart';

class CurrentConsentFormSettingsState extends Equatable {
  const CurrentConsentFormSettingsState({
    required this.settingTabs,
    required this.consentForm,
    required this.consentTheme,
    required this.logoImages,
    required this.headerImages,
    required this.bodyImages,
  });

  final int settingTabs;
  final ConsentFormModel consentForm;
  final ConsentThemeModel consentTheme;
  final List<String> logoImages;
  final List<String> headerImages;
  final List<String> bodyImages;

  CurrentConsentFormSettingsState copyWith({
    int? settingTabs,
    ConsentFormModel? consentForm,
    ConsentThemeModel? consentTheme,
    List<String>? logoImages,
    List<String>? headerImages,
    List<String>? bodyImages,
  }) {
    return CurrentConsentFormSettingsState(
      settingTabs: settingTabs ?? this.settingTabs,
      consentForm: consentForm ?? this.consentForm,
      consentTheme: consentTheme ?? this.consentTheme,
      logoImages: logoImages ?? this.logoImages,
      headerImages: headerImages ?? this.headerImages,
      bodyImages: bodyImages ?? this.bodyImages,
    );
  }

  @override
  List<Object> get props {
    return [
      settingTabs,
      consentForm,
      consentTheme,
      logoImages,
      headerImages,
      bodyImages,
    ];
  }
}
