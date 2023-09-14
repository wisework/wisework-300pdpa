import 'package:equatable/equatable.dart';

import 'package:pdpa/core/utils/constants.dart';

class Company extends Equatable {
  const Company({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  Company.empty()
      : this(
          id: '',
          name: '',
          profileImage: '',
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  final String id;
  final String name;
  final String profileImage;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      profileImage,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
