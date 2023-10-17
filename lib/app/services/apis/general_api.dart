import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class GeneralApi {
  const GeneralApi(this._storage);

  final FirebaseStorage _storage;

  Future<String> generateShortUrl(
    String longUrl,
  ) async {
    const String apiEndpoint = 'https://api-ssl.bitly.com/v4/shorten';
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${AppConfig.accessTokenBitly}',
      'Content-Type': 'application/json',
    };
    final Map<String, String> data = {
      'long_url': longUrl,
      'domain': 'bit.ly',
    };

    final response = await http.post(
      Uri.parse(apiEndpoint),
      headers: headers,
      body: json.encode(data),
    );

    DataMap body = json.decode(response.body);
    return body['link'];
  }

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
