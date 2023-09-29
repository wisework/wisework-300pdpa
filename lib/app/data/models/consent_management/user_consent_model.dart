// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:pdpa/app/shared/utils/typedef.dart';

class UserConsentModel extends Equatable {
  const UserConsentModel({
    required this.id,
    required this.inputFields,
    required this.purposes,
    required this.isAcceptConsent,
    required this.consentFormId,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.companyId,
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

  final String id;
  final List<String> inputFields;
  final List<String> purposes;
  final bool isAcceptConsent;
  final String consentFormId;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;
  final String companyId;

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

  @override
  List<Object> get props {
    return [
      id,
      inputFields,
      purposes,
      isAcceptConsent,
      consentFormId,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
      companyId,
    ];
  }
}
