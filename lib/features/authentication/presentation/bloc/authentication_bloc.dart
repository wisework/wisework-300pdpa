// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/features/authentication/domain/entities/user.dart';
import 'package:pdpa/features/authentication/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:pdpa/features/authentication/domain/usecases/sign_in_with_google.dart';
import 'package:pdpa/features/authentication/domain/usecases/sign_out.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required SignInWithEmailAndPassword signInWithEmailAndPassword,
    required SignInWithGoogle signInWithGoogle,
    required SignOut signOut,
  })  : _signInWithEmailAndPassword = signInWithEmailAndPassword,
        _signInWithGoogle = signInWithGoogle,
        _signOut = signOut,
        super(const AuthenticationInitial()) {
    on<SignInWithEmailAndPasswordEvent>(_signInWithEmailAndPasswordHandler);
    on<SignInWithGoogleEvent>(_signInWithGoogleHandler);
    on<SignOutEvent>(_signOutEventHandler);
  }

  final SignInWithEmailAndPassword _signInWithEmailAndPassword;
  final SignInWithGoogle _signInWithGoogle;
  final SignOut _signOut;

  Future<void> _signInWithEmailAndPasswordHandler(
    SignInWithEmailAndPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const SigningInWithEmailAndPassword());

    final result = await _signInWithEmailAndPassword(
      SignInWithEmailAndPasswordParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (user) => emit(SignedInWithEmailAndPassword(user)),
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
      (user) => emit(SignedInWithGoogle(user)),
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
}
