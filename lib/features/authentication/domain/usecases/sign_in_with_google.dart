import 'package:pdpa/core/usecases/usecase_without_params.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/domain/entities/user.dart';
import 'package:pdpa/features/authentication/domain/repositories/authentication_repository.dart';

class SignInWithGoogle extends UsecaseWithoutParams<User> {
  SignInWithGoogle(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<User> call() => _repository.signInWithGoogle();
}
