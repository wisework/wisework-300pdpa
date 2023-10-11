import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class RejectTypeModel extends Equatable {
  const RejectTypeModel({
    required this.rejectTypeId,
    required this.rejectCode,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String rejectTypeId;
  final String rejectCode;
  final List<LocalizedModel> description;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

 RejectTypeModel.empty()
      : this(
          rejectTypeId: '',
          rejectCode: '',
          description: [],
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  RejectTypeModel.fromMap(DataMap map)
      : this(
          rejectTypeId: map['rejectTypeId'] as String,
          rejectCode: map['rejectCode'] as String,
          description: List<LocalizedModel>.from(
            (map['description'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  DataMap toMap() => {
        'rejectTypeId': rejectTypeId,
        'rejectCode': rejectCode,
        'description': description.map((item) => item.toMap()).toList(),
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  factory RejectTypeModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return RejectTypeModel.fromMap(response);
  }

  RejectTypeModel copyWith({
    String? rejectTypeId,
    String? rejectCode,
    List<LocalizedModel>? description,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return RejectTypeModel(
      rejectTypeId: rejectTypeId ?? this.rejectTypeId,
      rejectCode: rejectCode ?? this.rejectCode,
      description: description ?? this.description,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  RejectTypeModel toCreated(String email, DateTime date) => copyWith(
        createdBy: email,
        createdDate: date,
        updatedBy: email,
        updatedDate: date,
      );

  RejectTypeModel toUpdated(String email, DateTime date) => copyWith(
        updatedBy: email,
        updatedDate: date,
      );
  @override
  List<Object> get props {
    return [
      rejectTypeId,
      rejectCode,
      description,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}