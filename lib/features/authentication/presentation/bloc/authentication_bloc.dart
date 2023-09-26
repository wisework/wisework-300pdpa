// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/features/authentication/data/models/user_model.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';
import 'package:pdpa/features/authentication/domain/usecases/get_current_user.dart';
import 'package:pdpa/features/authentication/domain/usecases/sign_in_with_google.dart';
import 'package:pdpa/features/authentication/domain/usecases/sign_out.dart';
import 'package:pdpa/features/authentication/domain/usecases/update_user.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required GetCurrentUser getCurrentUser,
    required SignInWithGoogle signInWithGoogle,
    required SignOut signOut,
    required UpdateUser updateUser,
  })  : _getCurrentUser = getCurrentUser,
        _signInWithGoogle = signInWithGoogle,
        _signOut = signOut,
        _updateUser = updateUser,
        super(const AuthenticationInitial()) {
    on<GetCurrentUserEvent>(_getCurrentUserHandler);
    on<SignInWithGoogleEvent>(_signInWithGoogleHandler);
    on<SignOutEvent>(_signOutEventHandler);
    on<UpdateUserEvent>(_updateUserHandler);
  }

  final GetCurrentUser _getCurrentUser;
  final SignInWithGoogle _signInWithGoogle;
  final SignOut _signOut;
  final UpdateUser _updateUser;

  Future<void> _getCurrentUserHandler(
    GetCurrentUserEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const GettingCurrentUser());

    final result = await _getCurrentUser();

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (user) => emit(
        user == UserEntity.empty()
            ? const AuthenticationInitial()
            : SignedIn(user as UserModel),
      ),
    );
  }

  Future<void> _signInWithGoogleHandler(
    SignInWithGoogleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const SigningInWithGoogle());

    final result = await _signInWithGoogle();

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (user) => emit(SignedIn(user as UserModel)),
    );
  }

  Future<void> _signOutEventHandler(
    SignOutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const SigningOut());

    final result = await _signOut();

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (_) => emit(const SignedOut()),
    );
  }

  Future<void> _updateUserHandler(
    UpdateUserEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const UpdatingUser());

    final result = await _updateUser(UpdateUserParams(user: event.user));

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (_) => emit(const UpdatedUser()),
    );
  }
}
