import 'dart:convert';

import 'package:pdpa/core/utils/constants.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/consents/domain/entities/custom_field.dart';

class CustomFieldModel extends CustomField {
  const CustomFieldModel({
    required super.id,
    required super.title,
    required super.inputType,
    required super.lengthLimit,
    required super.maxLines,
    required super.minLines,
    required super.placeholder,
    required super.uid,
    required super.language,
    required super.companies,
    required super.status,
    required super.createdBy,
    required super.createdDate,
    required super.updatedBy,
    required super.updatedDate,
  });

  CustomFieldModel.empty()
      : this(
          id: '',
          title: '',
          inputType: '',
          lengthLimit: 1,
          maxLines: 1,
          minLines: 1,
          placeholder: '',
          uid: '',
          language: '',
          companies: [],
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  CustomFieldModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          title: map['title'] as String,
          inputType: map['inputType'] as String,
          lengthLimit: map['lengthLimit'] as int,
          maxLines: map['maxLines'] as int,
          minLines: map['minLines'] as int,
          placeholder: map['placeholder'] as String,
          uid: map['uid'] as String,
          language: map['language'] as String,
          companies: List<dynamic>.from((map['companies'] as List<dynamic>))
              .map((item) => item.toString())
              .toList(),
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  DataMap toMap() => {
        'id': id,
        'title': title,
        'inputType': inputType,
        'lengthLimit': lengthLimit,
        'maxLines': maxLines,
        'minLines': minLines,
        'placeholder': placeholder,
        'uid': uid,
        'language': language,
        'companies': companies,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  factory CustomFieldModel.fromJson(String source) =>
      CustomFieldModel.fromMap(json.decode(source) as DataMap);

  String toJson() => json.encode(toMap());

  CustomFieldModel copyWith({
    String? id,
    String? title,
    String? inputType,
    int? lengthLimit,
    int? maxLines,
    int? minLines,
    String? placeholder,
    String? uid,
    String? language,
    List<String>? companies,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return CustomFieldModel(
      id: id ?? this.id,
      title: title ?? this.title,
      inputType: inputType ?? this.inputType,
      lengthLimit: lengthLimit ?? this.lengthLimit,
      maxLines: maxLines ?? this.maxLines,
      minLines: minLines ?? this.minLines,
      placeholder: placeholder ?? this.placeholder,
      uid: uid ?? this.uid,
      language: language ?? this.language,
      companies: companies ?? this.companies,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}
