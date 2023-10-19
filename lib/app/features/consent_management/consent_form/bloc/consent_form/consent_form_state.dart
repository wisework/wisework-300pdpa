part of 'consent_form_bloc.dart';

abstract class ConsentFormState extends Equatable {
  const ConsentFormState();

  @override
  List<Object> get props => [];
}

class ConsentFormInitial extends ConsentFormState {
  const ConsentFormInitial();

  @override
  List<Object> get props => [];
}

class ConsentFormError extends ConsentFormState {
  const ConsentFormError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingConsentForms extends ConsentFormState {
  const GettingConsentForms();

  @override
  List<Object> get props => [];
}

class GotConsentForms extends ConsentFormState {
  const GotConsentForms(
    this.consentForms,
    this.purposeCategories,
  );

  final List<ConsentFormModel> consentForms;
  final List<PurposeCategoryModel> purposeCategories;

  @override
  List<Object> get props => [
        consentForms,
        purposeCategories,
      ];
}
