// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

import 'localized_model.dart';

class CustomFieldModel extends Equatable {
  const CustomFieldModel({
    required this.id,
    required this.title,
    required this.inputType,
    required this.lengthLimit,
    required this.maxLines,
    required this.minLines,
    required this.hintText,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String id;
  final List<LocalizedModel> title;
  final String inputType;
  final String lengthLimit;
  final int maxLines;
  final int minLines;
  final List<LocalizedModel> hintText;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  CustomFieldModel.empty()
      : this(
          id: '',
          title: [],
          inputType: 'text',
          lengthLimit: '',
          maxLines: 1,
          minLines: 1,
          hintText: [],
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  CustomFieldModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          title: List<LocalizedModel>.from(
            (map['title'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as Map<String, dynamic>),
            ),
          ),
          inputType: map['inputType'] as String,
          lengthLimit: map['lengthLimit'] as String,
          maxLines: map['maxLines'] as int,
          minLines: map['minLines'] as int,
          hintText: List<LocalizedModel>.from(
            (map['hintText'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as Map<String, dynamic>),
            ),
          ),
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
        'hintText': hintText.map((item) => item.toMap()).toList(),
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
    List<LocalizedModel>? title,
    String? inputType,
    String? lengthLimit,
    int? maxLines,
    int? minLines,
    List<LocalizedModel>? hintText,
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
      hintText: hintText ?? this.hintText,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  CustomFieldModel toCreated(String email, DateTime date) => copyWith(
        createdBy: email,
        createdDate: date,
        updatedBy: email,
        updatedDate: date,
      );

  CustomFieldModel toUpdated(String email, DateTime date) => copyWith(
        updatedBy: email,
        updatedDate: date,
      );

  @override
  List<Object> get props {
    return [
      id,
      title,
      inputType,
      lengthLimit,
      maxLines,
      minLines,
      hintText,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
