import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
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

  Future<PurposeModel> createPurpose(
    PurposeModel purpose,
    String companyId,
  ) async {
    final ref = _firestore.collection('Companies/$companyId/Purposes').doc();
    final created = purpose.copyWith(id: ref.id);

    await ref.set(created.toMap());

    return created;
  }

  Future<void> updatePurpose(
    PurposeModel purpose,
    String companyId,
  ) async {
    await _firestore
        .collection('Companies/$companyId/Purposes')
        .doc(purpose.id)
        .set(purpose.toMap());
  }

  Future<void> deletePurpose(
    String purposeId,
    String companyId,
  ) async {
    if (purposeId.isNotEmpty) {
      await _firestore
          .collection('Companies/$companyId/Purposes')
          .doc(purposeId)
          .delete();
    }
  }

   //? Customfield
  Future<List<CustomFieldModel>> getCustomfield(String companyId) async {
    final result =
        await _firestore.collection('Companies/$companyId/CustomFields').get();

    List<CustomFieldModel> purposes = [];
    for (var document in result.docs) {
      purposes.add(CustomFieldModel.fromDocument(document));
    }

    return purposes;
  }

  Future<CustomFieldModel?> getCustomFieldById(
    String customfieldId,
    String companyId,
  ) async {
    final result = await _firestore
        .collection('Companies/$companyId/CustomFields')
        .doc(customfieldId)
        .get();

    if (!result.exists) return null;
    return CustomFieldModel.fromDocument(result);
  }

  Future<CustomFieldModel> createCustomField(
    CustomFieldModel customfield,
    String companyId,
  ) async {
    final ref = _firestore.collection('Companies/$companyId/CustomFields').doc();
    final created = customfield.copyWith(id: ref.id);

    await ref.set(created.toMap());

    return created;
  }

  Future<void> updateCustomField(
    CustomFieldModel customfield,
    String companyId,
  ) async {
    await _firestore
        .collection('Companies/$companyId/CustomFields')
        .doc(customfield.id)
        .set(customfield.toMap());
  }

  Future<void> deleteCustomField(
    String customfieldId,
    String companyId,
  ) async {
    if (customfieldId.isNotEmpty) {
      await _firestore
          .collection('Companies/$companyId/CustomFields')
          .doc(customfieldId)
          .delete();
    }
  }

}
