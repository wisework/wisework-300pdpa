import 'package:equatable/equatable.dart';
import 'package:pdpa/core/usecases/usecase_with_params.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/domain/entities/company_entity.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';
import 'package:pdpa/features/authentication/domain/repositories/company_repository.dart';

class GetUserCompanies
    extends UsecaseWithParams<List<CompanyEntity>, GetUserCompaniesParams> {
  GetUserCompanies(this._repository);

  final CompanyRepository _repository;

  @override
  ResultFuture<List<CompanyEntity>> call(GetUserCompaniesParams params) =>
      _repository.getUserCompanies(user: params.user);
}

class GetUserCompaniesParams extends Equatable {
  const GetUserCompaniesParams({
    required this.user,
  });

  GetUserCompaniesParams.empty() : this(user: UserEntity.empty());

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}
