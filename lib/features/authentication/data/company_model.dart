import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdpa/core/utils/constants.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/domain/entities/company.dart';

class CompanyModel extends Company {
  const CompanyModel({
    required super.id,
    required super.name,
    required super.profileImage,
    required super.status,
    required super.createdBy,
    required super.createdDate,
    required super.updatedBy,
    required super.updatedDate,
  });

  CompanyModel.empty()
      : this(
          id: '',
          name: '',
          profileImage: '',
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: Timestamp.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: Timestamp.fromMillisecondsSinceEpoch(0),
        );

  CompanyModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          name: map['name'] as String,
          profileImage: map['profileImage'] as String,
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: Timestamp.fromDate(
            DateTime.parse(map['createdDate'] as String),
          ),
          updatedBy: map['updatedBy'] as String,
          updatedDate: Timestamp.fromDate(
            DateTime.parse(map['updatedDate'] as String),
          ),
        );

  DataMap toMap() => {
        'id': id,
        'name': name,
        'profileImage': profileImage,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate,
        'updatedBy': updatedBy,
        'updatedDate': updatedDate,
      };

  factory CompanyModel.fromJson(String source) =>
      CompanyModel.fromMap(json.decode(source) as DataMap);

  String toJson() => json.encode(toMap());

  CompanyModel copyWith({
    String? id,
    String? name,
    String? profileImage,
    ActiveStatus? status,
    String? createdBy,
    Timestamp? createdDate,
    String? updatedBy,
    Timestamp? updatedDate,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}
