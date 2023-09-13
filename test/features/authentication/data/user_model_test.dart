import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/data/user_model.dart';
import 'package:pdpa/features/authentication/domain/entities/user.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
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

  // group('Test toMap:', () {
  //   test('Should return a [Map] with the right data', () {
  //     //? Act
  //     final result = model.toMap();

  //     //? Assert
  //     expect(result, equals(map));
  //   });
  // });

  group('Test fromJson:', () {
    test('Should return a [UserModel] with the right data', () {
      //? Act
      final result = UserModel.fromJson(json);

      //? Assert
      expect(result, equals(model));
    });
  });

  // group('Test toJson:', () {
  //   test('Should return a [JSON] with the right data', () {
  //     //? Act
  //     final result = model.toJson();

  //     //? Assert
  //     expect(result, equals(json));
  //   });
  // });
}
