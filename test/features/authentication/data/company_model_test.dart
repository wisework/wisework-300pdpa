import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/data/company_model.dart';
import 'package:pdpa/features/authentication/domain/entities/company.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final model = CompanyModel.empty();

  test('Should be a subclass of [Company] entity', () {
    //? Assert
    expect(model, isA<Company>());
  });

  final json = fixture('company.json');
  final map = jsonDecode(json) as DataMap;

  group('Test fromMap:', () {
    test('Should return a [CompanyModel] with the right data', () {
      //? Act
      final result = CompanyModel.fromMap(map);

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
    test('Should return a [CompanyModel] with the right data', () {
      //? Act
      final result = CompanyModel.fromJson(json);

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
}
