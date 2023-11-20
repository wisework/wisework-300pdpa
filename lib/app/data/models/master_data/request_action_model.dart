import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class RequestActionModel extends Equatable {
  const RequestActionModel({
    required this.id,
    required this.title,
    required this.priority,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String id;
  final List<LocalizedModel> title;
  final int priority;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  RequestActionModel.empty()
      : this(
          id: '',
          title: [],
          priority: 0,
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  RequestActionModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          title: List<LocalizedModel>.from(
            (map['title'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          priority: map['priority'] as int,
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  factory RequestActionModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return RequestActionModel.fromMap(response);
  }

  DataMap toMap() => {
        'title': title.map((item) => item.toMap()).toList(),
        'priority': priority,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  RequestActionModel copyWith({
    String? id,
    List<LocalizedModel>? title,
    int? priority,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return RequestActionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  RequestActionModel setCreate(String email, DateTime date) => copyWith(
        createdBy: email,
        createdDate: date,
        updatedBy: email,
        updatedDate: date,
      );

  RequestActionModel setUpdate(String email, DateTime date) => copyWith(
        updatedBy: email,
        updatedDate: date,
      );

  @override
  List<Object> get props {
    return [
      id,
      title,
      priority,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
