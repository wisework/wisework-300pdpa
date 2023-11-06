part of 'edit_user_bloc.dart';

abstract class EditUserState extends Equatable {
  const EditUserState();

  @override
  List<Object> get props => [];
}

class EditUserInitial extends EditUserState {
  const EditUserInitial();

  @override
  List<Object> get props => [];
}

class EditUserError extends EditUserState {
  const EditUserError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class EditUserNoAccess extends EditUserState {
  const EditUserNoAccess();

  @override
  List<Object> get props => [];
}

class GettingCurrentUser extends EditUserState {
  const GettingCurrentUser();

  @override
  List<Object> get props => [];
}

class GotCurrentUser extends EditUserState {
  const GotCurrentUser(this.user, this.creator);

  final UserModel user;
  final UserModel creator;

  @override
  List<Object> get props => [user, creator];
}

class CreatingCurrentUser extends EditUserState {
  const CreatingCurrentUser();

  @override
  List<Object> get props => [];
}

class CreatedCurrentUser extends EditUserState {
  const CreatedCurrentUser(this.user);

  final UserModel user;

  @override
  List<Object> get props => [user];
}

class UpdatingCurrentUser extends EditUserState {
  const UpdatingCurrentUser();

  @override
  List<Object> get props => [];
}

class UpdatedCurrentUser extends EditUserState {
  const UpdatedCurrentUser(this.user, this.creator);

  final UserModel user;
  final UserModel creator;

  @override
  List<Object> get props => [user, creator];
}

class DeletingCurrentUser extends EditUserState {
  const DeletingCurrentUser();

  @override
  List<Object> get props => [];
}

class DeletedurrentUser extends EditUserState {
  const DeletedurrentUser(this.userId);

  final String userId;

  @override
  List<Object> get props => [userId];
}
