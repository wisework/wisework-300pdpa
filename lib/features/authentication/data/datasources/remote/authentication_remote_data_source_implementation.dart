import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdpa/core/errors/exceptions.dart';
import 'package:pdpa/features/authentication/data/datasources/remote/authentication_remote_data_source.dart';
import 'package:pdpa/features/authentication/data/models/user_model.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';
import 'package:uuid/uuid.dart';

class AuthenticationRemoteDataSourceImplementation
    extends AuthenticationRemoteDataSource {
  AuthenticationRemoteDataSourceImplementation(
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
      final document = await _firestore.collection('Users').doc(user.uid).get();
      if (document.exists) {
        return UserModel.fromDocument(document);
      }
      throw const ApiException(message: 'User not found', statusCode: 404);
    }
    return UserModel.empty();
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
        final document = await _firestore
            .collection('Users')
            .doc(userCredential.user!.uid)
            .get();
        if (document.exists) {
          return UserModel.fromDocument(document);
        } else {
          final name = userCredential.user!.displayName?.split(' ') ??
              [userCredential.user!.displayName!];

          String firstName = '';
          String lastName = '';

          firstName = name.first;
          if (name.length > 1) lastName = name.last;

          final newUser = UserModel.empty().copyWith(
            id: userCredential.user!.uid,
            uid: const Uuid().v6(),
            firstName: firstName,
            lastName: lastName,
            email: userCredential.user!.email,
            role: 'User',
            defaultLanguage: 'en-US',
            isEmailVerified: userCredential.user!.emailVerified,
            createdBy: 'Sign in with Google',
            createdDate: DateTime.now(),
            updatedBy: 'Sign in with Google',
            updatedDate: DateTime.now(),
          );

          await _firestore
              .collection('Users')
              .doc(newUser.id)
              .set(newUser.toMap());

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
    final document = await _firestore.collection('Users').doc(user.id).get();
    if (document.exists) {
      // Update user logic
    }
    throw const ApiException(message: 'User not found', statusCode: 404);
  }
}
