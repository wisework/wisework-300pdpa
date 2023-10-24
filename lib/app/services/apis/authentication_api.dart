import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/shared/errors/exceptions.dart';

class AuthenticationApi {
  const AuthenticationApi(
    this._firestore,
    this._auth,
    this._googleSignIn,
  );

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  //? Authentication
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
            roles: [],
            defaultLanguage: 'th-US',
            isEmailVerified: userCredential.user!.emailVerified,
            createdBy: '',
            createdDate: DateTime.now(),
            updatedBy: '',
            updatedDate: DateTime.now(),
          );

          await userRef.set(newUser.toMap());

          return newUser;
        }
      }
    }
    throw const ApiException(message: 'User not found', statusCode: 404);
  }

  Future<void> signOut() async {
    bool isSigned = await _googleSignIn.isSignedIn();
    if (isSigned) {
      await _googleSignIn.disconnect();
    }
    _auth.signOut();
  }

  //? User
  Future<UserModel> getCurrentUser() async {
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
    return UserModel.empty();
  }

  Future<UserModel> updateCurrentUser(UserModel user) async {
    final updated = user.copyWith(
      updatedBy: user.email,
      updatedDate: DateTime.now(),
    );
    await _firestore.collection('Users').doc(updated.id).set(updated.toMap());

    return updated;
  }

  //? Company
  Future<List<CompanyModel>> getUserCompanies(List<String> companyIds) async {
    List<CompanyModel> companies = [];

    for (String id in companyIds) {
      final document = await _firestore.collection('Companies').doc(id).get();
      if (document.exists) {
        companies.add(CompanyModel.fromDocument(document));
      }
    }

    return companies;
  }

  Future<CompanyModel> getCompanyById(String companyId) async {
    final document =
        await _firestore.collection('Companies').doc(companyId).get();

    if (document.exists) {
      return CompanyModel.fromDocument(document);
    }

    throw const ApiException(message: 'Companies not found', statusCode: 404);
  }

  Future<CompanyModel> createCompany(
    CompanyModel company,
  ) async {
    final ref = _firestore.collection('Companies').doc();
    final created = company.copyWith(id: ref.id);

    await ref.set(created.toMap());

    return created;
  }
}
