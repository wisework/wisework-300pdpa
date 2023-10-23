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
    this.purposes,
    this.purposeCategories,
    this.customFields,
  );

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeModel> purposes;
  final List<PurposeCategoryModel> purposeCategories;
  final List<CustomFieldModel> customFields;

  @override
  List<Object> get props {
    return [
      consentForm,
      mandatoryFields,
      purposes,
      purposeCategories,
      customFields,
    ];
  }
}

class CreatingCurrentConsentForm extends EditConsentFormState {
  const CreatingCurrentConsentForm();

  @override
  List<Object> get props => [];
}

class CreatedCurrentConsentForm extends EditConsentFormState {
  const CreatedCurrentConsentForm(
    this.consentForm,
    this.mandatoryFields,
    this.purposes,
    this.purposeCategories,
    this.customFields,
  );

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeModel> purposes;
  final List<PurposeCategoryModel> purposeCategories;
  final List<CustomFieldModel> customFields;

  @override
  List<Object> get props {
    return [
      consentForm,
      mandatoryFields,
      purposes,
      purposeCategories,
      customFields,
    ];
  }
}

class UpdatingCurrentConsentForm extends EditConsentFormState {
  const UpdatingCurrentConsentForm();

  @override
  List<Object> get props => [];
}

class UpdateCurrentConsentForm extends EditConsentFormState {
  const UpdateCurrentConsentForm(
    this.consentForm,
    this.mandatoryFields,
    this.purposes,
    this.purposeCategories,
    this.customFields,
  );

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeModel> purposes;
  final List<PurposeCategoryModel> purposeCategories;
  final List<CustomFieldModel> customFields;

  @override
  List<Object> get props {
    return [
      consentForm,
      mandatoryFields,
      purposes,
      purposeCategories,
      customFields,
    ];
  }
}
