import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdpa/core/errors/exceptions.dart';
import 'package:pdpa/core/utils/constants.dart';
import 'package:pdpa/features/authentication/data/models/user_model.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';

import 'authentication_remote_data_source.dart';

class AuthenticationRemoteDataSourceImpl
    extends AuthenticationRemoteDataSource {
  AuthenticationRemoteDataSourceImpl(
    this._firestore,
    this._auth,
    this._googleSignIn,
  );

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<UserEntity> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      final queryResult = await _firestore
          .collection('Users')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (queryResult.docs.isNotEmpty) {
        final version = queryResult.docs
            .map((document) => UserModel.fromDocument(document))
            .toList();
        return version.first;
      }
      throw const ApiException(message: 'User not found', statusCode: 404);
    }
    return UserEntity.empty();
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    final result = await _googleSignIn.signIn();
    if (result != null) {
      final googleAuth = await result.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        final queryResult = await _firestore
            .collection('Users')
            .where('uid', isEqualTo: userCredential.user!.uid)
            .get();

        if (queryResult.docs.isNotEmpty) {
          final version = queryResult.docs
              .map((document) => UserModel.fromDocument(document))
              .toList();
          return version.first;
        } else {
          final userRef = _firestore.collection('Users').doc();
          final name = userCredential.user!.displayName?.split(' ') ??
              [userCredential.user!.displayName!];

          String firstName = '';
          String lastName = '';

          firstName = name.first;
          if (name.length > 1) lastName = name.last;

          final newUser = UserModel.empty().copyWith(
            id: userRef.id,
            uid: userCredential.user!.uid,
            firstName: firstName,
            lastName: lastName,
            email: userCredential.user!.email,
            role: UserRoles.viewer,
            defaultLanguage: 'en-US',
            isEmailVerified: userCredential.user!.emailVerified,
            createdBy: 'Google Sign In',
            createdDate: DateTime.now(),
            updatedBy: 'Google Sign In',
            updatedDate: DateTime.now(),
          );

          await userRef.set(newUser.toMap());

          return newUser;
        }
      }
    }
    throw const ApiException(message: 'User not found', statusCode: 404);
  }

  @override
  Future<void> signOut() async {
    bool isSigned = await _googleSignIn.isSignedIn();
    if (isSigned) {
      await _googleSignIn.disconnect();
    }
    _auth.signOut();
  }

  @override
  Future<void> updateUser({required UserEntity user}) async {
    final updated = (user as UserModel).copyWith(
      updatedBy: user.uid,
      updatedDate: DateTime.now(),
    );

    await _firestore.collection('Users').doc(user.id).set(updated.toMap());
  }
}
