import 'package:flutter_firebase_api/flutter_firebase_api.dart';

import 'models/models.dart';

class ConsentManagementRepository {
  ConsentManagementRepository();

  //? ---- Custom Field ----

  Future<List<CustomField>> getCustomFields() async {
    final documents = await FlutterFirebaseApi.getCollection(
      collectionPath: 'Companies/C7q7rpbkjgLMeROuJQhi/CustomFields',
    );

    return documents.map((map) => CustomField.fromMap(map)).toList();
  }

  Future<void> addCustomField(CustomField customField) async {
    await FlutterFirebaseApi.addDocument(
      collectionPath: 'Companies/C7q7rpbkjgLMeROuJQhi/CustomFields',
      data: customField.toMap(),
    );
  }

  //? ---- Purpose ----

  Future<List<Purpose>> getPurposes() async {
    final documents = await FlutterFirebaseApi.getCollection(
      collectionPath: 'Companies/C7q7rpbkjgLMeROuJQhi/Purposes',
    );

    return documents.map((map) => Purpose.fromMap(map)).toList();
  }

  Future<void> addPurpose(Purpose purpose) async {
    await FlutterFirebaseApi.addDocument(
      collectionPath: 'Companies/C7q7rpbkjgLMeROuJQhi/Purposes',
      data: purpose.toMap(),
    );
  }
}
