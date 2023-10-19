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
    this.customFields,
    this.purposeCategories,
    this.purposes,
  );

  final UserConsentModel userConsent;
  final List<CustomFieldModel> customFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;

  @override
  List<Object> get props => [
        userConsent,
        customFields,
        purposeCategories,
        purposes,
      ];
}
