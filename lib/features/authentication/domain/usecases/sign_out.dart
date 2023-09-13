import 'package:pdpa/core/usecases/usecase_without_params.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/domain/repositories/authentication_repository.dart';

class SignOut extends UsecaseWithoutParams<void> {
  SignOut(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<void> call() => _repository.signOut();
}
