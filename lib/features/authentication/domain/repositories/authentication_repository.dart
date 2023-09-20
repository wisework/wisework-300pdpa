import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  ResultFuture<UserEntity> getCurrentUser();

  ResultFuture<UserEntity> signInWithGoogle();

  ResultVoid signOut();

  ResultVoid updateUser({
    required UserEntity user,
  });
}
