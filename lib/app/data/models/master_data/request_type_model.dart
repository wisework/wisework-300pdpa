import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class RequestTypeModel extends Equatable {
  const RequestTypeModel({
    required this.id,
    required this.requestCode,
    required this.description,
    required this.rejectTypes,
    required this.editable,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String id;
  final String requestCode;
  final List<LocalizedModel> description;
  final List<RejectTypeModel> rejectTypes;
  final bool editable;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  RequestTypeModel.empty()
      : this(
          id: '',
          requestCode: '',
          description: [],
          rejectTypes: [],
          editable: true,
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  RequestTypeModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          requestCode: map['requestCode'] as String,
          description: List<LocalizedModel>.from(
            (map['description'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          rejectTypes: List<RejectTypeModel>.from(
            (map['rejectTypes'] as List<dynamic>).map<RejectTypeModel>(
              (item) => RejectTypeModel.fromMap(item as DataMap),
            ),
          ),
          editable: map['editable'] as bool,
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  DataMap toMap() => {
        'id': id,
        'requestCode': requestCode,
        'description': description.map((item) => item.toMap()).toList(),
        'rejectTypes':
            rejectTypes.map((rejectTypes) => rejectTypes.id).toList(),
        'editable': editable,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  factory RequestTypeModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return RequestTypeModel.fromMap(response);
  }

  RequestTypeModel copyWith({
    String? id,
    String? requestCode,
    List<LocalizedModel>? description,
    List<RejectTypeModel>? rejectTypes,
    bool? editable,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return RequestTypeModel(
      id: id ?? this.id,
      requestCode: requestCode ?? this.requestCode,
      description: description ?? this.description,
      rejectTypes: rejectTypes ?? this.rejectTypes,
      editable: editable ?? this.editable,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  RequestTypeModel setCreate(String email, DateTime date) => copyWith(
        createdBy: email,
        createdDate: date,
        updatedBy: email,
        updatedDate: date,
      );

  RequestTypeModel setUpdate(String email, DateTime date) => copyWith(
        updatedBy: email,
        updatedDate: date,
      );
  @override
  List<Object> get props {
    return [
      id,
      requestCode,
      description,
      rejectTypes,
      editable,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
