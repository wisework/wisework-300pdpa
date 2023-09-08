import 'package:pdpa_utils/pdpa_utils.dart';

class CustomField {
  final String id;
  final List<LocalizedText> title;
  final List<LocalizedText> hintText;
  final String inputType;
  final int? lengthLimit;
  final int minLines;
  final int maxLines;
  final String status;
  final String createdBy;
  final DateTimestamp createdDate;
  final String updatedBy;
  final DateTimestamp updatedDate;

  CustomField({
    required this.id,
    required this.title,
    required this.hintText,
    required this.inputType,
    this.lengthLimit,
    required this.minLines,
    required this.maxLines,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  CustomField copyWith({
    String? id,
    List<LocalizedText>? title,
    List<LocalizedText>? hintText,
    String? inputType,
    int? lengthLimit,
    int? minLines,
    int? maxLines,
    String? status,
    String? createdBy,
    DateTimestamp? createdDate,
    String? updatedBy,
    DateTimestamp? updatedDate,
  }) {
    return CustomField(
      id: id ?? this.id,
      title: title ?? this.title,
      hintText: hintText ?? this.hintText,
      inputType: inputType ?? this.inputType,
      lengthLimit: lengthLimit ?? this.lengthLimit,
      minLines: minLines ?? this.minLines,
      maxLines: maxLines ?? this.maxLines,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': LocalizedText.toList(title),
      'hintText': LocalizedText.toList(hintText),
      'inputType': inputType,
      'lengthLimit': lengthLimit,
      'minLines': minLines,
      'maxLines': maxLines,
      'status': status,
      'createdBy': createdBy,
      'createdDate': createdDate.time,
      'updatedBy': updatedBy,
      'updatedDate': updatedDate.time,
    };
  }

  factory CustomField.fromMap(Map<String, dynamic> map) {
    return CustomField(
      id: map['id'] as String,
      title: LocalizedText.fromList(map['title']),
      hintText: LocalizedText.fromList(map['hintText']),
      inputType: map['inputType'] as String,
      lengthLimit:
          map['lengthLimit'] != null ? int.parse(map['lengthLimit']) : null,
      minLines: map['minLines'] as int,
      maxLines: map['maxLines'] as int,
      status: map['status'] as String,
      createdBy: map['createdBy'] as String,
      createdDate: DateTimestamp.parse(map['createdDate']),
      updatedBy: map['updatedBy'] as String,
      updatedDate: DateTimestamp.parse(map['updatedDate']),
    );
  }

  @override
  String toString() {
    return 'CustomField(id: $id, title: $title, hintText: $hintText, inputType: $inputType, lengthLimit: $lengthLimit, minLines: $minLines, maxLines: $maxLines, status: $status, createdBy: $createdBy, createdDate: $createdDate, updatedBy: $updatedBy, updatedDate: $updatedDate)';
  }
}
