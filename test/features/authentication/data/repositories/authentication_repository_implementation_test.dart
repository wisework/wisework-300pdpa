import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdpa/core/errors/exceptions.dart';
import 'package:pdpa/core/errors/failure.dart';
import 'package:pdpa/features/authentication/data/datasources/remote/authentication_remote_data_source.dart';
import 'package:pdpa/features/authentication/data/models/user_model.dart';
import 'package:pdpa/features/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';

class MockAuthRemoteDataSrc extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repositoryImpl;

  final model = UserModel.empty();
  const exception = ApiException(
    message: 'Unknown error occurred',
    statusCode: 500,
  );
  final failure = ApiFailure(
    message: exception.message,
    statusCode: exception.statusCode,
  );

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSrc();
    repositoryImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });

  setUpAll(() {
    registerFallbackValue(model);
  });

  group('Test getCurrentUser:', () {
    test(
      'Should call the [RemoteDataSource.getCurrentUser] '
      'and complete successfully when the call to the remote data source is successful',
      () async {
        //? Arrange
        when(
          () => remoteDataSource.getCurrentUser(),
        ).thenAnswer((_) async => model);

        //? Act
        final result = await repositoryImpl.getCurrentUser();

        //? Assert
        expect(result, isA<Right<dynamic, UserEntity>>());
        verify(
          () => remoteDataSource.getCurrentUser(),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'Should return a [ApiFailure] '
      'when the call to the remote data source is unsuccessful',
      () async {
        //? Arrange
        when(
          () => remoteDataSource.getCurrentUser(),
        ).thenThrow(exception);

        //? Act
        final result = await repositoryImpl.getCurrentUser();

        //? Assert
        expect(result, equals(Left(failure)));
        verify(
          () => remoteDataSource.getCurrentUser(),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('Test signInWithGoogle:', () {
    test(
      'Should call the [RemoteDataSource.signInWithGoogle] '
      'and complete successfully when the call to the remote data source is successful',
      () async {
        //? Arrange
        when(
          () => remoteDataSource.signInWithGoogle(),
        ).thenAnswer((_) async => model);

        //? Act
        final result = await repositoryImpl.signInWithGoogle();

        //? Assert
        expect(result, isA<Right<dynamic, UserEntity>>());
        verify(
          () => remoteDataSource.signInWithGoogle(),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'Should return a [ApiFailure] '
      'when the call to the remote data source is unsuccessful',
      () async {
        //? Arrange
        when(
          () => remoteDataSource.signInWithGoogle(),
        ).thenThrow(exception);

        //? Act
        final result = await repositoryImpl.signInWithGoogle();

        //? Assert
        expect(result, equals(Left(failure)));
        verify(
          () => remoteDataSource.signInWithGoogle(),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('Test signOut:', () {
    test(
      'Should call the [RemoteDataSource.signOut] '
      'and complete successfully when the call to the remote data source is successful',
      () async {
        //? Arrange
        when(
          () => remoteDataSource.signOut(),
        ).thenAnswer((_) async => const Right(null));

        //? Act
        final result = await repositoryImpl.signOut();

        //? Assert
        expect(result, equals(const Right(null)));
        verify(
          () => remoteDataSource.signOut(),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'Should return a [ApiFailure] '
      'when the call to the remote data source is unsuccessful',
      () async {
        //? Arrange
        when(
          () => remoteDataSource.signOut(),
        ).thenThrow(exception);

        //? Act
        final result = await repositoryImpl.signOut();

        //? Assert
        expect(result, equals(Left(failure)));
        verify(
          () => remoteDataSource.signOut(),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('Test updateUser:', () {
    test(
      'Should call the [RemoteDataSource.updateUser] '
      'and complete successfully when the call to the remote data source is successful',
      () async {
        //? Arrange
        when(
          () => remoteDataSource.updateUser(user: any(named: 'user')),
        ).thenAnswer((_) async => model);

        //? Act
        final result = await repositoryImpl.updateUser(user: model);

        //? Assert
        expect(result, equals(const Right(null)));
        verify(
          () => remoteDataSource.updateUser(user: model),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'Should return a [ApiFailure] '
      'when the call to the remote data source is unsuccessful',
      () async {
        //? Arrange
        when(
          () => remoteDataSource.updateUser(user: any(named: 'user')),
        ).thenThrow(exception);

        //? Act
        final result = await repositoryImpl.updateUser(user: model);

        //? Assert
        expect(result, equals(Left(failure)));
        verify(
          () => remoteDataSource.updateUser(user: model),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
