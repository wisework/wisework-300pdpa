import 'dart:io';

import 'package:path/path.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';

import 'constants.dart';

class UtilFunctions {
  //? Company
  static CompanyModel getCurrentCompany(
    List<CompanyModel> companies,
    String currentCompanyId,
  ) {
    for (CompanyModel company in companies) {
      if (company.id == currentCompanyId) return company;
    }
    return CompanyModel.empty();
  }

  //? User Consent Form
  static String getUserConsentForm(String consentId, String companyId) {
    final fragment = 'companies/$companyId/consent-forms/$consentId/form';
    return '${AppConfig.baseUrl}/#/$fragment';
  }

  //? Custom Field
  static List<CustomFieldModel> filterCustomFieldsByIds(
    List<CustomFieldModel> customFields,
    List<String> customFieldsIds,
  ) {
    return customFields
        .where((category) => customFieldsIds.contains(category.id))
        .toList();
  }

  //? Purpose Category
  static List<PurposeCategoryModel> filterPurposeCategoriesByIds(
    List<PurposeCategoryModel> purposeCategories,
    List<String> purposeCategoryIds,
  ) {
    return purposeCategories
        .where((category) => purposeCategoryIds.contains(category.id))
        .toList();
  }

  //? Purpose
  static List<PurposeModel> filterPurposeByIds(
    List<PurposeModel> purposes,
    List<String> purposeIds,
  ) {
    List<PurposeModel> purposeFiltered = [];

    for (String id in purposeIds) {
      final purpose = purposes.where((purpose) => purpose.id == id).firstOrNull;

      if (purpose != null) purposeFiltered.add(purpose);
    }

    return purposeFiltered;
  }

  //? Data Subject Right
  static RequestProcessStatus getRequestProcessStatus(
    DataSubjectRightModel dataSubjectRight,
  ) {
    final isNewRequested = dataSubjectRight.lastSeenBy.isEmpty;
    final isRequestFormVerified = dataSubjectRight.requestFormVerified;
    final isVerifying =
        dataSubjectRight.requestVerifyingStatus == RequestVerifyingStatus.none;
    final isConsidering = dataSubjectRight.processRequests.any((process) =>
        process.considerRequestStatus == ConsiderRequestStatus.none);
    final isProofFileUploading = dataSubjectRight.processRequests
        .any((process) => process.proofOfActionFile.isEmpty);
    final isProofTextWriting = dataSubjectRight.processRequests
        .any((process) => process.proofOfActionText.isEmpty);
    final isProofFileUploaded = dataSubjectRight.processRequests
        .where((process) =>
            process.considerRequestStatus == ConsiderRequestStatus.pass)
        .any((process) => process.proofOfActionFile.isEmpty);
    final isProofTextWritten = dataSubjectRight.processRequests
        .where((process) =>
            process.considerRequestStatus == ConsiderRequestStatus.pass)
        .any((process) => process.proofOfActionText.isEmpty);
    final isDone = dataSubjectRight.resultRequest;

    RequestProcessStatus status = RequestProcessStatus.newRequest;
    if (isNewRequested) {
      return status;
    }

    if (!isRequestFormVerified && !isNewRequested) {
      status = RequestProcessStatus.pending;
    } else if (isRequestFormVerified && isDone && !isNewRequested) {
      status = RequestProcessStatus.rejected;
    }

    if (isVerifying && !isNewRequested && isRequestFormVerified) {
      status = RequestProcessStatus.verifying;
    } else if (isConsidering &&
        !isNewRequested &&
        isRequestFormVerified &&
        !isVerifying) {
      status = RequestProcessStatus.considering;
    } else if ((isProofFileUploading || isProofTextWriting) &&
        !isNewRequested &&
        isRequestFormVerified &&
        !isVerifying &&
        !isConsidering) {
      status = RequestProcessStatus.inProgress;
    }

    if (isDone &&
        !isNewRequested &&
        isRequestFormVerified &&
        !isVerifying &&
        !isConsidering &&
        !isProofFileUploaded &&
        !isProofTextWritten) {
      status = RequestProcessStatus.completed;
    }

    return status;
  }

  //? Upload File
  static String getUniqueFileName(File file) {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final fileExtension = extension(file.path);

    return '$fileName$fileExtension';
  }

  static String getFileNameFromUrl(String url) {
    if (url.isEmpty) return '';

    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;

    return pathSegments.last;
  }

  static String getConsentImagePath(
    String companyId,
    String consentFormId,
    ConsentFormImageType imageType,
  ) {
    final company = 'companies/$companyId';
    final consent = 'consents/$consentFormId';
    final folder = '${imageType.name}/';

    return [company, consent, folder].join('/');
  }
}
