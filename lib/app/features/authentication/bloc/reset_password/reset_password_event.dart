part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordEvent extends ResetPasswordEvent {
  const ChangePasswordEvent({
    required this.user,
    required this.currentPassword,
    required this.newPassword,
  });

  final UserModel user;
  final String currentPassword;
  final String newPassword;

  @override
  List<Object> get props => [user, currentPassword, newPassword];
}
