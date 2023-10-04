import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';

class MasterDataApi {
  const MasterDataApi(this._firestore);

  final FirebaseFirestore _firestore;

  //? Custom Field
  Future<List<CustomFieldModel>> getCustomFields(String companyId) async {
    final result =
        await _firestore.collection('Companies/$companyId/CustomFields').get();

    List<CustomFieldModel> customFields = [];
    for (var document in result.docs) {
      customFields.add(CustomFieldModel.fromDocument(document));
    }

    return customFields;
  }

  Future<CustomFieldModel?> getCustomFieldById(
    String customFieldId,
    String companyId,
  ) async {
    final result = await _firestore
        .collection('Companies/$companyId/CustomFields')
        .doc(customFieldId)
        .get();

    if (!result.exists) return null;
    return CustomFieldModel.fromDocument(result);
  }

  Future<CustomFieldModel> createCustomField(
    CustomFieldModel customField,
    String companyId,
  ) async {
    final ref =
        _firestore.collection('Companies/$companyId/CustomFields').doc();
    final created = customField.copyWith(id: ref.id);

    await ref.set(created.toMap());

    return created;
  }

  Future<void> updateCustomField(
    CustomFieldModel customField,
    String companyId,
  ) async {
    await _firestore
        .collection('Companies/$companyId/CustomFields')
        .doc(customField.id)
        .set(customField.toMap());
  }

  Future<void> deleteCustomField(
    String customFieldId,
    String companyId,
  ) async {
    if (customFieldId.isNotEmpty) {
      await _firestore
          .collection('Companies/$companyId/CustomFields')
          .doc(customFieldId)
          .delete();
    }
  }

  //? Purpose Category
  Future<List<PurposeCategoryModel>> getPurposeCategories(
    String companyId,
  ) async {
    final result = await _firestore
        .collection('Companies/$companyId/PurposeCategories')
        .get();

    List<PurposeCategoryModel> purposeCategories = [];
    for (var document in result.docs) {
      purposeCategories.add(PurposeCategoryModel.fromDocument(document));
    }

    return purposeCategories;
  }

  Future<PurposeCategoryModel?> getPurposeCategoryById(
    String purposeCategoryId,
    String companyId,
  ) async {
    final result = await _firestore
        .collection('Companies/$companyId/PurposeCategories')
        .doc(purposeCategoryId)
        .get();

    if (!result.exists) return null;
    return PurposeCategoryModel.fromDocument(result);
  }

  Future<PurposeCategoryModel> createPurposeCategory(
    PurposeCategoryModel purposeCategory,
    String companyId,
  ) async {
    final ref =
        _firestore.collection('Companies/$companyId/PurposeCategories').doc();
    final created = purposeCategory.copyWith(id: ref.id);

    await ref.set(created.toMap());

    return created;
  }

  Future<void> updatePurposeCategory(
    PurposeCategoryModel purposeCategory,
    String companyId,
  ) async {
    await _firestore
        .collection('Companies/$companyId/PurposeCategories')
        .doc(purposeCategory.id)
        .set(purposeCategory.toMap());
  }

  Future<void> deletePurposeCategory(
    String purposeCategoryId,
    String companyId,
  ) async {
    if (purposeCategoryId.isNotEmpty) {
      await _firestore
          .collection('Companies/$companyId/PurposeCategories')
          .doc(purposeCategoryId)
          .delete();
    }
  }

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
}
