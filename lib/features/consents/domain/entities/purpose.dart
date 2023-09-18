import 'package:equatable/equatable.dart';

import 'package:pdpa/core/utils/constants.dart';

class Purpose extends Equatable {
  const Purpose({
    required this.id,
    required this.description,
    required this.warningDescription,
    required this.retentionPeriod,
    required this.periodUnit,
    required this.uid,
    required this.language,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.companyId,
  });

  Purpose.empty()
      : this(
          id: '',
          description: '',
          warningDescription: '',
          retentionPeriod: 0,
          periodUnit: '',
          uid: '',
          language: '',
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
          companyId: '',
        );

  final String id;
  final String description;
  final String warningDescription;
  final int retentionPeriod;
  final String periodUnit;
  final String uid;
  final String language;
  final String companyId;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;
  

  @override
  List<Object?> get props {
    return [
      id,
      description,
      warningDescription,
      retentionPeriod,
      periodUnit,
      uid,
      language,
      companyId,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,   
    ];
  }
}
