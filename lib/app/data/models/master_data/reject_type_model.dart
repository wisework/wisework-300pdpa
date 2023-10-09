import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

class RejectTypeModel extends Equatable {
  const RejectTypeModel({
    required this.rejectTypeId,
    required this.rejectCode,
    required this.description,
    required this.requiredInputReasonText,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.companyId,
  });

  final String rejectTypeId;
  final String rejectCode;
  final List<LocalizedModel> description;
  final bool requiredInputReasonText;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;
  final String companyId;

  RejectTypeModel copyWith({
    String? rejectTypeId,
    String? rejectCode,
    List<LocalizedModel>? description,
    bool? requiredInputReasonText,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
    String? companyId,
  }) {
    return RejectTypeModel(
      rejectTypeId: rejectTypeId ?? this.rejectTypeId,
      rejectCode: rejectCode ?? this.rejectCode,
      description: description ?? this.description,
      requiredInputReasonText:
          requiredInputReasonText ?? this.requiredInputReasonText,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
      companyId: companyId ?? this.companyId,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      rejectTypeId,
      rejectCode,
      description,
      requiredInputReasonText,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
      companyId,
    ];
  }
}
