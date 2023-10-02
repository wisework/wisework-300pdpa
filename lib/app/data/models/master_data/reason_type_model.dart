import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class ReasonTypeModel extends Equatable {
  const ReasonTypeModel({
    required this.reasonTypeId,
    required this.reasonCode,
    required this.description,
    required this.requiredInputReasonText,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.companyId,
  });

  final String reasonTypeId;
  final String reasonCode;
  final String description;
  final bool requiredInputReasonText;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;
  final String companyId;

  ReasonTypeModel.empty()
      : this(
          reasonTypeId: '',
          reasonCode: '',
          description: '',
          requiredInputReasonText: false,
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
          companyId: '',
        );

  ReasonTypeModel.fromMap(DataMap map)
      : this(
          reasonTypeId: map['reasonTypeId'] as String,
          reasonCode: map['reasonCode'] as String,
          description: map['description'] as String,
          requiredInputReasonText: map['requiredInputReasonText'] as bool,
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
          companyId: map['companyId'] as String,
        );

  DataMap toMap() => {
        'reasonTypeId': reasonTypeId,
        'reasonCode': reasonCode,
        'description': description,
        'requiredInputReasonText': requiredInputReasonText,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
        'companyId': companyId,
      };

  factory ReasonTypeModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return ReasonTypeModel.fromMap(response);
  }

  ReasonTypeModel copyWith({
    String? reasonTypeId,
    String? reasonCode,
    String? description,
    bool? requiredInputReasonText,
    String? periodUnit,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
    String? companyId,
  }) {
    return ReasonTypeModel(
      reasonTypeId: reasonTypeId ?? this.reasonTypeId,
      reasonCode: reasonCode ?? this.reasonCode,
      description: description ?? this.description,
      requiredInputReasonText:
          requiredInputReasonText ?? this.requiredInputReasonText,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
      companyId: companyId ?? this.companyId,
    );
  }

  @override
  List<Object> get props {
    return [
      reasonTypeId,
      reasonCode,
      description,
      requiredInputReasonText,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
      companyId,
    ];
  }
}
