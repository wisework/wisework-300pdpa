import 'dart:convert';

import 'package:pdpa/core/utils/constants.dart';
import 'package:pdpa/core/utils/typedef.dart';

import 'package:pdpa/features/consents/domain/entities/purpose_category.dart';

class PurposeCategoryModel extends PurposeCategory {
  const PurposeCategoryModel({
    required super.id,
    required super.purposes,
    required super.title,
    required super.description,
    required super.priority,
    required super.language,
    required super.uid,
    required super.status,
    required super.createdBy,
    required super.createdDate,
    required super.updatedBy,
    required super.updatedDate,
    required super.companyId,
  });

  PurposeCategoryModel.empty()
      : this(
          id: '',
          purposes: [],
          title: '',
          description: '',
          priority: 0,
          language: '',
          uid: '',
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
          companyId: '',
        );

  PurposeCategoryModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          purposes: List<dynamic>.from((map['purposes'] as List<dynamic>))
              .map((item) => item.toString())
              .toList(),
          title: map['title'] as String,
          description: map['description'] as String,
          priority: map['priority'] as int,
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
        'purposes': purposes,
        'title': title,
        'description': description,
        'priority': priority,
        'language': language,
        'uid': uid,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
        'companyId': companyId,
      };

  factory PurposeCategoryModel.fromJson(String source) =>
      PurposeCategoryModel.fromMap(json.decode(source) as DataMap);

  String toJson() => json.encode(toMap());

  factory PurposeCategoryModel.fromDocument(FirebaseDocument document) {
    Map<String, dynamic> response = document.data()!;
    response['id'] = document.id;
    return PurposeCategoryModel.fromMap(response);
  }

  PurposeCategoryModel copyWith({
    String? id,
    List<String>? purposes,
    String? title,
    String? description,
    int? priority,
    String? language,
    String? uid,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
    String? companyId,
  }) {
    return PurposeCategoryModel(
      id: id ?? this.id,
      purposes: purposes ?? this.purposes,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      language: language ?? this.language,
      uid: uid ?? this.uid,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
      companyId: companyId ?? this.companyId,
    );
  }
}
