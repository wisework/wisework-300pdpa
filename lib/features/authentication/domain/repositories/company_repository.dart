import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/domain/entities/company_entity.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';

abstract class CompanyRepository {
  const CompanyRepository();

  ResultFuture<List<CompanyEntity>> getUserCompanies({
    required UserEntity user,
  });
}
