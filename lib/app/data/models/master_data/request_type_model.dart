import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class RequestTypeModel extends Equatable {
  const RequestTypeModel({
    required this.id,
    required this.requestCode,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String id;
  final String requestCode;
  final List<LocalizedModel> description;
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
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  RequestTypeModel toCreated(String email, DateTime date) => copyWith(
        createdBy: email,
        createdDate: date,
        updatedBy: email,
        updatedDate: date,
      );

  RequestTypeModel toUpdated(String email, DateTime date) => copyWith(
        updatedBy: email,
        updatedDate: date,
      );
  @override
  List<Object> get props {
    return [
      id,
      requestCode,
      description,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
