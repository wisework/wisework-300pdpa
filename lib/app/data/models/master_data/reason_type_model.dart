import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
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
  });

  final String reasonTypeId;
  final String reasonCode;
  final List<LocalizedModel> description;
  final bool requiredInputReasonText;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  ReasonTypeModel.empty()
      : this(
          reasonTypeId: '',
          reasonCode: '',
          description: [],
          requiredInputReasonText: false,
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  ReasonTypeModel.fromMap(DataMap map)
      : this(
          reasonTypeId: map['reasonTypeId'] as String,
          reasonCode: map['reasonCode'] as String,
          description: List<LocalizedModel>.from(
            (map['description'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          requiredInputReasonText: map['requiredInputReasonText'] as bool,
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
        'reasonTypeId': reasonTypeId,
        'reasonCode': reasonCode,
        'description': description.map((item) => item.toMap()).toList(),
        'requiredInputReasonText': requiredInputReasonText,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  ReasonTypeModel copyWith({
    String? reasonTypeId,
    String? reasonCode,
    List<LocalizedModel>? description,
    bool? requiredInputReasonText,
    String? periodUnit,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
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
      reasonTypeId,
      reasonCode,
      description,
      requiredInputReasonText,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
