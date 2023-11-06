part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();

  @override
  List<Object> get props => [];
}

class UserError extends UserState {
  const UserError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class UserNoAccess extends UserState {
  const UserNoAccess();

  @override
  List<Object> get props => [];
}

class GettingUsers extends UserState {
  const GettingUsers();

  @override
  List<Object> get props => [];
}

class GotUsers extends UserState {
  const GotUsers(this.users);

  final List<UserModel> users;

  @override
  List<Object> get props => [users];
}
