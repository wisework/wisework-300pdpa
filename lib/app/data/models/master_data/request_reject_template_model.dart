import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class RequestRejectTemplateModel extends Equatable {
  const RequestRejectTemplateModel({
    required this.id,
    required this.requestTypeId,
    required this.rejectTypes,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String id;
  final String requestTypeId;
  final List<RejectTypeModel> rejectTypes;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  RequestRejectTemplateModel.empty()
      : this(
          id: '',
          requestTypeId: '',
          rejectTypes: [],
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  RequestRejectTemplateModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          requestTypeId: map['requestTypeId'] as String,
          rejectTypes:
              List<RejectTypeModel>.from(map['rejectTypes'] as List<dynamic>),
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
        'id': id,
        'requestTypeId': requestTypeId,
        'rejectTypes': rejectTypes,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  RequestRejectTemplateModel copyWith({
    String? id,
    String? requestTypeId,
    List<RejectTypeModel>? rejectTypes,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return RequestRejectTemplateModel(
      id: id ?? this.id,
      requestTypeId: requestTypeId ?? this.requestTypeId,
      rejectTypes: rejectTypes ?? this.rejectTypes,
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
      id,
      requestTypeId,
      rejectTypes,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
