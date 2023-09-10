import 'package:pdpa_utils/pdpa_utils.dart';

class Company {
  final String id;
  final String name;
  final String profileImage;
  final ActiveStatus status;
  final String createdBy;
  final DateTimestamp createdDate;
  final String updatedBy;
  final DateTimestamp updatedDate;

  Company({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  static Company get initial {
    return Company(
      id: '',
      name: '',
      profileImage: '',
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTimestamp.initial,
      updatedBy: '',
      updatedDate: DateTimestamp.initial,
    );
  }

  Company copyWith({
    String? id,
    String? name,
    String? profileImage,
    ActiveStatus? status,
    String? createdBy,
    DateTimestamp? createdDate,
    String? updatedBy,
    DateTimestamp? updatedDate,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'profileImage': profileImage,
      'status': status.index,
      'createdBy': createdBy,
      'createdDate': createdDate.time,
      'updatedBy': updatedBy,
      'updatedDate': updatedDate.time,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'] as String,
      name: map['name'] as String,
      profileImage: map['profileImage'] as String,
      status: ActiveStatus.values[map['status'] as int],
      createdBy: map['createdBy'] as String,
      createdDate: DateTimestamp(time: map['createdDate']),
      updatedBy: map['updatedBy'] as String,
      updatedDate: DateTimestamp(time: map['updatedDate']),
    );
  }

  @override
  String toString() {
    return 'Company(id: $id, name: $name, profileImage: $profileImage, status: $status, createdBy: $createdBy, createdDate: $createdDate, updatedBy: $updatedBy, updatedDate: $updatedDate)';
  }
}
