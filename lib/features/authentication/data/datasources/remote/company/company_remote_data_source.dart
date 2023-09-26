import 'package:pdpa/features/authentication/domain/entities/company_entity.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';

abstract class CompanyRemoteDataSource {
  Future<List<CompanyEntity>> getUserCompanies({required UserEntity user});
}
