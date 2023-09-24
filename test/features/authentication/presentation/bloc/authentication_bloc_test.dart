import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdpa/core/errors/failure.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';
import 'package:pdpa/features/authentication/domain/usecases/get_current_user.dart';
import 'package:pdpa/features/authentication/domain/usecases/sign_in_with_google.dart';
import 'package:pdpa/features/authentication/domain/usecases/sign_out.dart';
import 'package:pdpa/features/authentication/domain/usecases/update_user.dart';
import 'package:pdpa/features/authentication/presentation/bloc/authentication_bloc.dart';

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockSignOut extends Mock implements SignOut {}

class MockUpdateUser extends Mock implements UpdateUser {}

class MockUser extends Mock implements UserEntity {}

void main() {
  late GetCurrentUser getCurrentUser;
  late SignInWithGoogle signInWithGoogle;
  late SignOut signOut;
  late UpdateUser updateUser;
  late UserEntity user;
  late AuthenticationBloc bloc;

  const apiFailure = ApiFailure(message: 'User not found', statusCode: 404);
  final updateUserParams = UpdateUserParams.empty();

  setUp(() {
    getCurrentUser = MockGetCurrentUser();
    signInWithGoogle = MockSignInWithGoogle();
    signOut = MockSignOut();
    updateUser = MockUpdateUser();
    user = MockUser();
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
      'Should emit [GettingCurrentUser, GotCurrentUser] when successful',
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
        GotCurrentUser(user),
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

  group('UpdateUser:', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'Should emit [UpdatingUser, UpdatedUser] when successful',
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
        const UpdatedUser(),
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
