import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdpa/core/errors/failure.dart';
import 'package:pdpa/features/authentication/data/models/user_model.dart';
import 'package:pdpa/features/authentication/domain/usecases/authentication/get_current_user.dart';
import 'package:pdpa/features/authentication/domain/usecases/authentication/sign_in_with_google.dart';
import 'package:pdpa/features/authentication/domain/usecases/authentication/sign_out.dart';
import 'package:pdpa/features/authentication/domain/usecases/authentication/update_user.dart';
import 'package:pdpa/features/authentication/presentation/bloc/authentication_bloc.dart';

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockSignOut extends Mock implements SignOut {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late GetCurrentUser getCurrentUser;
  late SignInWithGoogle signInWithGoogle;
  late SignOut signOut;
  late UpdateUser updateUser;
  late AuthenticationBloc bloc;

  const apiFailure = ApiFailure(message: 'User not found', statusCode: 404);
  final user = UserModel.empty();
  final updateUserParams = UpdateUserParams(user: user);

  setUp(() {
    getCurrentUser = MockGetCurrentUser();
    signInWithGoogle = MockSignInWithGoogle();
    signOut = MockSignOut();
    updateUser = MockUpdateUser();
    bloc = AuthenticationBloc(
      getCurrentUser: getCurrentUser,
      signInWithGoogle: signInWithGoogle,
      signOut: signOut,
      updateUser: updateUser,
    );
  });

  setUpAll(() {
    registerFallbackValue(updateUserParams);
  });

  tearDown(() => bloc.close());

  test('Initial state should be [AuthenticationInitial]', () {
    expect(bloc.state, const AuthenticationInitial());
  });

  group('GetCurrentUser:', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'Should emit [GettingCurrentUser, SignedIn] when successful',
      build: () {
        when(() => getCurrentUser()).thenAnswer(
          (_) async => Right(user),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const GetCurrentUserEvent(),
      ),
      expect: () => [
        const GettingCurrentUser(),
        SignedIn(user),
      ],
      verify: (_) {
        verify(
          () => getCurrentUser(),
        ).called(1);
        verifyNoMoreInteractions(getCurrentUser);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'Should emit [GettingCurrentUser, AuthenticationError] when unsuccessful',
      build: () {
        when(() => getCurrentUser()).thenAnswer(
          (_) async => const Left(apiFailure),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const GetCurrentUserEvent(),
      ),
      expect: () => [
        const GettingCurrentUser(),
        AuthenticationError(apiFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => getCurrentUser(),
        ).called(1);
        verifyNoMoreInteractions(getCurrentUser);
      },
    );
  });

  group('SignInWithGoogle:', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'Should emit [SigningInWithGoogle, SignedIn] when successful',
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
        SignedIn(user),
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

  group('UpdateUser:', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'Should emit [UpdatingUser, SignedIn] when successful',
      build: () {
        when(() => updateUser(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(user: updateUserParams.user),
      ),
      expect: () => [
        const UpdatingUser(),
        SignedIn(user),
      ],
      verify: (_) {
        verify(
          () => updateUser(updateUserParams),
        );
        verifyNoMoreInteractions(updateUser);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'Should emit [UpdatingUser, AuthenticationError] when unsuccessful',
      build: () {
        when(() => updateUser(any())).thenAnswer(
          (_) async => const Left(apiFailure),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(user: user),
      ),
      expect: () => [
        const UpdatingUser(),
        AuthenticationError(apiFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => updateUser(any()),
        ).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });
}
