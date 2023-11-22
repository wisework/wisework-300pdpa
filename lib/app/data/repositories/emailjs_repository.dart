import 'package:dartz/dartz.dart';
import 'package:pdpa/app/data/models/email_js/process_request_params.dart';
import 'package:pdpa/app/data/models/email_js/signed_up_template_params.dart';
import 'package:pdpa/app/services/apis/emailjs_api.dart';
import 'package:pdpa/app/shared/errors/exceptions.dart';
import 'package:pdpa/app/shared/errors/failure.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class EmailJsRepository {
  const EmailJsRepository(this._api);

  final EmailJsApi _api;

  ResultFuture<String> sendSignedUpEmail(
    SignedUpTemplateParams params,
  ) async {
    try {
      final result = await _api.sendSignedUpEmail(params);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<String> sendProcessRequestEmail(
    ProcessRequestTemplateParams params,
  ) async {
    try {
      final result = await _api.sendProcessRequestEmail(params);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }
}
