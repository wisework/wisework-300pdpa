import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';

class UserApi {
  const UserApi(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<UserModel>> getUsers() async {
    final result = await _firestore.collection('Users').get();

    List<UserModel> users = [];
    for (var document in result.docs) {
      users.add(UserModel.fromDocument(document));
    }

    return users;
  }

  Future<UserModel?> getUserById(String userId) async {
    final result = await _firestore.collection('Users').doc(userId).get();

    if (!result.exists) return null;
    return UserModel.fromDocument(result);
  }

  Future<UserModel> createUser(UserModel user) async {
    final ref = _firestore.collection('Users').doc();
    final created = user.copyWith(id: ref.id);

    await ref.set(created.toMap());

    return created;
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('Users').doc(user.id).set(user.toMap());
  }

  Future<void> deleteUser(String userId) async {
    if (userId.isNotEmpty) {
      await _firestore.collection('Users').doc(userId).delete();
    }
  }
}
