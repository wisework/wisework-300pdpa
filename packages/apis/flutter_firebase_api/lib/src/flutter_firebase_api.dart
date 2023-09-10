import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FlutterFirebaseApi {
  static Future<List<Map<String, dynamic>>> getCollection({
    required String collectionPath,
  }) async {
    List<Map<String, dynamic>> documents = [];

    try {
      final collectionRef =
          await FirebaseFirestore.instance.collection(collectionPath).get();
      for (var doc in collectionRef.docs) {
        Map<String, dynamic> response = doc.data();
        response['id'] = doc.id;
        documents.add(response);
      }
    } catch (error) {
      debugPrint('Failed to get [$collectionPath]: $error');
    }

    return documents;
  }

  static Future<Map<String, dynamic>?> getDocument({
    required String documentPath,
  }) async {
    try {
      final documentRef =
          await FirebaseFirestore.instance.doc(documentPath).get();
      if (documentRef.exists) {
        Map<String, dynamic> response = documentRef.data()!;
        response['id'] = documentRef.id;
        return response;
      }
    } catch (error) {
      debugPrint('Failed to get [$documentPath]: $error');
    }

    return null;
  }

  static Future<void> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
    SetOptions? options,
  }) async {
    try {
      final documentRef =
          FirebaseFirestore.instance.collection(collectionPath).doc();
      await documentRef.set(data, options);
    } catch (error) {
      debugPrint('Failed to add [$collectionPath]: $error');
    }
  }

  static Future<void> updateDocument({
    required String documentPath,
    required Map<String, dynamic> data,
    SetOptions? options,
  }) async {
    try {
      final documentRef = FirebaseFirestore.instance.doc(documentPath);
      await documentRef.set(data, options);
    } catch (error) {
      debugPrint('Failed to update [$documentPath]: $error');
    }
  }

  static Future<void> deleteDocument({
    required String documentPath,
  }) async {
    try {
      final documentRef = FirebaseFirestore.instance.doc(documentPath);
      await documentRef.delete();
    } catch (error) {
      debugPrint('Failed to delete [$documentPath]: $error');
    }
  }
}
