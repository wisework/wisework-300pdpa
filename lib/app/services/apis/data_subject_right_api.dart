import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';

class DataSubjectRightApi {
  const DataSubjectRightApi(this._firestore);

  final FirebaseFirestore _firestore;

  //? Data Subject Right
  Future<List<DataSubjectRightModel>> getDataSubjectRights(
      String companyId) async {
    final result = await _firestore
        .collection('Companies/$companyId/DataSubjectRights')
        .get();

    List<DataSubjectRightModel> dataSubjectRights = [];
    for (var document in result.docs) {
      dataSubjectRights.add(DataSubjectRightModel.fromDocument(document));
    }

    return dataSubjectRights;
  }

  Future<DataSubjectRightModel?> getDataSubjectRightById(
    String dataSubjectRightId,
    String companyId,
  ) async {
    final result = await _firestore
        .collection('Companies/$companyId/DataSubjectRights')
        .doc(dataSubjectRightId)
        .get();

    if (!result.exists) return null;
    return DataSubjectRightModel.fromDocument(result);
  }

  Future<DataSubjectRightModel> createDataSubjectRight(
    DataSubjectRightModel dataSubjectRight,
    String companyId,
  ) async {
    final ref =
        _firestore.collection('Companies/$companyId/DataSubjectRights').doc();
    final created = dataSubjectRight.copyWith(id: ref.id);

    await ref.set(created.toMap());

    return created;
  }

  Future<void> updateDataSubjectRight(
    DataSubjectRightModel dataSubjectRight,
    String companyId,
  ) async {
    await _firestore
        .collection('Companies/$companyId/DataSubjectRights')
        .doc(dataSubjectRight.id)
        .set(dataSubjectRight.toMap());
  }

  Future<void> deleteDataSubjectRight(
    String dataSubjectRightId,
    String companyId,
  ) async {
    if (dataSubjectRightId.isNotEmpty) {
      await _firestore
          .collection('Companies/$companyId/DataSubjectRights')
          .doc(dataSubjectRightId)
          .delete();
    }
  }
}
