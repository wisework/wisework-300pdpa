import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class ReasonTypeModel extends Equatable {
  const ReasonTypeModel({
    required this.id,
    required this.reasonCode,
    required this.description,
    required this.requiredInputReasonText,
    required this.editable,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String id;
  final String reasonCode;
  final List<LocalizedModel> description;
  final bool requiredInputReasonText;
  final bool editable;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  ReasonTypeModel.empty()
      : this(
          id: '',
          reasonCode: '',
          description: [],
          requiredInputReasonText: false,
          editable: true,
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  ReasonTypeModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          reasonCode: map['reasonCode'] as String,
          description: List<LocalizedModel>.from(
            (map['description'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          requiredInputReasonText: map['requiredInputReasonText'] as bool,
          editable: map['editable'] as bool,
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  factory ReasonTypeModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return ReasonTypeModel.fromMap(response);
  }

  DataMap toMap() => {
        'reasonCode': reasonCode,
        'description': description.map((item) => item.toMap()).toList(),
        'requiredInputReasonText': requiredInputReasonText,
        'editable': editable,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  ReasonTypeModel copyWith({
    String? id,
    String? reasonCode,
    List<LocalizedModel>? description,
    bool? requiredInputReasonText,
    String? periodUnit,
    bool? editable,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return ReasonTypeModel(
      id: id ?? this.id,
      reasonCode: reasonCode ?? this.reasonCode,
      description: description ?? this.description,
      requiredInputReasonText:
          requiredInputReasonText ?? this.requiredInputReasonText,
      editable: editable ?? this.editable,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  ReasonTypeModel setCreate(String email, DateTime date) => copyWith(
        createdBy: email,
        createdDate: date,
        updatedBy: email,
        updatedDate: date,
      );

  ReasonTypeModel setUpdate(String email, DateTime date) => copyWith(
        updatedBy: email,
        updatedDate: date,
      );

  @override
  List<Object> get props {
    return [
      id,
      reasonCode,
      description,
      requiredInputReasonText,
      editable,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
