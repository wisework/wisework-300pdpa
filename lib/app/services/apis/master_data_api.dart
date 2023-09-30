import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';

class MasterDataApi {
  const MasterDataApi(this._firestore);

  final FirebaseFirestore _firestore;

  //? Purpose
  Future<List<PurposeModel>> getPurposes(String companyId) async {
    final result =
        await _firestore.collection('Companies/$companyId/Purposes').get();

    List<PurposeModel> purposes = [];
    for (var document in result.docs) {
      purposes.add(PurposeModel.fromDocument(document));
    }

    return purposes;
  }
}
