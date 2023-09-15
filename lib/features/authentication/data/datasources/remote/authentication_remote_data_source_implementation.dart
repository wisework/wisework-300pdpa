import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdpa/core/errors/exceptions.dart';
import 'package:pdpa/features/authentication/data/datasources/remote/authentication_remote_data_source.dart';
import 'package:pdpa/features/authentication/data/models/user_model.dart';

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
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user != null) {
      final document = await _firestore
          .collection('Users')
          .doc(userCredential.user!.uid)
          .get();
      if (document.exists) {
        return UserModel.fromDocument(document);
      }
    }
    throw const ApiException(message: 'User not found', statusCode: 404);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
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
}
