part of 'edit_consent_form_bloc.dart';

abstract class EditConsentFormState extends Equatable {
  const EditConsentFormState();

  @override
  List<Object> get props => [];
}

class EditConsentFormInitial extends EditConsentFormState {
  const EditConsentFormInitial();

  @override
  List<Object> get props => [];
}

class EditConsentFormError extends EditConsentFormState {
  const EditConsentFormError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GetingCurrentConsentForm extends EditConsentFormState {
  const GetingCurrentConsentForm();

  @override
  List<Object> get props => [];
}

class GotCurrentConsentForm extends EditConsentFormState {
  const GotCurrentConsentForm(
    this.consentForm,
    this.mandatoryFields,
    this.purposeCategories,
    this.purposes,
    this.customFields,
  );

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<CustomFieldModel> customFields;

  @override
  List<Object> get props => [
        consentForm,
        mandatoryFields,
        purposeCategories,
        purposes,
        customFields,
      ];
}

class CreatingCurrentConsentForm extends EditConsentFormState {
  const CreatingCurrentConsentForm();

  @override
  List<Object> get props => [];
}

class CreatedCurrentConsentForm extends EditConsentFormState {
  const CreatedCurrentConsentForm(
    this.consentForm,
    this.purposeCategories,
  );

  final ConsentFormModel consentForm;
  final List<PurposeCategoryModel> purposeCategories;

  @override
  List<Object> get props => [consentForm, purposeCategories];
}

class UpdatingEditConsentForm extends EditConsentFormState {
  const UpdatingEditConsentForm();

  @override
  List<Object> get props => [];
}

class UpdateEditConsentForm extends EditConsentFormState {
  const UpdateEditConsentForm(
    this.consentForm,
    this.mandatoryFields,
    this.purposeCategories,
    this.purposes,
    this.customFields,
  );

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<CustomFieldModel> customFields;

  @override
  List<Object> get props => [
        consentForm,
        mandatoryFields,
        purposeCategories,
        purposes,
        customFields,
      ];
}
