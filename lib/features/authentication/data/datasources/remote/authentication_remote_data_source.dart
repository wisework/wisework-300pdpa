import 'package:pdpa/features/authentication/data/models/user_model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signInWithGoogle();

  Future<void> signOut();
}
