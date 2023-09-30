import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';

class UserApi {
  const UserApi(this._firestore);

  final FirebaseFirestore _firestore;

  Future<UserModel?> getUserById(String userId) async {
    final document = await _firestore.collection('Users').doc(userId).get();

    if (!document.exists) return null;
    return UserModel.fromDocument(document);
  }
}
