import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdpa/core/errors/exceptions.dart';
import 'package:pdpa/core/errors/failure.dart';
import 'package:pdpa/features/authentication/data/datasources/remote/authentication_remote_data_source.dart';
import 'package:pdpa/features/authentication/data/models/user_model.dart';
import 'package:pdpa/features/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:pdpa/features/authentication/domain/entities/user.dart';

class MockAuthRemoteDataSrc extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repositoryImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSrc();
    repositoryImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });

  final model = UserModel.empty();
  const exception = ApiException(
    message: 'Unknown error occurred',
    statusCode: 500,
  );
  final failure = ApiFailure(
    message: exception.message,
    statusCode: exception.statusCode,
  );

  group('Test signInWithEmailAndPassword:', () {
    const email = '';
    const password = '';

    test(
      'Should call the [RemoteDataSource.signInWithEmailAndPassword] '
      'and complete successfully when the call to the remote data source is successful',
      () async {
        //? Arrange
        when(
          () => remoteDataSource.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => model);

        //? Act
        final result = await repositoryImpl.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        //? Assert
        expect(result, isA<Right<dynamic, User>>());
        verify(
          () => remoteDataSource.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
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
          () => remoteDataSource.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(exception);

        //? Act
        final result = await repositoryImpl.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        //? Assert
        expect(result, equals(Left(failure)));
        verify(
          () => remoteDataSource.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
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
        expect(result, isA<Right<dynamic, User>>());
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
}
