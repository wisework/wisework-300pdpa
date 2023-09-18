import 'package:equatable/equatable.dart';

import 'package:pdpa/core/utils/constants.dart';

class CustomField extends Equatable {
  const CustomField({
    required this.id,
    required this.title,
    required this.inputType,
    required this.lengthLimit,
    required this.maxLines,
    required this.minLines,
    required this.placeholder,
    required this.uid,
    required this.language,
    required this.companies,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  CustomField.empty()
      : this(
          id: '',
          title: '',
          inputType: '',
          lengthLimit: 1,
          maxLines: 1,
          minLines: 1,
          placeholder: '',
          uid: '',
          language: '',
          companies: [],
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  final String id;
  final String title;
  final String inputType;
  final int lengthLimit;
  final int maxLines;
  final int minLines;
  final String placeholder;
  final String uid;
  final String language;
  final List<String> companies;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  @override
  List<Object?> get props {
    return [
      id,
      title,
      inputType,
      lengthLimit,
      maxLines,
      minLines,
      placeholder,
      uid,
      language,
      companies,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
