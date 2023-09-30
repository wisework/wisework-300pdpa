import 'package:dartz/dartz.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/services/apis/master_data_api.dart';
import 'package:pdpa/app/shared/errors/exceptions.dart';
import 'package:pdpa/app/shared/errors/failure.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class MasterDataRepository {
  const MasterDataRepository(this._api);

  final MasterDataApi _api;

  ResultFuture<List<PurposeModel>> getPurposes(String companyId) async {
    try {
      final purposes = await _api.getPurposes(companyId);

      return Right(purposes);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }
}
