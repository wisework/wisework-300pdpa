import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';

abstract class AuthenticationRemoteDataSource {
  Future<UserEntity> getCurrentUser();

  Future<UserEntity> signInWithGoogle();

  Future<void> signOut();

  Future<void> updateUser({required UserEntity user});
}
