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
    this.mandatoryField,
    this.purposeCategories,
    this.purposes,
  );

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryField;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;

  @override
  List<Object> get props => [
        consentForm,
        mandatoryField,
        purposeCategories,
        purposes,
      ];
}

class CreatingCurrentConsentForm extends EditConsentFormState {
  const CreatingCurrentConsentForm();

  @override
  List<Object> get props => [];
}

class CreatedCurrentConsentForm extends EditConsentFormState {
  const CreatedCurrentConsentForm(this.consentForm);

  final ConsentFormModel consentForm;

  @override
  List<Object> get props => [consentForm];
}

class UpdatingCurrentConsentForm extends EditConsentFormState {
  const UpdatingCurrentConsentForm();

  @override
  List<Object> get props => [];
}

class UpdatedCurrentConsentForm extends EditConsentFormState {
  const UpdatedCurrentConsentForm(
    this.consentForm,
    this.mandatoryFields,
    this.purposeCategories,
    this.purposes,
  );

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;

  @override
  List<Object> get props => [
        consentForm,
        mandatoryFields,
        purposeCategories,
        purposes,
      ];
}
