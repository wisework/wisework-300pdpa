// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/repositories/authentication_repository.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const ResetPasswordInitial()) {
    on<ChangePasswordEvent>(_changePasswordHandler);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _changePasswordHandler(
    ChangePasswordEvent event,
    Emitter<ResetPasswordState> emit,
  ) async {
    if (event.user == UserModel.empty()) {
      emit(const ResetPasswordError('Unauthorized'));
      return;
    }

    emit(const ChangingPassword());

    final result = await _authenticationRepository.updatePassword(
      event.currentPassword,
      event.newPassword,
    );

    await result.fold(
      (failure) {
        emit(ResetPasswordError(failure.errorMessage));
      },
      (_) async {
        final result = await _authenticationRepository.updateCurrentUser(
          event.user,
        );

        await result.fold(
          (failure) {
            emit(ResetPasswordError(failure.errorMessage));
          },
          (user) async {
            final result = await _authenticationRepository.getUserCompanies(
              user.companies,
            );

            result.fold(
              (failure) => emit(ResetPasswordError(failure.errorMessage)),
              (companies) => emit(ChangedPassword(user, companies)),
            );
          },
        );
      },
    );
  }
}
