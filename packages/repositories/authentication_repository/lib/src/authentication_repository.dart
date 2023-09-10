import 'dart:convert';

import 'package:authentication_repository/src/authentication_config.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_api/flutter_firebase_api.dart';
import 'package:pdpa_utils/pdpa_utils.dart';

import 'models/authentication.dart';

class AuthenticationRepository {
  AuthenticationRepository();

  Future<String> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        final user = await FlutterFirebaseApi.getDocument(
          documentPath: 'Users/${userCredential.user!.uid}',
        );

        if (user != null) {
          final authentication = Authentication(
            userId: userCredential.user!.uid,
            firstName: user['firstName'],
            lastName: user['lastName'],
            email: userCredential.user!.email!,
            companyId: user['currentCompany'],
            loginTimestamp: DateTimestamp.now,
            expirationTime: DateTimestamp.now.addDays(30),
          );

          return _generateToken(authentication);
        }
      }

      return '';
    } catch (error) {
      debugPrint('Failed to sign in with email and password: $error');
      return '';
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      debugPrint('Failed to sign out: $error');
    }
  }

  bool verifyToken(String token) => readToken(token) != Authentication.initial;

  //? Private Functions

  String _generateToken(Authentication authentication) {
    try {
      final payloadBase64 = base64Url.encode(
        utf8.encode(authentication.toJson()),
      );

      final hmac = Hmac(sha256, utf8.encode(AuthenticationConfig.secretKey));
      final digest = hmac.convert(utf8.encode(payloadBase64));
      final hashHex = digest.toString();

      return '$payloadBase64.$hashHex';
    } catch (error) {
      debugPrint('Failed to generate token: $error');
      return '';
    }
  }

  Authentication readToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 2) {
        debugPrint('Failed to read token: Invalid token');
        return Authentication.initial;
      }

      final payloadBase64 = parts.first;
      final hashHex = parts.last;

      final payloadBytes = base64Url.decode(payloadBase64);
      final payload = utf8.decode(payloadBytes);

      final hmac = Hmac(sha256, utf8.encode(AuthenticationConfig.secretKey));
      final digest = hmac.convert(utf8.encode(payloadBase64));

      if (digest.toString() != hashHex) {
        debugPrint('Failed to read token: Hash hex do not match');
        return Authentication.initial;
      }

      return Authentication.fromJson(payload);
    } catch (error) {
      debugPrint('Failed to read token: $error');
      return Authentication.initial;
    }
  }
}
