import 'package:equatable/equatable.dart';

import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

import 'localized_model.dart';
import 'purpose_model.dart';

class PurposeCategoryModel extends Equatable {
  const PurposeCategoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.purposes,
    required this.priority,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String id;
  final List<LocalizedModel> title;
  final List<LocalizedModel> description;
  final List<PurposeModel> purposes;
  final int priority;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  PurposeCategoryModel.empty()
      : this(
          id: '',
          title: [],
          description: [],
          purposes: [],
          priority: 0,
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  PurposeCategoryModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          title: List<LocalizedModel>.from(
            (map['title'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          description: List<LocalizedModel>.from(
            (map['description'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          purposes: List<PurposeModel>.from(
            (map['purposes'] as List<dynamic>).map<PurposeModel>(
              (item) => PurposeModel.fromMap(item as DataMap),
            ),
          ),
          priority: map['priority'] != null ? map['priority'] as int : 0,
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  factory PurposeCategoryModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return PurposeCategoryModel.fromMap(response);
  }

  DataMap toMap() => {
        'title': title.map((item) => item.toMap()).toList(),
        'description': description.map((item) => item.toMap()).toList(),
        'purposes': purposes.map((purpose) => purpose.id).toList(),
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  PurposeCategoryModel copyWith({
    String? id,
    List<LocalizedModel>? title,
    List<LocalizedModel>? description,
    List<PurposeModel>? purposes,
    int? priority,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return PurposeCategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      purposes: purposes ?? this.purposes,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  PurposeCategoryModel setCreate(String email, DateTime date) => copyWith(
        createdBy: email,
        createdDate: date,
        updatedBy: email,
        updatedDate: date,
      );

  PurposeCategoryModel setUpdate(String email, DateTime date) => copyWith(
        updatedBy: email,
        updatedDate: date,
      );

  @override
  List<Object> get props {
    return [
      id,
      title,
      description,
      purposes,
      priority,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
