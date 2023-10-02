import 'package:equatable/equatable.dart';

import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

import 'localized_model.dart';

class PurposeModel extends Equatable {
  const PurposeModel({
    required this.id,
    required this.description,
    required this.warningDescription,
    required this.retentionPeriod,
    required this.periodUnit,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String id;
  final List<LocalizedModel> description;
  final List<LocalizedModel> warningDescription;
  final int retentionPeriod;
  final String periodUnit;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  PurposeModel.empty()
      : this(
          id: '',
          description: [],
          warningDescription: [],
          retentionPeriod: 0,
          periodUnit: '',
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  PurposeModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          description: List<LocalizedModel>.from(
            (map['description'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          warningDescription: List<LocalizedModel>.from(
            (map['warningDescription'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          retentionPeriod: map['retentionPeriod'] as int,
          periodUnit: map['periodUnit'] as String,
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  DataMap toMap() => {
        'id': id,
        'description': description.map((item) => item.toMap()).toList(),
        'warningDescription':
            warningDescription.map((item) => item.toMap()).toList(),
        'retentionPeriod': retentionPeriod,
        'periodUnit': periodUnit,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  factory PurposeModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return PurposeModel.fromMap(response);
  }

  PurposeModel copyWith({
    String? id,
    List<LocalizedModel>? description,
    List<LocalizedModel>? warningDescription,
    int? retentionPeriod,
    String? periodUnit,
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
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  PurposeModel toCreated(String email, DateTime date) => copyWith(
        createdBy: email,
        createdDate: date,
        updatedBy: email,
        updatedDate: date,
      );

  PurposeModel toUpdated(String email, DateTime date) => copyWith(
        updatedBy: email,
        updatedDate: date,
      );

  @override
  List<Object> get props {
    return [
      id,
      description,
      warningDescription,
      retentionPeriod,
      periodUnit,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
