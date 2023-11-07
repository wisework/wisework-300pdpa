part of 'consent_form_detail_bloc.dart';

abstract class ConsentFormDetailEvent extends Equatable {
  const ConsentFormDetailEvent();

  @override
  List<Object?> get props => [];
}

class GetConsentFormDetailEvent extends ConsentFormDetailEvent {
  const GetConsentFormDetailEvent({
    required this.consentFormId,
    required this.companyId,
  });

  final String consentFormId;
  final String companyId;

  @override
  List<Object> get props => [consentFormId, companyId];
}

class UpdateConsentFormDetailEvent extends ConsentFormDetailEvent {
  const UpdateConsentFormDetailEvent({
    required this.consentForm,
    this.consentTheme,
  });

  final ConsentFormModel consentForm;
  final ConsentThemeModel? consentTheme;

  @override
  List<Object?> get props => [consentForm, consentTheme];
}
