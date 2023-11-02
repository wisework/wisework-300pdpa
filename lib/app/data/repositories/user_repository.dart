import 'package:dartz/dartz.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/services/apis/user_api.dart';
import 'package:pdpa/app/shared/errors/exceptions.dart';
import 'package:pdpa/app/shared/errors/failure.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class UserRepository {
  const UserRepository(this._api);

  final UserApi _api;

  ResultFuture<List<UserModel>> getUsers() async {
    try {
      final user = await _api.getUsers();

      return Right(user);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<UserModel> getUserById(String userId) async {
    try {
      final user = await _api.getUserById(userId);

      if (user != null) return Right(user);

      return const Left(
        ApiFailure(message: 'User not found', statusCode: 404),
      );
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }
}
