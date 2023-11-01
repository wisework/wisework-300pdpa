part of 'edit_user_bloc.dart';

abstract class EditUserEvent extends Equatable {
  const EditUserEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentUserEvent extends EditUserEvent {
  const GetCurrentUserEvent({required this.userId});

  final String userId;

  @override
  List<Object> get props => [userId];
}

class CreateCurrentUserEvent extends EditUserEvent {
  const CreateCurrentUserEvent({required this.user});

  final UserModel user;

  @override
  List<Object> get props => [user];
}

class UpdateCurrentUserEvent extends EditUserEvent {
  const UpdateCurrentUserEvent({required this.user});

  final UserModel user;

  @override
  List<Object> get props => [user];
}

class DeleteCurrentUserEvent extends EditUserEvent {
  const DeleteCurrentUserEvent({required this.userId});

  final String userId;

  @override
  List<Object> get props => [userId];
}
