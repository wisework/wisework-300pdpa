import 'package:pdpa_utils/pdpa_utils.dart';

class Purpose {
  final String id;
  final List<LocalizedText> description;
  final List<LocalizedText> warningDescription;
  final int retentionPeriod;
  final String periodUnit;
  final ActiveStatus status;
  final String createdBy;
  final DateTimestamp createdDate;
  final String updatedBy;
  final DateTimestamp updatedDate;

  Purpose({
    required this.id,
    required this.description,
    required this.warningDescription,
    required this.retentionPeriod,
    required this.periodUnit,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  static Purpose get initial {
    return Purpose(
      id: '',
      description: [],
      warningDescription: [],
      retentionPeriod: 0,
      periodUnit: '',
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTimestamp.initial,
      updatedBy: '',
      updatedDate: DateTimestamp.initial,
    );
  }

  Purpose copyWith({
    String? id,
    List<LocalizedText>? description,
    List<LocalizedText>? warningDescription,
    int? retentionPeriod,
    String? periodUnit,
    ActiveStatus? status,
    String? createdBy,
    DateTimestamp? createdDate,
    String? updatedBy,
    DateTimestamp? updatedDate,
  }) {
    return Purpose(
      id: id ?? this.id,
      description: description ?? this.description,
      warningDescription: warningDescription ?? this.warningDescription,
      retentionPeriod: retentionPeriod ?? this.retentionPeriod,
      periodUnit: periodUnit ?? this.periodUnit,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': LocalizedText.toList(description),
      'warningDescription': LocalizedText.toList(warningDescription),
      'retentionPeriod': retentionPeriod,
      'periodUnit': periodUnit,
      'status': status.index,
      'createdBy': createdBy,
      'createdDate': createdDate.time,
      'updatedBy': updatedBy,
      'updatedDate': updatedDate.time,
    };
  }

  factory Purpose.fromMap(Map<String, dynamic> map) {
    return Purpose(
      id: map['id'] as String,
      description: LocalizedText.fromList(map['description']),
      warningDescription: LocalizedText.fromList(map['warningDescription']),
      retentionPeriod: map['retentionPeriod'] as int,
      periodUnit: map['periodUnit'] as String,
      status: ActiveStatus.values[map['status'] as int],
      createdBy: map['createdBy'] as String,
      createdDate: DateTimestamp(time: map['createdDate']),
      updatedBy: map['updatedBy'] as String,
      updatedDate: DateTimestamp(time: map['updatedDate']),
    );
  }

  @override
  String toString() {
    return 'Purpose(id: $id, description: $description, warningDescription: $warningDescription, retentionPeriod: $retentionPeriod, periodUnit: $periodUnit, status: $status, createdBy: $createdBy, createdDate: $createdDate, updatedBy: $updatedBy, updatedDate: $updatedDate)';
  }
}
