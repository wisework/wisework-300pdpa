import 'package:pdpa/core/usecases/usecase_without_params.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';
import 'package:pdpa/features/authentication/domain/repositories/authentication_repository.dart';

class GetCurrentUser extends UsecaseWithoutParams<UserEntity> {
  GetCurrentUser(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<UserEntity> call() => _repository.getCurrentUser();
}
