import 'dart:io';
import 'dart:typed_data';

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

  ResultFuture<String> uploadImage(
    File? file,
    Uint8List? data,
    String fileName,
    String path,
  ) async {
    try {
      final result = await _api.uploadImage(file, data, fileName, path);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture uploadFile(
    Uint8List file,
    String fileName,
    String filePath,
  ) async {
    try {
      final result = await _api.uploadFile(file, fileName, filePath);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid downloadFirebaseStorageFile(String path) async {
    try {
      await _api.downloadFirebaseStorageFile(path);

      return const Right(null);
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
