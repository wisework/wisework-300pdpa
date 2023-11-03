// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'current_consent_form_detail_cubit.dart';

class CurrentConsentFormDetailState extends Equatable {
  const CurrentConsentFormDetailState({
    required this.consentForm,
    required this.consentTheme,
  });

  final ConsentFormModel consentForm;
  final ConsentThemeModel consentTheme;

  CurrentConsentFormDetailState copyWith({
    ConsentFormModel? consentForm,
    ConsentThemeModel? consentTheme,
  }) {
    return CurrentConsentFormDetailState(
      consentForm: consentForm ?? this.consentForm,
      consentTheme: consentTheme ?? this.consentTheme,
    );
  }

  @override
  List<Object> get props => [
        consentForm,
        consentTheme,
      ];
}
