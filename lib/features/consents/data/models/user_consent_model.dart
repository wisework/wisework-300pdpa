import 'dart:convert';

import 'package:pdpa/core/utils/typedef.dart';

import 'package:pdpa/features/consents/domain/entities/user_consent.dart';

class UserConsentModel extends UserConsent {
  const UserConsentModel({
    required super.id,
    required super.inputFields,
    required super.purposes,
    required super.isAcceptConsent,
    required super.consentFormId,
    required super.createdBy,
    required super.createdDate,
    required super.updatedBy,
    required super.updatedDate,
    required super.companyId,
  });

  UserConsentModel.empty()
      : this(
          id: '',
          inputFields: [],
          purposes: [],
          isAcceptConsent: false,
          consentFormId: '',
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
          companyId: '',
        );

  UserConsentModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          inputFields: List<String>.from(map['inputFields'] as List<dynamic>),
          purposes: List<String>.from(map['purposes'] as List<dynamic>),
          isAcceptConsent: map['isAcceptConsent'] as bool,
          consentFormId: map['consentFormId'] as String,
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
          companyId: map['companyId'] as String,
        );

  DataMap toMap() => {
        'id': id,
        'inputFields': inputFields,
        'purposes': purposes,
        'isAcceptConsent': isAcceptConsent,
        'consentFormId': consentFormId,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
        'companyId': companyId,
      };

  factory UserConsentModel.fromJson(String source) =>
      UserConsentModel.fromMap(json.decode(source) as DataMap);

  String toJson() => json.encode(toMap());

  factory UserConsentModel.fromDocument(FirebaseDocument document) {
    Map<String, dynamic> response = document.data()!;
    response['id'] = document.id;
    return UserConsentModel.fromMap(response);
  }

  UserConsentModel copyWith({
    String? id,
    List<String>? inputFields,
    List<String>? purposes,
    bool? isAcceptConsent,
    String? consentFormId,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
    String? companyId,
  }) {
    return UserConsentModel(
      id: id ?? this.id,
      inputFields: inputFields ?? this.inputFields,
      purposes: purposes ?? this.purposes,
      isAcceptConsent: isAcceptConsent ?? this.isAcceptConsent,
      consentFormId: consentFormId ?? this.consentFormId,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
      companyId: companyId ?? this.companyId,
    );
  }
}
