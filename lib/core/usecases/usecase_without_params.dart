import 'package:pdpa/core/utils/typedef.dart';

abstract class UsecaseWithoutParams<Type> {
  ResultFuture<Type> call();
}
