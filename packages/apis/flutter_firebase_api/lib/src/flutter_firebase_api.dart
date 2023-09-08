import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FlutterFirebaseApi {
  static Future<List<Map<String, dynamic>>> getCollection(
    String collectionPath,
  ) async {
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
      debugPrint('Error get [$collectionPath]: $error');
    }

    return documents;
  }

  static Future<Map<String, dynamic>?> getDocument(
    String documentPath,
  ) async {
    try {
      final documentRef =
          await FirebaseFirestore.instance.doc(documentPath).get();
      if (documentRef.exists) {
        Map<String, dynamic> response = documentRef.data()!;
        response['id'] = documentRef.id;
        return response;
      }
    } catch (error) {
      debugPrint('Error get [$documentPath]: $error');
    }

    return null;
  }

  static Future<void> createDocument(
    String documentPath,
    Map<String, dynamic> data,
    SetOptions? options,
  ) async {
    try {
      final documentRef = FirebaseFirestore.instance.doc(documentPath);
      await documentRef.set(data, options);
    } catch (error) {
      debugPrint('Error create [$documentPath]: $error');
    }
  }

  static Future<void> updateDocument(
    String documentPath,
    Map<String, dynamic> data,
    SetOptions? options,
  ) async {
    try {
      final documentRef = FirebaseFirestore.instance.doc(documentPath);
      await documentRef.set(data, options);
    } catch (error) {
      debugPrint('Error update [$documentPath]: $error');
    }
  }

  static Future<void> deleteDocument(
    String documentPath,
  ) async {
    try {
      final documentRef = FirebaseFirestore.instance.doc(documentPath);
      await documentRef.delete();
    } catch (error) {
      debugPrint('Error delete [$documentPath]: $error');
    }
  }
}
