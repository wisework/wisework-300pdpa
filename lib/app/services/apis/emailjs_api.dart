import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/etc/email_template_params.dart';

class EmailJsApi {
  const EmailJsApi();

  Future<String> sendEmail(
    EmailTemplateParams params,
  ) async {
    final url = Uri.parse(AppConfig.emailJsUrl);
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': AppConfig.serviceId,
        'template_id': AppConfig.templateId,
        'user_id': AppConfig.userId,
        'template_params': params.toMap(),
      }),
    );

    return response.body;
  }
}
