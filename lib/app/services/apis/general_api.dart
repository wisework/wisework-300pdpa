import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class GeneralApi {
  const GeneralApi(this._storage);

  final FirebaseStorage _storage;

  Future<String> uploadImage(
    File file,
    String fileName,
    String path,
  ) async {
    final ref = _storage.ref().child(path).child(fileName);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<List<String>> getImages(
    String path,
  ) async {
    final result = await _storage.ref().child(path).listAll();

    List<String> imagePaths = [];
    for (var item in result.items) {
      final path = await item.getDownloadURL();
      if (path.isNotEmpty) {
        imagePaths.add(path);
      }
    }

    return imagePaths;
  }
}
