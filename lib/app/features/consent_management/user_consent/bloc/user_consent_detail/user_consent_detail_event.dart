part of 'user_consent_detail_bloc.dart';

abstract class UserConsentDetailEvent extends Equatable {
  const UserConsentDetailEvent();

  @override
  List<Object> get props => [];
}

class GetUserConsentFormDetailEvent extends UserConsentDetailEvent {
  const GetUserConsentFormDetailEvent({
    required this.userConsentId,
    required this.companyId,
  });

  final String userConsentId;
  final String companyId;

  @override
  List<Object> get props => [userConsentId, companyId];
}
