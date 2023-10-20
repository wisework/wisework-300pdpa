import 'package:dartz/dartz.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/services/apis/consent_api.dart';
import 'package:pdpa/app/shared/errors/exceptions.dart';
import 'package:pdpa/app/shared/errors/failure.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class ConsentRepository {
  const ConsentRepository(this._api);

  final ConsentApi _api;

  //? Consent Form
  ResultFuture<List<ConsentFormModel>> getConsentForms(String companyId) async {
    try {
      final result = await _api.getConsentForms(companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<ConsentFormModel> getConsentFormById(
    String consentFormId,
    String companyId,
  ) async {
    try {
      final result = await _api.getConsentFormById(consentFormId, companyId);

      if (result != null) return Right(result);

      return const Left(
        ApiFailure(message: 'Consent form not found', statusCode: 404),
      );
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<ConsentFormModel> createConsentForm(
    ConsentFormModel consentForm,
    String companyId,
  ) async {
    try {
      final result = await _api.createConsentForm(consentForm, companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid updateConsentForm(
    ConsentFormModel consentForm,
    String companyId,
  ) async {
    try {
      await _api.updateConsentForm(consentForm, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  //? Consent Theme
  ResultFuture<List<ConsentThemeModel>> getConsentThemes(
      String companyId) async {
    try {
      final result = await _api.getConsentThemes(companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<ConsentThemeModel> getConsentThemeById(
    String consentThemeId,
    String companyId,
  ) async {
    try {
      final result = await _api.getConsentThemeById(consentThemeId, companyId);

      if (result != null) return Right(result);

      return const Left(
        ApiFailure(message: 'Consent theme not found', statusCode: 404),
      );
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<ConsentThemeModel> createConsentTheme(
    ConsentThemeModel consentTheme,
    String companyId,
  ) async {
    try {
      final result = await _api.createConsentTheme(consentTheme, companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid updateConsentTheme(
    ConsentThemeModel consentTheme,
    String companyId,
  ) async {
    try {
      await _api.updateConsentTheme(consentTheme, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid deleteConsentTheme(
    String consentThemeId,
    String companyId,
  ) async {
    try {
      await _api.deleteConsentTheme(consentThemeId, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  //? User Consent
  ResultFuture<List<UserConsentModel>> getUserConsents(String companyId) async {
    try {
      final result = await _api.getUserConsents(companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<UserConsentModel> getUserConsentById(
    String userConsentId,
    String companyId,
  ) async {
    try {
      final result = await _api.getUserConsentById(userConsentId, companyId);

      if (result != null) return Right(result);

      return const Left(
        ApiFailure(message: 'User consent not found', statusCode: 404),
      );
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<UserConsentModel> createUserConsent(
    UserConsentModel userConsent,
    String companyId,
  ) async {
    try {
      final result = await _api.createUserConsent(userConsent, companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid updateUserConsent(
    UserConsentModel userConsent,
    String companyId,
  ) async {
    try {
      await _api.updateUserConsent(userConsent, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }
}
