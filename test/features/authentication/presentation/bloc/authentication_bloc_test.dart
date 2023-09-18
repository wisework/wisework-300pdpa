import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdpa/core/errors/failure.dart';
import 'package:pdpa/features/authentication/domain/entities/user.dart';
import 'package:pdpa/features/authentication/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:pdpa/features/authentication/domain/usecases/sign_in_with_google.dart';
import 'package:pdpa/features/authentication/domain/usecases/sign_out.dart';
import 'package:pdpa/features/authentication/presentation/bloc/authentication_bloc.dart';

class MockSignInWithEmailAndPassword extends Mock
    implements SignInWithEmailAndPassword {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockSignOut extends Mock implements SignOut {}

class MockUser extends Mock implements User {}

void main() {
  late SignInWithEmailAndPassword signInWithEmailAndPassword;
  late SignInWithGoogle signInWithGoogle;
  late SignOut signOut;
  late User user;
  late AuthenticationBloc bloc;

  const signInWithEmailAndPasswordParams =
      SignInWithEmailAndPasswordParams.empty();
  const apiFailure = ApiFailure(message: 'User not found', statusCode: 404);

  setUp(() {
    signInWithEmailAndPassword = MockSignInWithEmailAndPassword();
    signInWithGoogle = MockSignInWithGoogle();
    signOut = MockSignOut();
    user = MockUser();
    bloc = AuthenticationBloc(
      signInWithEmailAndPassword: signInWithEmailAndPassword,
      signInWithGoogle: signInWithGoogle,
      signOut: signOut,
    );
  });

  setUpAll(() {
    registerFallbackValue(signInWithEmailAndPasswordParams);
  });

  tearDown(() => bloc.close());

  test('Initial state should be [AuthenticationInitial]', () {
    expect(bloc.state, const AuthenticationInitial());
  });

  group('SignInWithEmailAndPassword:', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'Should emit [SigningInWithEmailAndPassword, SignedInWithEmailAndPassword] when successful',
      build: () {
        when(() => signInWithEmailAndPassword(any())).thenAnswer(
          (_) async => Right(user),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        SignInWithEmailAndPasswordEvent(
          email: signInWithEmailAndPasswordParams.email,
          password: signInWithEmailAndPasswordParams.password,
        ),
      ),
      expect: () => [
        const SigningInWithEmailAndPassword(),
        SignedInWithEmailAndPassword(user),
      ],
      verify: (_) {
        verify(
          () => signInWithEmailAndPassword(signInWithEmailAndPasswordParams),
        ).called(1);
        verifyNoMoreInteractions(signInWithEmailAndPassword);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'Should emit [SigningInWithEmailAndPassword, AuthenticationError] when unsuccessful',
      build: () {
        when(() => signInWithEmailAndPassword(any())).thenAnswer(
          (_) async => const Left(apiFailure),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        SignInWithEmailAndPasswordEvent(
          email: signInWithEmailAndPasswordParams.email,
          password: signInWithEmailAndPasswordParams.password,
        ),
      ),
      expect: () => [
        const SigningInWithEmailAndPassword(),
        AuthenticationError(apiFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => signInWithEmailAndPassword(signInWithEmailAndPasswordParams),
        ).called(1);
        verifyNoMoreInteractions(signInWithEmailAndPassword);
      },
    );
  });

  group('SignInWithGoogle:', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'Should emit [SigningInWithGoogle, SignedInWithGoogle] when successful',
      build: () {
        when(() => signInWithGoogle()).thenAnswer(
          (_) async => Right(user),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const SignInWithGoogleEvent(),
      ),
      expect: () => [
        const SigningInWithGoogle(),
        SignedInWithGoogle(user),
      ],
      verify: (_) {
        verify(
          () => signInWithGoogle(),
        ).called(1);
        verifyNoMoreInteractions(signInWithGoogle);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'Should emit [SigningInWithGoogle, AuthenticationError] when unsuccessful',
      build: () {
        when(() => signInWithGoogle()).thenAnswer(
          (_) async => const Left(apiFailure),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const SignInWithGoogleEvent(),
      ),
      expect: () => [
        const SigningInWithGoogle(),
        AuthenticationError(apiFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => signInWithGoogle(),
        ).called(1);
        verifyNoMoreInteractions(signInWithGoogle);
      },
    );
  });

  group('SignOut:', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'Should emit [SigningOut, SignedOut] when successful',
      build: () {
        when(() => signOut()).thenAnswer(
          (_) async => const Right(null),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const SignOutEvent(),
      ),
      expect: () => const [
        SigningOut(),
        SignedOut(),
      ],
      verify: (_) {
        verify(
          () => signOut(),
        ).called(1);
        verifyNoMoreInteractions(signOut);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'Should emit [SigningOut, AuthenticationError] when unsuccessful',
      build: () {
        when(() => signOut()).thenAnswer(
          (_) async => const Left(apiFailure),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const SignOutEvent(),
      ),
      expect: () => [
        const SigningOut(),
        AuthenticationError(apiFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => signOut(),
        ).called(1);
        verifyNoMoreInteractions(signOut);
      },
    );
  });
}
