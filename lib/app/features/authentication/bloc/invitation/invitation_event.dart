part of 'invitation_bloc.dart';

abstract class InvitationEvent extends Equatable {
  const InvitationEvent();

  @override
  List<Object> get props => [];
}

class VerifyInviteCodeEvent extends InvitationEvent {
  const VerifyInviteCodeEvent({
    required this.inviteCode,
    required this.user,
    required this.companies,
  });

  final String inviteCode;
  final UserModel user;
  final List<CompanyModel> companies;

  @override
  List<Object> get props => [inviteCode, user, companies];
}
