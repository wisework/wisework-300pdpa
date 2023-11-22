import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class SignedUpTemplateParams extends Equatable {
  const SignedUpTemplateParams({
    required this.toName,
    required this.toEmail,
    required this.message,
  });

  final String toName;
  final String toEmail;
  final String message;

  const SignedUpTemplateParams.empty()
      : this(
          toName: '',
          toEmail: '',
          message: '',
        );

  SignedUpTemplateParams.fromMap(DataMap map)
      : this(
          toName: map['to_name'] as String,
          toEmail: map['to_email'] as String,
          message: map['message'] as String,
        );

  DataMap toMap() => {
        'to_name': toName,
        'to_email': toEmail,
        'message': message,
      };

  SignedUpTemplateParams copyWith({
    String? toName,
    String? toEmail,
    String? message,
  }) {
    return SignedUpTemplateParams(
      toName: toName ?? this.toName,
      toEmail: toEmail ?? this.toEmail,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [toName, toEmail, message];
}
