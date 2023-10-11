// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';

part 'current_consent_form_settings_state.dart';

class CurrentConsentFormSettingsCubit
    extends Cubit<CurrentConsentFormSettingsState> {
  CurrentConsentFormSettingsCubit()
      : super(CurrentConsentFormSettingsState(
          settingTabs: 0,
          consentForm: ConsentFormModel.empty(),
          consentTheme: ConsentThemeModel.initial(),
        ));

  void initialSettings(
    ConsentFormModel consentForm,
    ConsentThemeModel consentTheme,
  ) {
    emit(state.copyWith(
      consentForm: consentForm,
      consentTheme: consentTheme,
    ));
  }

  void setSettingTab(int tabIndex) {
    emit(state.copyWith(settingTabs: tabIndex));
  }

  void setConsentForm(ConsentFormModel consentForm) {
    emit(state.copyWith(consentForm: consentForm));
  }

  void setConsentTheme(ConsentThemeModel consentTheme) {
    emit(state.copyWith(
      consentForm: state.consentForm.copyWith(
        consentThemeId: consentTheme.id,
      ),
      consentTheme: consentTheme,
    ));
  }
}
