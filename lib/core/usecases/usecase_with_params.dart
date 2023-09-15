import 'package:pdpa/core/utils/typedef.dart';

abstract class UsecaseWithParams<ReturnType, Params> {
  ResultFuture<ReturnType> call(Params params);
}
