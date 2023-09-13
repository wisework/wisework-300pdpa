import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/domain/entities/user.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  ResultFuture<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  ResultFuture<User> signInWithGoogle();

  ResultVoid signOut();
}
