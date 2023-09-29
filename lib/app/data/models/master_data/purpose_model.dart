// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class PurposeModel extends Equatable {
  const PurposeModel({
    required this.id,
    required this.description,
    required this.warningDescription,
    required this.retentionPeriod,
    required this.periodUnit,
    required this.uid,
    required this.language,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.companyId,
  });

  PurposeModel.empty()
      : this(
          id: '',
          description: '',
          warningDescription: '',
          retentionPeriod: 0,
          periodUnit: '',
          uid: '',
          language: '',
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
          companyId: '',
        );

  final String id;
  final String description;
  final String warningDescription;
  final int retentionPeriod;
  final String periodUnit;
  final String uid;
  final String language;
  final String companyId;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  PurposeModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          description: map['description'] as String,
          warningDescription: map['warningDescription'] as String,
          retentionPeriod: map['retentionPeriod'] as int,
          periodUnit: map['periodUnit'] as String,
          uid: map['uid'] as String,
          language: map['language'] as String,
          companyId: map['companyId'] as String,
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  DataMap toMap() => {
        'id': id,
        'description': description,
        'warningDescription': warningDescription,
        'retentionPeriod': retentionPeriod,
        'periodUnit': periodUnit,
        'uid': uid,
        'language': language,
        'companyId': companyId,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  factory PurposeModel.fromJson(String source) =>
      PurposeModel.fromMap(json.decode(source) as DataMap);

  String toJson() => json.encode(toMap());

  factory PurposeModel.fromDocument(FirebaseDocument document) {
    Map<String, dynamic> response = document.data()!;
    response['id'] = document.id;
    return PurposeModel.fromMap(response);
  }

  PurposeModel copyWith({
    String? id,
    String? description,
    String? warningDescription,
    int? retentionPeriod,
    String? periodUnit,
    String? uid,
    String? language,
    String? companyId,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return PurposeModel(
      id: id ?? this.id,
      description: description ?? this.description,
      warningDescription: warningDescription ?? this.warningDescription,
      retentionPeriod: retentionPeriod ?? this.retentionPeriod,
      periodUnit: periodUnit ?? this.periodUnit,
      uid: uid ?? this.uid,
      language: language ?? this.language,
      companyId: companyId ?? this.companyId,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      description,
      warningDescription,
      retentionPeriod,
      periodUnit,
      uid,
      language,
      companyId,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
