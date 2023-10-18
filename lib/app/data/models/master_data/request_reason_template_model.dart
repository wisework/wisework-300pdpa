import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class RequestReasonTemplateModel extends Equatable {
  const RequestReasonTemplateModel({
    required this.requestReasonTemplateId,
    required this.requestTypeId,
    required this.reasonTypesId,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String requestReasonTemplateId;
  final String requestTypeId;
  final List<String> reasonTypesId;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  RequestReasonTemplateModel.empty()
      : this(
          requestReasonTemplateId: '',
          requestTypeId: '',
          reasonTypesId: [],
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  RequestReasonTemplateModel.fromMap(DataMap map)
      : this(
          requestReasonTemplateId: map['requestReasonTemplateId'] as String,
          requestTypeId: map['requestTypeId'] as String,
          reasonTypesId:
              List<String>.from(map['reasonTypesId'] as List<dynamic>),
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  DataMap toMap() => {
        'requestTypeId': requestTypeId,
        'reasonTypesId': reasonTypesId,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  factory RequestReasonTemplateModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return RequestReasonTemplateModel.fromMap(response);
  }

  RequestReasonTemplateModel copyWith({
    String? requestReasonTemplateId,
    String? requestTypeId,
    List<String>? reasonTypesId,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return RequestReasonTemplateModel(
      requestReasonTemplateId:
          requestReasonTemplateId ?? this.requestReasonTemplateId,
      requestTypeId: requestTypeId ?? this.requestTypeId,
      reasonTypesId: reasonTypesId ?? this.reasonTypesId,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  RequestReasonTemplateModel toCreated(String email, DateTime date) => copyWith(
        createdBy: email,
        createdDate: date,
        updatedBy: email,
        updatedDate: date,
      );

  RequestReasonTemplateModel toUpdated(String email, DateTime date) => copyWith(
        updatedBy: email,
        updatedDate: date,
      );

  @override
  List<Object> get props {
    return [
      requestReasonTemplateId,
      requestTypeId,
      reasonTypesId,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
