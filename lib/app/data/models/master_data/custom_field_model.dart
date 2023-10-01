// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/models/localized_text.dart';

import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class CustomFieldModel extends Equatable {
  const CustomFieldModel({
    required this.id,
    required this.title,
    required this.inputType,
    required this.lengthLimit,
    required this.maxLines,
    required this.minLines,
    required this.placeholder,
    required this.uid,
    required this.language,
    required this.companies,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String id;
  final List<LocalizedText> title;
  final String inputType;
  final int lengthLimit;
  final int maxLines;
  final int minLines;
  final List<LocalizedText> placeholder;
  final String uid;
  final String language;
  final List<String> companies;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  CustomFieldModel.empty()
      : this(
          id: '',
          title: [],
          inputType: '',
          lengthLimit: 1,
          maxLines: 1,
          minLines: 1,
          placeholder: [],
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
          title: List<LocalizedText>.from(
            (map['title'] as List<dynamic>).map<LocalizedText>(
              (item) => LocalizedText.fromMap(item as Map<String, dynamic>),
            ),
          ),
          inputType: map['inputType'] as String,
          lengthLimit: map['lengthLimit'] as int,
          maxLines: map['maxLines'] as int,
          minLines: map['minLines'] as int,
          placeholder: List<LocalizedText>.from(
            (map['placeholder'] as List<dynamic>).map<LocalizedText>(
              (item) => LocalizedText.fromMap(item as Map<String, dynamic>),
            ),
          ),
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
        'title': title.map((item) => item.toMap()).toList(),
        'inputType': inputType,
        'lengthLimit': lengthLimit,
        'maxLines': maxLines,
        'minLines': minLines,
        'placeholder': placeholder.map((item) => item.toMap()).toList(),
        'uid': uid,
        'language': language,
        'companies': companies,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  factory CustomFieldModel.fromDocument(FirebaseDocument document) {
    Map<String, dynamic> response = document.data()!;
    response['id'] = document.id;
    return CustomFieldModel.fromMap(response);
  }
  CustomFieldModel copyWith({
    String? id,
    List<LocalizedText>? title,
    String? inputType,
    int? lengthLimit,
    int? maxLines,
    int? minLines,
    List<LocalizedText>? placeholder,
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

  @override
  List<Object> get props {
    return [
      id,
      title,
      inputType,
      lengthLimit,
      maxLines,
      minLines,
      placeholder,
      uid,
      language,
      companies,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
