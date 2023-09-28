part of 'invitation_bloc.dart';

abstract class InvitationState extends Equatable {
  const InvitationState();

  @override
  List<Object> get props => [];
}

class InvitationInitial extends InvitationState {
  const InvitationInitial();

  @override
  List<Object> get props => [];
}

class AcceptedInvitation extends InvitationState {
  const AcceptedInvitation(
    this.user,
    this.companies,
  );

  final UserModel user;
  final List<CompanyModel> companies;

  @override
  List<Object> get props => [user, companies];
}

class InvitationError extends InvitationState {
  const InvitationError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class VerifyingInviteCode extends InvitationState {
  const VerifyingInviteCode();

  @override
  List<Object> get props => [];
}
