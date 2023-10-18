import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:pdpa/app/services/apis/general_api.dart';
import 'package:pdpa/app/shared/errors/exceptions.dart';
import 'package:pdpa/app/shared/errors/failure.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class GeneralRepository {
  const GeneralRepository(this._api);

  final GeneralApi _api;

  ResultFuture<String> generateShortUrl(
    String longUrl,
  ) async {
    try {
      final result = await _api.generateShortUrl(longUrl);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<String> uploadConsentImage(
    File file,
    String fileName,
    String path,
  ) async {
    try {
      final result = await _api.uploadImage(file, fileName, path);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<List<String>> getImages(
    String path,
  ) async {
    try {
      final result = await _api.getImages(path);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }
}
