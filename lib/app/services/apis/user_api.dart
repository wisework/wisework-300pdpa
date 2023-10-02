import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';

class UserApi {
  const UserApi(this._firestore);

  final FirebaseFirestore _firestore;

  Future<UserModel?> getUserById(String userId) async {
    final result = await _firestore.collection('Users').doc(userId).get();

    if (!result.exists) return null;
    return UserModel.fromDocument(result);
  }
}
