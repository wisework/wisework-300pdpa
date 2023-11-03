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
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
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
        }
      }
      throw const ApiException(message: 'User not found', statusCode: 404);
    } catch (error) {
      throw const ApiException(message: 'User not found', statusCode: 404);
    }
  }

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
          return await _createUserByCredential(userCredential);
        }
      }
    }
    throw const ApiException(message: 'User not found', statusCode: 404);
  }

  Future<UserModel> signUpWithEmailAndPassword(
    String email,
    String password, {
    UserModel? user,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
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
        if (user != null) {
          final ref = _firestore.collection('Users').doc();
          final created = user.copyWith(
            id: ref.id,
            uid: userCredential.user!.uid,
          );

          await ref.set(created.toMap());

          return created;
        }
        return await _createUserByCredential(userCredential);
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

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
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

  Future<void> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final user = _auth.currentUser;
    if (user != null) {
      final credential = EmailAuthProvider.credential(
        email: user.email ?? '',
        password: currentPassword,
      );

      try {
        await user.reauthenticateWithCredential(credential);
      } catch (error) {
        throw const ApiException(
          message: 'Password is wrong',
          statusCode: 401,
        );
      }

      await user.updatePassword(newPassword);
    }
  }

  Future<void> verifyEmail() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
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

  //? Private Functions
  Future<UserModel> _createUserByCredential(
    UserCredential userCredential,
  ) async {
    final userRef = _firestore.collection('Users').doc();
    final name = userCredential.user!.displayName?.split(' ') ?? ['', ''];

    final firstName = name.first;
    final lastName = name.last;

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
