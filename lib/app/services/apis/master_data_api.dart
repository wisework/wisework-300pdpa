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

  Future<PurposeModel?> getPurposeById(
    String purposeId,
    String companyId,
  ) async {
    final result = await _firestore
        .collection('Companies/$companyId/Purposes')
        .doc(purposeId)
        .get();

    if (!result.exists) return null;
    return PurposeModel.fromDocument(result);
  }

  Future<PurposeModel> updatePurpose(
    PurposeModel purpose,
    String companyId,
  ) async {
    if (purpose.id.isEmpty) {
      final ref = _firestore.collection('Companies/$companyId/Purposes').doc();
      final created = purpose.copyWith(id: ref.id);

      await ref.set(created.toMap());

      return created;
    } else {
      await _firestore
          .collection('Companies/$companyId/Purposes')
          .doc(purpose.id)
          .set(purpose.toMap());

      return purpose;
    }
  }
}
