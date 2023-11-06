// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/repositories/authentication_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const SignInInitial()) {
    on<SignInWithEmailAndPasswordEvent>(_signInWithEmailAndPasswordHandler);
    on<SignInWithGoogleEvent>(_signInWithGoogleHandler);
    on<SignOutEvent>(_signOutEventHandler);
    on<SendPasswordResetEvent>(_sendPasswordResetHandler);
    on<GetSignedUserEvent>(_getSignedUserHandler);
    on<UpdateSignedUserEvent>(_updateSignedUserHandler);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _signInWithEmailAndPasswordHandler(
    SignInWithEmailAndPasswordEvent event,
    Emitter<SignInState> emit,
  ) async {
    if (event.email.isEmpty) {
      emit(const SignInError('Required email'));
      return;
    }
    if (event.password.isEmpty) {
      emit(const SignInError('Required password'));
      return;
    }

    emit(const SigningInWithEmailAndPassword());

    final result = await _authenticationRepository.signInWithEmailAndPassword(
      event.email,
      event.password,
    );

    await result.fold(
      (failure) {
        emit(SignInError(failure.errorMessage));
        return;
      },
      (user) async {
        if (user == UserModel.empty()) {
          emit(const SignInInitial());
          return;
        }

        final result = await _authenticationRepository.getUserCompanies(
          user.companies,
        );

        result.fold(
          (failure) => emit(SignInError(failure.errorMessage)),
          (companies) => emit(SignedInUser(user, companies)),
        );
      },
    );
  }

  Future<void> _signInWithGoogleHandler(
    SignInWithGoogleEvent event,
    Emitter<SignInState> emit,
  ) async {
    emit(const SigningInWithGoogle());

    final result = await _authenticationRepository.signInWithGoogle();

    await result.fold(
      (failure) {
        emit(SignInError(failure.errorMessage));
        return;
      },
      (user) async {
        if (user == UserModel.empty()) {
          emit(const SignInInitial());
          return;
        }

        final result = await _authenticationRepository.getUserCompanies(
          user.companies,
        );

        result.fold(
          (failure) => emit(SignInError(failure.errorMessage)),
          (companies) => emit(SignedInUser(user, companies)),
        );
      },
    );
  }

  Future<void> _signOutEventHandler(
    SignOutEvent event,
    Emitter<SignInState> emit,
  ) async {
    emit(const SigningOut());

    final result = await _authenticationRepository.signOut();

    result.fold(
      (failure) => emit(SignInError(failure.errorMessage)),
      (_) => emit(const SignInInitial()),
    );
  }

  Future<void> _sendPasswordResetHandler(
    SendPasswordResetEvent event,
    Emitter<SignInState> emit,
  ) async {
    if (event.email.isEmpty) {
      emit(const SignInError('Required email'));
      return;
    }

    emit(const SendingPasswordReset());

    final result = await _authenticationRepository.sendPasswordResetEmail(
      event.email,
    );

    await result.fold(
      (failure) {
        emit(SignInError(failure.errorMessage));
      },
      (_) async {
        emit(const SentPasswordReset());

        await Future.delayed(const Duration(milliseconds: 400));

        emit(const SignInInitial());
      },
    );
  }

  Future<void> _getSignedUserHandler(
    GetSignedUserEvent event,
    Emitter<SignInState> emit,
  ) async {
    emit(const GettingCurrentUser());

    final result = await _authenticationRepository.getCurrentUser();

    await result.fold(
      (failure) {
        emit(SignInError(failure.errorMessage));
        return;
      },
      (user) async {
        if (user == UserModel.empty()) {
          emit(const SignInInitial());
          return;
        }

        final result = await _authenticationRepository.getUserCompanies(
          user.companies,
        );

        result.fold(
          (failure) => emit(SignInError(failure.errorMessage)),
          (companies) => emit(SignedInUser(user, companies)),
        );
      },
    );
  }

  void _updateSignedUserHandler(
    UpdateSignedUserEvent event,
    Emitter<SignInState> emit,
  ) {
    emit(SignedInUser(event.user, event.companies));
  }
}
