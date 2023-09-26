import 'package:dartz/dartz.dart';
import 'package:pdpa/core/errors/exceptions.dart';
import 'package:pdpa/core/errors/failure.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/data/datasources/remote/company/company_remote_data_source.dart';
import 'package:pdpa/features/authentication/domain/entities/company_entity.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';
import 'package:pdpa/features/authentication/domain/repositories/company_repository.dart';

class CompanyRepositoryIpml implements CompanyRepository {
  const CompanyRepositoryIpml(this._remoteDataSource);

  final CompanyRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<CompanyEntity>> getUserCompanies({
    required UserEntity user,
  }) async {
    try {
      final companies = await _remoteDataSource.getUserCompanies(user: user);

      return Right(companies);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }
}
