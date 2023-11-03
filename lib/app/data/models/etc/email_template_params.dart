import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class EmailTemplateParams extends Equatable {
  const EmailTemplateParams({
    required this.toName,
    required this.toEmail,
    required this.message,
  });

  final String toName;
  final String toEmail;
  final String message;

  const EmailTemplateParams.empty()
      : this(
          toName: '',
          toEmail: '',
          message: '',
        );

  EmailTemplateParams.fromMap(DataMap map)
      : this(
          toName: map['toName'] as String,
          toEmail: map['toEmail'] as String,
          message: map['message'] as String,
        );

  DataMap toMap() => {
        'to_name': toName,
        'to_email': toEmail,
        'message': message,
      };

  EmailTemplateParams copyWith({
    String? toName,
    String? toEmail,
    String? message,
  }) {
    return EmailTemplateParams(
      toName: toName ?? this.toName,
      toEmail: toEmail ?? this.toEmail,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [toName, toEmail, message];
}
