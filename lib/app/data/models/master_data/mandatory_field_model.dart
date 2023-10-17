import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

import 'localized_model.dart';

class MandatoryFieldModel extends Equatable {
  const MandatoryFieldModel({
    required this.id,
    required this.title,
    required this.hintText,
    required this.inputType,
    this.lengthLimit,
    required this.minLines,
    required this.maxLines,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String id;
  final List<LocalizedModel> title;
  final List<LocalizedModel> hintText;
  final TextInputType inputType;
  final int? lengthLimit;
  final int minLines;
  final int maxLines;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  MandatoryFieldModel.empty()
      : this(
          id: '',
          title: [],
          hintText: [],
          inputType: TextInputType.text,
          lengthLimit: null,
          minLines: 1,
          maxLines: 1,
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  MandatoryFieldModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          title: List<LocalizedModel>.from(
            (map['title'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          hintText: List<LocalizedModel>.from(
            (map['hintText'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          inputType: TextInputType.values[map['inputType'] as int],
          lengthLimit: (map['lengthLimit'] as String).isNotEmpty
              ? int.parse(map['lengthLimit'] as String)
              : null,
          minLines: map['minLines'] as int,
          maxLines: map['maxLines'] as int,
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  DataMap toMap() => {
        'title': title.map((item) => item.toMap()).toList(),
        'hintText': hintText.map((item) => item.toMap()).toList(),
        'inputType': inputType.index,
        'lengthLimit': lengthLimit != null ? lengthLimit.toString() : '',
        'minLines': minLines,
        'maxLines': maxLines,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  factory MandatoryFieldModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return MandatoryFieldModel.fromMap(response);
  }

  MandatoryFieldModel copyWith({
    String? id,
    List<LocalizedModel>? title,
    List<LocalizedModel>? hintText,
    TextInputType? inputType,
    int? lengthLimit,
    int? minLines,
    int? maxLines,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return MandatoryFieldModel(
      id: id ?? this.id,
      title: title ?? this.title,
      hintText: hintText ?? this.hintText,
      inputType: inputType ?? this.inputType,
      lengthLimit: lengthLimit ?? this.lengthLimit,
      minLines: minLines ?? this.minLines,
      maxLines: maxLines ?? this.maxLines,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  MandatoryFieldModel setCreate(String email, DateTime date) => copyWith(
        createdBy: email,
        createdDate: date,
        updatedBy: email,
        updatedDate: date,
      );

  MandatoryFieldModel setUpdate(String email, DateTime date) => copyWith(
        updatedBy: email,
        updatedDate: date,
      );

  @override
  List<Object?> get props {
    return [
      id,
      title,
      hintText,
      inputType,
      lengthLimit,
      minLines,
      maxLines,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
