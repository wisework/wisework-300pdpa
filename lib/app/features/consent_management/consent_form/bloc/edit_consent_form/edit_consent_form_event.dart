part of 'edit_consent_form_bloc.dart';

abstract class EditConsentFormEvent extends Equatable {
  const EditConsentFormEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentConsentFormEvent extends EditConsentFormEvent {
  const GetCurrentConsentFormEvent({
    required this.consentFormId,
    required this.companyId,
  });

  final String consentFormId;
  final String companyId;

  @override
  List<Object> get props => [consentFormId, companyId];
}

class CreateCurrentConsentFormEvent extends EditConsentFormEvent {
  const CreateCurrentConsentFormEvent({
    required this.consentForm,
    required this.companyId,
  });

  final ConsentFormModel consentForm;
  final String companyId;

  @override
  List<Object> get props => [consentForm, companyId];
}

class UpdateCurrentConsentFormEvent extends EditConsentFormEvent {
  const UpdateCurrentConsentFormEvent({
    required this.consentForm,
    required this.companyId,
  });

  final ConsentFormModel consentForm;
  final String companyId;

  @override
  List<Object> get props => [consentForm, companyId];
}

class UpdateEditConsentFormStateEvent extends EditConsentFormEvent {
  const UpdateEditConsentFormStateEvent({
    required this.purposeCategory,
  });

  final PurposeCategoryModel purposeCategory;

  @override
  List<Object> get props => [purposeCategory];
}
