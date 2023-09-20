import 'package:dartz/dartz.dart';
import 'package:pdpa/core/errors/exceptions.dart';
import 'package:pdpa/core/errors/failure.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/data/datasources/remote/authentication_remote_data_source.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';
import 'package:pdpa/features/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  const AuthenticationRepositoryImplementation(this._remoteDataSource);

  final AuthenticationRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<UserEntity> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();

      return Right(user);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  @override
  ResultFuture<UserEntity> signInWithGoogle() async {
    try {
      final user = await _remoteDataSource.signInWithGoogle();

      return Right(user);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  @override
  ResultVoid signOut() async {
    try {
      await _remoteDataSource.signOut();

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  @override
  ResultVoid updateUser({
    required UserEntity user,
  }) async {
    try {
      await _remoteDataSource.updateUser(user: user);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }
}
