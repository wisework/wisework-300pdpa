import 'package:dartz/dartz.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/services/apis/data_subject_right_api.dart';
import 'package:pdpa/app/shared/errors/exceptions.dart';
import 'package:pdpa/app/shared/errors/failure.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class DataSubjectRightRepository {
  const DataSubjectRightRepository(this._api);

  final DataSubjectRightApi _api;

  //? Data Subject Right
  ResultFuture<List<DataSubjectRightModel>> getDataSubjectRights(
    String companyId,
  ) async {
    try {
      final result = await _api.getDataSubjectRights(companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<DataSubjectRightModel> getDataSubjectRightById(
    String dataSubjectRightId,
    String companyId,
  ) async {
    try {
      final result = await _api.getDataSubjectRightById(
        dataSubjectRightId,
        companyId,
      );

      if (result != null) return Right(result);

      return const Left(
        ApiFailure(message: 'Data Subject Right not found', statusCode: 404),
      );
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<DataSubjectRightModel> createDataSubjectRight(
    DataSubjectRightModel dataSubjectRight,
    String companyId,
  ) async {
    try {
      final result = await _api.createDataSubjectRight(
        dataSubjectRight,
        companyId,
      );

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid updateDataSubjectRight(
    DataSubjectRightModel dataSubjectRight,
    String companyId,
  ) async {
    try {
      await _api.updateDataSubjectRight(dataSubjectRight, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid deleteDataSubjectRight(
    String dataSubjectRightId,
    String companyId,
  ) async {
    try {
      await _api.deleteDataSubjectRight(dataSubjectRightId, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }
}
