part of 'consent_form_detail_bloc.dart';

abstract class ConsentFormDetailEvent extends Equatable {
  const ConsentFormDetailEvent();

  @override
  List<Object> get props => [];
}

class GetConsentFormEvent extends ConsentFormDetailEvent {
  const GetConsentFormEvent({
    required this.consentFormId,
    required this.companyId,
  });

  final String consentFormId;
  final String companyId;

  @override
  List<Object> get props => [consentFormId, companyId];
}

class UpdateConsentFormEvent extends ConsentFormDetailEvent {
  const UpdateConsentFormEvent({
    required this.consentForm,
    required this.updateType,
  });

  final ConsentFormModel consentForm;
  final UpdateType updateType;

  @override
  List<Object> get props => [
        consentForm,
        updateType,
      ];
}
