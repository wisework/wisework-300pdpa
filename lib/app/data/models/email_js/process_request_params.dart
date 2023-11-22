import 'package:equatable/equatable.dart';

import 'package:pdpa/app/shared/utils/typedef.dart';

class ProcessRequestTemplateParams extends Equatable {
  const ProcessRequestTemplateParams({
    required this.toName,
    required this.toEmail,
    required this.dataSubjectRightId,
    required this.processRequest,
    required this.processStatus,
  });

  final String toName;
  final String toEmail;
  final String dataSubjectRightId;
  final String processRequest;
  final String processStatus;

  const ProcessRequestTemplateParams.empty()
      : this(
          toName: '',
          toEmail: '',
          dataSubjectRightId: '',
          processRequest: '',
          processStatus: '',
        );

  ProcessRequestTemplateParams.fromMap(DataMap map)
      : this(
          toName: map['to_name'] as String,
          toEmail: map['to_email'] as String,
          dataSubjectRightId: map['dsr_id'] as String,
          processRequest: map['process_request'] as String,
          processStatus: map['process_status'] as String,
        );

  DataMap toMap() => {
        'to_name': toName,
        'to_email': toEmail,
        'dsr_id': dataSubjectRightId,
        'process_request': processRequest,
        'process_status': processStatus,
      };

  ProcessRequestTemplateParams copyWith({
    String? toName,
    String? toEmail,
    String? dataSubjectRightId,
    String? processRequest,
    String? processStatus,
  }) {
    return ProcessRequestTemplateParams(
      toName: toName ?? this.toName,
      toEmail: toEmail ?? this.toEmail,
      dataSubjectRightId: dataSubjectRightId ?? this.dataSubjectRightId,
      processRequest: processRequest ?? this.processRequest,
      processStatus: processStatus ?? this.processStatus,
    );
  }

  @override
  List<Object?> get props {
    return [
      toName,
      toEmail,
      dataSubjectRightId,
      processRequest,
      processStatus,
    ];
  }
}
