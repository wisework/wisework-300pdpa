//   requestReasonTemplateId string [primary key]
//   requestTypeId string [ref: > request_type.requestTypeId]
//   reasonTypeId array [ref: > reason_type.reasonTypeId]

//   status string
//   createdBy string
//   createdDate timestamp
//   updatedBy string
//   updatedDate timestamp
//   companyId string [ref: > company.companyId]
//   branchId string [ref: > branch.branchId]

//   import 'package:equatable/equatable.dart';
// import 'package:pdpa/app/shared/models/localized_text.dart';
// import 'package:pdpa/app/shared/utils/constants.dart';

// class RequestReasonTemplateModel extends Equatable {
//   const RequestReasonTemplateModel({
//     required this.requestReasonTemplateId,
//     required this.requestTypeId,
//     required this.reasonTypeId,
//     required this.requiredInputReasonText,
//     required this.status,
//     required this.createdBy,
//     required this.createdDate,
//     required this.updatedBy,
//     required this.updatedDate,
//     required this.companyId,
//   });

//   final String requestReasonTemplateId;
//   final String requestTypeId;
//   final List<LocalizedText> reasonTypeId;
//   final bool requiredInputReasonText;
//   final ActiveStatus status;
//   final String createdBy;
//   final DateTime createdDate;
//   final String updatedBy;
//   final DateTime updatedDate;
//   final String companyId;
// }
