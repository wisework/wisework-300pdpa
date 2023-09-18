import 'package:equatable/equatable.dart';

import 'package:pdpa/core/utils/constants.dart';

class PurposeCategory extends Equatable {
  const PurposeCategory({
    required this.id,
    required this.purposes,
    required this.title,
    required this.description,
    required this.priority,
    required this.language,
    required this.uid,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.companyId,
  });

  PurposeCategory.empty()
      : this(
          id: '',
          purposes: [],
          title: '',
          description: '',
          priority: 0,
          language: '',
          uid: '',
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
          companyId: '',
        );

  final String id;
  final List<String> purposes;
  final String title;
  final String description;
  final int priority;
  final String language;
  final String uid;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;
  final String companyId;

  @override
  List<Object?> get props {
    return [
      id,
      purposes,
      title,
      description,
      priority,
      language,
      uid,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
      companyId,
    ];
  }
}
