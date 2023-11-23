import 'package:equatable/equatable.dart';

import 'package:pdpa/app/shared/utils/typedef.dart';

class ProcessRequestTemplateParams extends Equatable {
  const ProcessRequestTemplateParams({
    required this.toName,
    required this.toEmail,
    this.fromName = '',
    this.fromEmail = '',
    required this.id,
    required this.processRequest,
    required this.processStatus,
    this.link = '',
  });

  final String toName;
  final String toEmail;
  final String fromName;
  final String fromEmail;
  final String id;
  final String processRequest;
  final String processStatus;
  final String link;

  const ProcessRequestTemplateParams.empty()
      : this(
          toName: '',
          toEmail: '',
          fromName: '',
          fromEmail: '',
          id: '',
          processRequest: '',
          processStatus: '',
          link: '',
        );

  ProcessRequestTemplateParams.fromMap(DataMap map)
      : this(
          toName: map['to_name'] as String,
          toEmail: map['to_email'] as String,
          fromName: map['from_name'] as String,
          fromEmail: map['from_email'] as String,
          id: map['id'] as String,
          processRequest: map['process_request'] as String,
          processStatus: map['process_status'] as String,
          link: map['link'] as String,
        );

  DataMap toMap() => {
        'to_name': toName,
        'to_email': toEmail,
        'from_name': fromName,
        'from_email': fromEmail,
        'id': id,
        'process_request': processRequest,
        'process_status': processStatus,
        'link': link,
      };

  ProcessRequestTemplateParams copyWith({
    String? toName,
    String? toEmail,
    String? fromName,
    String? fromEmail,
    String? id,
    String? processRequest,
    String? processStatus,
    String? link,
  }) {
    return ProcessRequestTemplateParams(
      toName: toName ?? this.toName,
      toEmail: toEmail ?? this.toEmail,
      fromName: fromName ?? this.fromName,
      fromEmail: fromEmail ?? this.fromEmail,
      id: id ?? this.id,
      processRequest: processRequest ?? this.processRequest,
      processStatus: processStatus ?? this.processStatus,
      link: link ?? this.link,
    );
  }

  @override
  List<Object?> get props {
    return [
      toName,
      toEmail,
      fromName,
      fromEmail,
      id,
      processRequest,
      processStatus,
      link,
    ];
  }
}
