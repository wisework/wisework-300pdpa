part of 'user_consent_detail_bloc.dart';

abstract class UserConsentDetailState extends Equatable {
  const UserConsentDetailState();

  @override
  List<Object> get props => [];
}

class UserConsentDetailInitial extends UserConsentDetailState {
  const UserConsentDetailInitial();

  @override
  List<Object> get props => [];
}

class UserConsentDetailError extends UserConsentDetailState {
  const UserConsentDetailError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingUserConsentDetail extends UserConsentDetailState {
  const GettingUserConsentDetail();

  @override
  List<Object> get props => [];
}

class GotUserConsentDetail extends UserConsentDetailState {
  const GotUserConsentDetail(
    this.userConsent,
    this.consentForm,
    this.mandatoryFields,
    this.purposes,
    this.purposeCategories,
    this.customFields,
    this.consentTheme,
  );

  final UserConsentModel userConsent;
  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeModel> purposes;
  final List<PurposeCategoryModel> purposeCategories;
  final List<CustomFieldModel> customFields;
  final ConsentThemeModel consentTheme;

  @override
  List<Object> get props => [
        userConsent,
        consentForm,
        mandatoryFields,
        purposes,
        purposeCategories,
        customFields,
        consentTheme,
      ];
}
