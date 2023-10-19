import 'package:dartz/dartz.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_reason_template_model.dart';
import 'package:pdpa/app/data/models/master_data/request_reject_template_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/services/apis/master_data_api.dart';
import 'package:pdpa/app/shared/errors/exceptions.dart';
import 'package:pdpa/app/shared/errors/failure.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class MasterDataRepository {
  const MasterDataRepository(this._api);

  final MasterDataApi _api;

  //? Mandatory Field
  ResultFuture<List<MandatoryFieldModel>> getMandatoryFields(
    String companyId,
  ) async {
    try {
      final result = await _api.getMandatoryFields(companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<MandatoryFieldModel> getMandatoryFieldById(
    String mandatoryFieldId,
    String companyId,
  ) async {
    try {
      final result = await _api.getMandatoryFieldById(
        mandatoryFieldId,
        companyId,
      );

      if (result != null) return Right(result);

      return const Left(
        ApiFailure(message: 'Mandatory field not found', statusCode: 404),
      );
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<MandatoryFieldModel> createMandatoryField(
    MandatoryFieldModel mandatoryField,
    String companyId,
  ) async {
    try {
      final result = await _api.createMandatoryField(mandatoryField, companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid updateMandatoryField(
    MandatoryFieldModel mandatoryField,
    String companyId,
  ) async {
    try {
      await _api.updateMandatoryField(mandatoryField, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid deleteMandatoryField(
    String mandatoryFieldId,
    String companyId,
  ) async {
    try {
      await _api.deleteMandatoryField(mandatoryFieldId, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  //? Custom Field
  ResultFuture<List<CustomFieldModel>> getCustomFields(
    String companyId,
  ) async {
    try {
      final result = await _api.getCustomFields(companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<CustomFieldModel> getCustomFieldById(
    String customFieldId,
    String companyId,
  ) async {
    try {
      final result = await _api.getCustomFieldById(customFieldId, companyId);

      if (result != null) return Right(result);

      return const Left(
        ApiFailure(message: 'Custom field not found', statusCode: 404),
      );
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<CustomFieldModel> createCustomField(
    CustomFieldModel customField,
    String companyId,
  ) async {
    try {
      final result = await _api.createCustomField(customField, companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid updateCustomField(
    CustomFieldModel customField,
    String companyId,
  ) async {
    try {
      await _api.updateCustomField(customField, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid deleteCustomField(
    String customFieldId,
    String companyId,
  ) async {
    try {
      await _api.deleteCustomField(customFieldId, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  //? Purpose Category
  ResultFuture<List<PurposeCategoryModel>> getPurposeCategories(
    String companyId,
  ) async {
    try {
      final result = await _api.getPurposeCategories(companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<PurposeCategoryModel> getPurposeCategoryById(
    String purposeCategoryId,
    String companyId,
  ) async {
    try {
      final result =
          await _api.getPurposeCategoryById(purposeCategoryId, companyId);

      if (result != null) return Right(result);

      return const Left(
        ApiFailure(message: 'Purpose not found', statusCode: 404),
      );
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<PurposeCategoryModel> createPurposeCategory(
    PurposeCategoryModel purposeCategory,
    String companyId,
  ) async {
    try {
      final result =
          await _api.createPurposeCategory(purposeCategory, companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid updatePurposeCategory(
    PurposeCategoryModel purposeCategory,
    String companyId,
  ) async {
    try {
      await _api.updatePurposeCategory(purposeCategory, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid deletePurposeCategory(
    String purposeCategoryId,
    String companyId,
  ) async {
    try {
      await _api.deletePurposeCategory(purposeCategoryId, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  //? Purpose
  ResultFuture<List<PurposeModel>> getPurposes(String companyId) async {
    try {
      final result = await _api.getPurposes(companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<PurposeModel> getPurposeById(
    String purposeId,
    String companyId,
  ) async {
    try {
      final result = await _api.getPurposeById(purposeId, companyId);

      if (result != null) return Right(result);

      return const Left(
        ApiFailure(message: 'Purpose not found', statusCode: 404),
      );
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<PurposeModel> createPurpose(
    PurposeModel purpose,
    String companyId,
  ) async {
    try {
      final result = await _api.createPurpose(purpose, companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid updatePurpose(
    PurposeModel purpose,
    String companyId,
  ) async {
    try {
      await _api.updatePurpose(purpose, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid deletePurpose(
    String purposeId,
    String companyId,
  ) async {
    try {
      await _api.deletePurpose(purposeId, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  //? Request Type
  ResultFuture<List<RequestTypeModel>> getRequestTypes(
    String companyId,
  ) async {
    try {
      final result = await _api.getRequestTypes(companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<RequestTypeModel> getRequestTypeById(
    String requestTypeId,
    String companyId,
  ) async {
    try {
      final result = await _api.getRequestTypeById(requestTypeId, companyId);

      if (result != null) return Right(result);

      return const Left(
        ApiFailure(message: 'Request type not found', statusCode: 404),
      );
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<RequestTypeModel> createRequestType(
    RequestTypeModel requestType,
    String companyId,
  ) async {
    try {
      final result = await _api.createRequestType(requestType, companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid updateRequestType(
    RequestTypeModel requestType,
    String companyId,
  ) async {
    try {
      await _api.updateRequestType(requestType, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid deleteRequestType(
    String requestTypeId,
    String companyId,
  ) async {
    try {
      await _api.deleteRequestType(requestTypeId, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

//? Reject Type
  ResultFuture<List<RejectTypeModel>> getRejectTypes(
    String companyId,
  ) async {
    try {
      final result = await _api.getRejectTypes(companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<RejectTypeModel> getRejectTypeById(
    String rejectTypeId,
    String companyId,
  ) async {
    try {
      final result = await _api.getRejectTypeById(rejectTypeId, companyId);

      if (result != null) return Right(result);

      return const Left(
        ApiFailure(message: 'Reject type not found', statusCode: 404),
      );
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<RejectTypeModel> createRejectType(
    RejectTypeModel rejectType,
    String companyId,
  ) async {
    try {
      final result = await _api.createRejectType(rejectType, companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid updateRejectType(
    RejectTypeModel rejectType,
    String companyId,
  ) async {
    try {
      await _api.updateRejectType(rejectType, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid deleteRejectType(
    String rejectTypeId,
    String companyId,
  ) async {
    try {
      await _api.deleteRejectType(rejectTypeId, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

//? Reason Type
  ResultFuture<List<ReasonTypeModel>> getReasonTypes(
    String companyId,
  ) async {
    try {
      final result = await _api.getReasonTypes(companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<ReasonTypeModel> getReasonTypeById(
    String reasonTypeId,
    String companyId,
  ) async {
    try {
      final result = await _api.getReasonTypeById(reasonTypeId, companyId);

      if (result != null) return Right(result);

      return const Left(
        ApiFailure(message: 'Reason type not found', statusCode: 404),
      );
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<ReasonTypeModel> createReasonType(
    ReasonTypeModel reasonType,
    String companyId,
  ) async {
    try {
      final result = await _api.createReasonType(reasonType, companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid updateReasonType(
    ReasonTypeModel reasonType,
    String companyId,
  ) async {
    try {
      await _api.updateReasonType(reasonType, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid deleteReasonType(
    String reasonTypeId,
    String companyId,
  ) async {
    try {
      await _api.deleteReasonType(reasonTypeId, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

//? Request Reason Template
  ResultFuture<List<RequestReasonTemplateModel>> getRequestReasonTemplates(
    String companyId,
  ) async {
    try {
      final result = await _api.getRequestReasonTemplates(companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<RequestReasonTemplateModel> getRequestReasonTemplateById(
    String requestReasonId,
    String companyId,
  ) async {
    try {
      final result =
          await _api.getRequestReasonTemplateById(requestReasonId, companyId);

      if (result != null) return Right(result);

      return const Left(
        ApiFailure(message: 'Reason type not found', statusCode: 404),
      );
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<RequestReasonTemplateModel> createRequestReasonTemplate(
    RequestReasonTemplateModel requestReason,
    String companyId,
  ) async {
    try {
      final result =
          await _api.createRequestReasonTemplate(requestReason, companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid updateRequestReasonTemplate(
    RequestReasonTemplateModel requestReason,
    String companyId,
  ) async {
    try {
      await _api.updateRequestReasonTemplate(requestReason, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid deleteRequestReasonTemplate(
    String requestReasonId,
    String companyId,
  ) async {
    try {
      await _api.deleteRequestReasonTemplate(requestReasonId, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

//? Request Reject Template
  ResultFuture<List<RequestRejectTemplateModel>> getRequestRejectTemplates(
    String companyId,
  ) async {
    try {
      final result = await _api.getRequestRejectTemplates(companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<RequestRejectTemplateModel> getRequestRejectTemplateById(
    String requestRejectId,
    String companyId,
  ) async {
    try {
      final result =
          await _api.getRequestRejectTemplateById(requestRejectId, companyId);

      if (result != null) return Right(result);

      return const Left(
        ApiFailure(message: 'Reason type not found', statusCode: 404),
      );
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<RequestRejectTemplateModel> createRequestRejectTemplate(
    RequestRejectTemplateModel requestReject,
    String companyId,
  ) async {
    try {
      final result =
          await _api.createRequestRejectTemplate(requestReject, companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid updateRequestRejectTemplate(
    RequestRejectTemplateModel requestReject,
    String companyId,
  ) async {
    try {
      await _api.updateRequestRejectTemplate(requestReject, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid deleteRequestRejectTemplate(
    String requestRejectId,
    String companyId,
  ) async {
    try {
      await _api.deleteRequestRejectTemplate(requestRejectId, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }
}
