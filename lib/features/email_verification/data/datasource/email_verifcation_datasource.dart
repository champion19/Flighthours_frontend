
import 'dart:convert';

import 'package:flight_hours_app/core/config/config.dart';
import 'package:flight_hours_app/features/email_verification/data/models/email_verification_model.dart';
import 'package:http/http.dart' as http;

class EmailVerificationDatasource {
  Future<EmailVerificationModel> verifyEmail(String email) async {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/Flighthours/email/status?email=$email'),
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body =jsonDecode(response.body);
      return EmailVerificationModel.fromMap(body);
    } else {
      throw Exception('Failed to login');
    }
  }
}
