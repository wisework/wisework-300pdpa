import 'package:equatable/equatable.dart';
import 'package:pdpa/core/usecases/usecase_with_params.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/domain/entities/user.dart';
import 'package:pdpa/features/authentication/domain/repositories/authentication_repository.dart';

class SignInWithEmailAndPassword
    extends UsecaseWithParams<User, SignInWithEmailAndPasswordParams> {
  SignInWithEmailAndPassword(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<User> call(SignInWithEmailAndPasswordParams params) =>
      _repository.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );
}

class SignInWithEmailAndPasswordParams extends Equatable {
  const SignInWithEmailAndPasswordParams({
    required this.email,
    required this.password,
  });

  const SignInWithEmailAndPasswordParams.empty()
      : this(email: '', password: '');

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
