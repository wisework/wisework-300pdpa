part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUsersEvent extends UserEvent {
  const GetUsersEvent();

  @override
  List<Object> get props => [];
}

class UpdateUsersChangedEvent extends UserEvent {
  const UpdateUsersChangedEvent({
    required this.user,
    required this.updateType,
  });

  final UserModel user;
  final UpdateType updateType;

  @override
  List<Object> get props => [user, updateType];
}
