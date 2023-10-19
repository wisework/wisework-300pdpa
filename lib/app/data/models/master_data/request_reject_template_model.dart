import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class RequestRejectTemplateModel extends Equatable {
  const RequestRejectTemplateModel({
    required this.requestRejectTemplateId,
    required this.requestTypeId,
    required this.rejectTypesId,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String requestRejectTemplateId;
  final String requestTypeId;
  final List<String> rejectTypesId;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  RequestRejectTemplateModel.empty()
      : this(
          requestRejectTemplateId: '',
          requestTypeId: '',
          rejectTypesId: [],
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  RequestRejectTemplateModel.fromMap(DataMap map)
      : this(
          requestRejectTemplateId: map['requestRejectTemplateId'] as String,
          requestTypeId: map['requestTypeId'] as String,
          rejectTypesId:
              List<String>.from(map['rejectTypesId'] as List<dynamic>),
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  factory RequestRejectTemplateModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return RequestRejectTemplateModel.fromMap(response);
  }

  DataMap toMap() => {
        'requestTypeId': requestTypeId,
        'rejectTypesId': rejectTypesId,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  RequestRejectTemplateModel copyWith({
    String? requestRejectTemplateId,
    String? requestTypeId,
    List<String>? rejectTypesId,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return RequestRejectTemplateModel(
      requestRejectTemplateId:
          requestRejectTemplateId ?? this.requestRejectTemplateId,
      requestTypeId: requestTypeId ?? this.requestTypeId,
      rejectTypesId: rejectTypesId ?? this.rejectTypesId,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  RequestRejectTemplateModel toCreated(String email, DateTime date) => copyWith(
        createdBy: email,
        createdDate: date,
        updatedBy: email,
        updatedDate: date,
      );

  RequestRejectTemplateModel toUpdated(String email, DateTime date) => copyWith(
        updatedBy: email,
        updatedDate: date,
      );

  @override
  List<Object> get props {
    return [
      requestRejectTemplateId,
      requestTypeId,
      rejectTypesId,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
