import 'package:dartz/dartz.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/services/apis/authentication_api.dart';
import 'package:pdpa/app/shared/errors/exceptions.dart';
import 'package:pdpa/app/shared/errors/failure.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class AuthenticationRepository {
  const AuthenticationRepository(this._api);

  final AuthenticationApi _api;

  //? Authentication
  ResultFuture<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _api.signInWithEmailAndPassword(email, password);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<UserModel> signInWithGoogle() async {
    try {
      final result = await _api.signInWithGoogle();

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    } catch (error) {
      if (error == 'popup_closed') {
        return const Left(
          ApiFailure(message: 'Sign in was canceled', statusCode: 401),
        );
      }
      return Left(
        ApiFailure(message: error.toString(), statusCode: 500),
      );
    }
  }

  ResultVoid signOut() async {
    try {
      await _api.signOut();

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid sendPasswordResetEmail(String email) async {
    try {
      await _api.sendPasswordResetEmail(email);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  //? User
  ResultFuture<UserModel> getCurrentUser() async {
    try {
      final result = await _api.getCurrentUser();

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await _api.updatePassword(currentPassword, newPassword);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid verifyEmail() async {
    try {
      await _api.verifyEmail();

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<UserModel> updateCurrentUser(UserModel user) async {
    try {
      final result = await _api.updateCurrentUser(user);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  //? Company
  ResultFuture<List<CompanyModel>> getUserCompanies(
    List<String> companyIds,
  ) async {
    try {
      final result = await _api.getUserCompanies(companyIds);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<CompanyModel> getCompanyById(String companyId) async {
    try {
      final result = await _api.getCompanyById(companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<CompanyModel> createCompany(CompanyModel company) async {
    try {
      final result = await _api.createCompany(company);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }
}
