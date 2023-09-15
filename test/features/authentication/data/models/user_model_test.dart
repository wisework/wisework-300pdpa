import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/data/models/user_model.dart';
import 'package:pdpa/features/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

// ignore: subtype_of_sealed_class
class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<DataMap> {
  @override
  bool get exists => true;

  @override
  String get id => (jsonDecode(fixture('user.json')) as DataMap)['id'];

  @override
  DataMap data() {
    DataMap map = jsonDecode(fixture('user.json'));
    map.remove('id');
    return map;
  }
}

void main() {
  late QueryDocumentSnapshot<DataMap> queryDocumentSnapshot;

  setUp(() {
    queryDocumentSnapshot = MockQueryDocumentSnapshot();
  });

  final model = UserModel.empty();

  test('Should be a subclass of [User] entity', () {
    //? Assert
    expect(model, isA<User>());
  });

  final json = fixture('user.json');
  final map = jsonDecode(json) as DataMap;

  group('Test fromMap:', () {
    test('Should return a [UserModel] with the right data', () {
      //? Act
      final result = UserModel.fromMap(map);

      //? Assert
      expect(result, equals(model));
    });
  });

  group('Test toMap:', () {
    test('Should return a [Map] with the right data', () {
      //? Act
      final result = model.toMap();

      //? Assert
      expect(result, equals(map));
    });
  });

  group('Test fromJson:', () {
    test('Should return a [UserModel] with the right data', () {
      //? Act
      final result = UserModel.fromJson(json);

      //? Assert
      expect(result, equals(model));
    });
  });

  group('Test toJson:', () {
    test('Should return a [JSON] with the right data', () {
      //? Act
      final result = model.toJson();

      //? Assert
      expect(result, equals(json));
    });
  });

  group('Test fromDocument:', () {
    test('Should return a [UserModel] with the right data', () {
      //? Act
      final result = UserModel.fromDocument(queryDocumentSnapshot);

      //? Assert
      expect(result, equals(model));
    });
  });

  group('Test copyWith:', () {
    test('Should return a [UserModel] with different data', () {
      //? Act
      final result = model.copyWith(firstName: 'Meow');

      //? Assert
      expect(result.firstName, equals('Meow'));
    });
  });
}
