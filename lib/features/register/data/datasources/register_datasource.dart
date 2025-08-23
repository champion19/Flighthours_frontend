import 'dart:convert';

import 'package:flight_hours_app/core/config/config.dart';
import 'package:flight_hours_app/features/register/data/models/register_model.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterDatasource {
  Future<RegisterModel> registerEmployee(
    EmployeeEntityRegister employee,
  ) async {
    final payload = {
      'name': employee.name,
      'airline': employee.airline,
      'email': employee.email,
      'password': employee.password,
      'emailconfirmed': employee.emailConfirmed,
      'identificationNumber': employee.idNumber,
      'bp': employee.bp.toString(),
      'start_date': employee.fechaInicio,
      'end_date': employee.fechaFin,
      'active': employee.vigente.toLowerCase() == 'true',
    };

    final response = await http.post(
      Uri.parse('${Config.baseUrl}/employees'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );
    debugPrint(response.body);

    if (response.statusCode == 201) {
      return RegisterModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
