import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class RequestTypeModel extends Equatable {
  const RequestTypeModel({
    required this.requestTypeId,
    required this.requestCode,
    required this.description,
    required this.requiredInputReasonText,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.companyId,
  });

  final String requestTypeId;
  final String requestCode;
  final String description;
  final bool requiredInputReasonText;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;
  final String companyId;

  RequestTypeModel.empty()
      : this(
          requestTypeId: '',
          requestCode: '',
          description: '',
          requiredInputReasonText: false,
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
          companyId: '',
        );

  RequestTypeModel.fromMap(DataMap map)
      : this(
          requestTypeId: map['requestTypeId'] as String,
          requestCode: map['requestCode'] as String,
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
        'requestTypeId': requestTypeId,
        'requestCode': requestCode,
        'description': description,
        'requiredInputReasonText': requiredInputReasonText,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
        'companyId': companyId,
      };

  factory RequestTypeModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return RequestTypeModel.fromMap(response);
  }

  RequestTypeModel copyWith({
    String? requestTypeId,
    String? requestCode,
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
    return RequestTypeModel(
      requestTypeId: requestTypeId ?? this.requestTypeId,
      requestCode: requestCode ?? this.requestCode,
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
      requestTypeId,
      requestCode,
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
