import 'dart:math';

import 'package:path/path.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/etc/user_company_role.dart';
import 'package:pdpa/app/data/models/etc/user_input_purpose.dart';
import 'package:pdpa/app/data/models/etc/user_input_text.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
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

  static String getUserCompanyRole(
    List<UserCompanyRole> userCompanyRoles,
    String currentCompanyId,
  ) {
    final role = userCompanyRoles
        .firstWhere(
          (role) => role.id == currentCompanyId,
          orElse: () => const UserCompanyRole.empty(),
        )
        .role;

    return '${role.name[0].toUpperCase()}${role.name.substring(1)}';
  }

  //? User Consent Form
  static String getUserConsentFormUrl(String consentId, String companyId) {
    final fragment = 'companies/$companyId/consent-forms/$consentId/form';
    return '${AppConfig.baseUrl}/#/$fragment';
  }

  static String getValueFromUserInputText(
    List<UserInputText> userInputs,
    String mapId,
  ) {
    final result = userInputs.firstWhere(
      (input) => input.id == mapId,
      orElse: () => const UserInputText.empty(),
    );

    return result.text;
  }

  static bool getValueFromUserInputPurpose(
    List<UserInputPurpose> userInputs,
    String mapId,
  ) {
    final result = userInputs.firstWhere(
      (input) => input.id == mapId,
      orElse: () => const UserInputPurpose.empty(),
    );

    return result.value;
  }

  //? Mandatory Field
  static List<MandatoryFieldModel> filterMandatoryFieldsByIds(
    List<MandatoryFieldModel> mandatoryFields,
    List<String> mandatoryFieldIds,
  ) {
    return mandatoryFields
        .where((category) => mandatoryFieldIds.contains(category.id))
        .toList();
  }

  //? Purpose Category
  static List<PurposeCategoryModel> filterPurposeCategoriesByIds(
    List<PurposeCategoryModel> purposeCategories,
    List<String> purposeCategoryIds,
  ) {
    List<PurposeCategoryModel> filtered = [];
    final empty = PurposeCategoryModel.empty();

    for (String id in purposeCategoryIds) {
      final result = purposeCategories.firstWhere(
        (category) => category.id == id,
        orElse: () => empty,
      );

      if (result != empty) {
        filtered.add(result);
      }
    }

    return filtered;
  }

  static List<PurposeCategoryModel> reorderPurposeCategories(
    List<PurposeCategoryModel> purposeCategories,
  ) {
    return purposeCategories
        .asMap()
        .entries
        .map((entry) => entry.value.copyWith(priority: entry.key + 1))
        .toList();
  }

  static PurposeCategoryModel getPurposeCategoryById(
    List<PurposeCategoryModel> purposeCategories,
    String purposeCategoryId,
  ) {
    return purposeCategories.firstWhere(
      (category) => category.id == purposeCategoryId,
      orElse: () => PurposeCategoryModel.empty(),
    );
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

  //? Custom Field
  static List<CustomFieldModel> filterCustomFieldsByIds(
    List<CustomFieldModel> customFields,
    List<String> customFieldIds,
  ) {
    return customFields
        .where((category) => customFieldIds.contains(category.id))
        .toList();
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
  static String getUniqueFileName(String path) {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final fileExtension = extension(path);

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

  //? Etc
  static String generatePassword() {
    String password = '';

    for (int index = 0; index < AppConfig.generatePasswordLength; index++) {
      final randomAlphabet = alphabets[Random().nextInt(alphabets.length)];
      final randomNumber = numbers[Random().nextInt(numbers.length)];
      final characters = [randomAlphabet.toUpperCase(), randomNumber];

      password += characters[Random().nextInt(characters.length)];
    }

    return password;
  }
}
