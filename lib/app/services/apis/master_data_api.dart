import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';

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

  //? Request Type
  Future<List<RequestTypeModel>> getRequestTypes(String companyId) async {
    final result =
        await _firestore.collection('Companies/$companyId/RequestTypes').get();

    List<RequestTypeModel> requestTypes = [];
    for (var document in result.docs) {
      requestTypes.add(RequestTypeModel.fromDocument(document));
    }

    return requestTypes;
  }

  Future<RequestTypeModel?> getRequestTypeById(
    String requestTypeId,
    String companyId,
  ) async {
    final result = await _firestore
        .collection('Companies/$companyId/RequestTypes')
        .doc(requestTypeId)
        .get();

    if (!result.exists) return null;
    return RequestTypeModel.fromDocument(result);
  }

  Future<RequestTypeModel> createRequestType(
    RequestTypeModel requestType,
    String companyId,
  ) async {
    final ref =
        _firestore.collection('Companies/$companyId/RequestTypes').doc();
    final created = requestType.copyWith(requestTypeId: ref.id);

    await ref.set(created.toMap());

    return created;
  }

  Future<void> updateRequestType(
    RequestTypeModel requestType,
    String companyId,
  ) async {
    await _firestore
        .collection('Companies/$companyId/RequestTypes')
        .doc(requestType.requestTypeId)
        .set(requestType.toMap());
  }

  Future<void> deleteRequestType(
    String requestTypeId,
    String companyId,
  ) async {
    if (requestTypeId.isNotEmpty) {
      await _firestore
          .collection('Companies/$companyId/RequestTypes')
          .doc(requestTypeId)
          .delete();
    }
  }

  //? Reject Type
  Future<List<RejectTypeModel>> getRejectTypes(String companyId) async {
    final result =
        await _firestore.collection('Companies/$companyId/RejectTypes').get();

    List<RejectTypeModel> rejectTypes = [];
    for (var document in result.docs) {
      rejectTypes.add(RejectTypeModel.fromDocument(document));
    }

    return rejectTypes;
  }

  Future<RejectTypeModel?> getRejectTypeById(
    String rejectTypeId,
    String companyId,
  ) async {
    final result = await _firestore
        .collection('Companies/$companyId/RejectTypes')
        .doc(rejectTypeId)
        .get();

    if (!result.exists) return null;
    return RejectTypeModel.fromDocument(result);
  }

  Future<RejectTypeModel> createRejectType(
    RejectTypeModel rejectType,
    String companyId,
  ) async {
    final ref =
        _firestore.collection('Companies/$companyId/RejectTypes').doc();
    final created = rejectType.copyWith(rejectTypeId: ref.id);

    await ref.set(created.toMap());

    return created;
  }

  Future<void> updateRejectType(
    RejectTypeModel rejectType,
    String companyId,
  ) async {
    await _firestore
        .collection('Companies/$companyId/RejectTypes')
        .doc(rejectType.rejectTypeId)
        .set(rejectType.toMap());
  }

  Future<void> deleteRejectType(
    String rejectTypeId,
    String companyId,
  ) async {
    if (rejectTypeId.isNotEmpty) {
      await _firestore
          .collection('Companies/$companyId/RejectTypes')
          .doc(rejectTypeId)
          .delete();
    }
  }

  //? Reason Type
  Future<List<ReasonTypeModel>> getReasonTypes(String companyId) async {
    final result =
        await _firestore.collection('Companies/$companyId/ReasonTypes').get();

    List<ReasonTypeModel> reasonTypes = [];
    for (var document in result.docs) {
      reasonTypes.add(ReasonTypeModel.fromDocument(document));
    }

    return reasonTypes;
  }

  Future<ReasonTypeModel?> getReasonTypeById(
    String reasonTypeId,
    String companyId,
  ) async {
    final result = await _firestore
        .collection('Companies/$companyId/ReasonTypes')
        .doc(reasonTypeId)
        .get();

    if (!result.exists) return null;
    return ReasonTypeModel.fromDocument(result);
  }

  Future<ReasonTypeModel> createReasonType(
    ReasonTypeModel reasonType,
    String companyId,
  ) async {
    final ref =
        _firestore.collection('Companies/$companyId/ReasonTypes').doc();
    final created = reasonType.copyWith(reasonTypeId: ref.id);

    await ref.set(created.toMap());

    return created;
  }

  Future<void> updateReasonType(
    ReasonTypeModel reasonType,
    String companyId,
  ) async {
    await _firestore
        .collection('Companies/$companyId/ReasonTypes')
        .doc(reasonType.reasonTypeId)
        .set(reasonType.toMap());
  }

  Future<void> deleteReasonType(
    String reasonTypeId,
    String companyId,
  ) async {
    if (reasonTypeId.isNotEmpty) {
      await _firestore
          .collection('Companies/$companyId/ReasonTypes')
          .doc(reasonTypeId)
          .delete();
    }
  }
}
