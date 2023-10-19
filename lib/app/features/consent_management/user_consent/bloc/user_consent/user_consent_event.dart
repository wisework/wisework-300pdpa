part of 'user_consent_bloc.dart';

abstract class UserConsentEvent extends Equatable {
  const UserConsentEvent();

  @override
  List<Object> get props => [];
}

class GetUserConsentsEvent extends UserConsentEvent {
  const GetUserConsentsEvent({
    required this.companyId,
  });

  final String companyId;

  @override
  List<Object> get props => [companyId];
}

class GetPurposeCategoriesEvent extends UserConsentEvent {
  const GetPurposeCategoriesEvent({
    required this.purposeCategoryId,
    required this.companyId,
  });
  final String companyId;
  final String purposeCategoryId;

  @override
  List<Object> get props => [
        purposeCategoryId,
        companyId,
      ];
}

class UpdateUserConsentEvent extends UserConsentEvent {
  const UpdateUserConsentEvent({
    required this.userConsent,
    required this.updateType,
  });

  final UserConsentModel userConsent;
  final UpdateType updateType;

  @override
  List<Object> get props => [userConsent, updateType];
}
