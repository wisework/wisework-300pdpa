// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';

part 'current_consent_form_detail_state.dart';

class CurrentConsentFormDetailCubit
    extends Cubit<CurrentConsentFormDetailState> {
  CurrentConsentFormDetailCubit()
      : super(
          CurrentConsentFormDetailState(
            consentForm: ConsentFormModel.empty(),
            consentTheme: ConsentThemeModel.initial(),
          ),
        );

  void initialSettings(ConsentThemeModel consentTheme) {
    emit(state.copyWith(consentTheme: consentTheme));
  }

  void setConsentForm(ConsentFormModel consentForm) {
    emit(state.copyWith(
      consentForm: consentForm,
    ));
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
