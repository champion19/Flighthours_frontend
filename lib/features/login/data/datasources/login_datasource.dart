import 'dart:convert';

import 'package:flight_hours_app/core/config/config.dart';
import 'package:flight_hours_app/features/login/data/models/login_model.dart';
import 'package:http/http.dart' as http;

class LoginDatasource {
  Future<EmployeeModel> loginEmployee(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/login'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final body = response.body;
      return EmployeeModel.fromJson(body);
    } else {
      throw Exception('Failed to login');
    }
  }
}
