part of 'user_consent_detail_bloc.dart';

abstract class UserConsentDetailEvent extends Equatable {
  const UserConsentDetailEvent();

  @override
  List<Object> get props => [];
}

class GetUserConsentFormEvent extends UserConsentDetailEvent {
  const GetUserConsentFormEvent({
    required this.consentFormId,
    required this.companyId,
  });

  final String consentFormId;
  final String companyId;

  @override
  List<Object> get props => [consentFormId, companyId];
}
