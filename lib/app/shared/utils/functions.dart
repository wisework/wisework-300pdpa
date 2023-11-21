import 'dart:math';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/power_verification_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/etc/user_company_role.dart';
import 'package:pdpa/app/data/models/etc/user_input_purpose.dart';
import 'package:pdpa/app/data/models/etc/user_input_text.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:path/path.dart' as p;

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
  static ProcessRequestStatus getProcessRequestStatus(
    ProcessRequestModel processRequest,
  ) {
    final considerRequestStatus = processRequest.considerRequestStatus;

    if (considerRequestStatus == RequestResultStatus.none) {
      return ProcessRequestStatus.notProcessed;
    } else if (considerRequestStatus == RequestResultStatus.fail) {
      return ProcessRequestStatus.refused;
    }

    if (processRequest.proofOfActionText.isNotEmpty) {
      return ProcessRequestStatus.completed;
    }

    return ProcessRequestStatus.inProgress;
  }

  static PowerVerificationModel getPowerVerification(
    List<PowerVerificationModel> powerVerifications,
    String powerOfAttorneyId,
  ) {
    if (powerVerifications.isNotEmpty && powerOfAttorneyId.isNotEmpty) {
      for (PowerVerificationModel verification in powerVerifications) {
        if (verification.id == powerOfAttorneyId) {
          return verification;
        }
      }
    }
    return const PowerVerificationModel.empty();
  }

  //? Upload File
  static String getUniqueFileName(String path) {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final fileExtension = extension(path);

    return '$fileName$fileExtension';
  }

  static String getFileType(String path) {
    if (path.isEmpty) return "";
    final fileType = p.extension(path);
    return fileType.split(".")[1];
  }

  static String getUniqueFileNameByUint8List(Uint8List bytes) {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    if (bytes.length >= 2) {
      if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
        return '$fileName.jpg';
      } else if (bytes[0] == 0x89 && bytes[1] == 0x50) {
        return '$fileName.png';
      } else if (bytes[0] == 0x47 && bytes[1] == 0x49) {
        return '$fileName.gif';
      } else if (bytes[0] == 0x42 && bytes[1] == 0x4D) {
        return '$fileName.bmp';
      }

      if (bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF) {
        return 'txt';
      }

      if (bytes[0] == 0x25 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x44 &&
          bytes[3] == 0x46) {
        return 'pdf';
      }

      if (bytes[0] == 0xD0 &&
          bytes[1] == 0xCF &&
          bytes[2] == 0x11 &&
          bytes[3] == 0xE0) {
        return 'doc';
      } else if (bytes[0] == 0x50 &&
          bytes[1] == 0x4B &&
          bytes[2] == 0x03 &&
          bytes[3] == 0x04) {
        return 'docx';
      }

      if (bytes[0] == 0xD0 &&
          bytes[1] == 0xCF &&
          bytes[2] == 0x11 &&
          bytes[3] == 0xE0) {
        return 'xls';
      } else if (bytes[0] == 0x50 &&
          bytes[1] == 0x4B &&
          bytes[2] == 0x03 &&
          bytes[3] == 0x04) {
        return 'xlsx';
      }

      if (bytes[0] == 0x50 &&
          bytes[1] == 0x4B &&
          bytes[2] == 0x03 &&
          bytes[3] == 0x04) {
        return 'zip';
      }

      if (bytes[0] == 0x52 &&
          bytes[1] == 0x61 &&
          bytes[2] == 0x72 &&
          bytes[3] == 0x21) {
        return 'rar';
      }
    }

    return fileName;
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

  static String getProcessDsrProofPath(
    String companyId,
    String dataSubjectRightId,
  ) {
    final company = 'companies/$companyId';
    final dataSubjectRight = 'data_subject_rights/$dataSubjectRightId';
    const folder = 'proof/';

    return [company, dataSubjectRight, folder].join('/');
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
