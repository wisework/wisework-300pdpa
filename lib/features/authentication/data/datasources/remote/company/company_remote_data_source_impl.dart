import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdpa/features/authentication/data/datasources/remote/company/company_remote_data_source.dart';
import 'package:pdpa/features/authentication/data/models/company_model.dart';
import 'package:pdpa/features/authentication/domain/entities/company_entity.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';

class CompanyRemoteDataSourceImpl extends CompanyRemoteDataSource {
  CompanyRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<List<CompanyEntity>> getUserCompanies({
    required UserEntity user,
  }) async {
    List<CompanyModel> companies = [];

    for (String companyId in user.companies) {
      final document =
          await _firestore.collection('Companies').doc(companyId).get();

      if (document.exists) {
        companies.add(CompanyModel.fromDocument(document));
      }
    }

    return companies;
  }
}
