import 'dart:convert';

import 'package:flight_hours_app/core/config/config.dart';
import 'package:flight_hours_app/features/register/data/models/register_response_model.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Excepción personalizada para errores de registro
class RegisterException implements Exception {
  final String message;
  final String code;
  final int statusCode;

  RegisterException({
    required this.message,
    required this.code,
    required this.statusCode,
  });

  @override
  String toString() => message;
}

class RegisterDatasource {
  /// Formatea una fecha ISO a formato simple YYYY-MM-DD
  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoDate;
    }
  }

  /// Registra un nuevo empleado en el sistema
  ///
  /// Retorna [RegisterResponseModel] si el registro es exitoso (201)
  /// Lanza [RegisterException] si hay error (409 duplicado, u otros errores)
  Future<RegisterResponseModel> registerEmployee(
    EmployeeEntityRegister employee,
  ) async {
    // Payload exacto que espera el backend Go
    final payload = {
      'name': employee.name,
      'email': employee.email,
      'password': employee.password,
      'identificationnumber':
          employee.idNumber, // lowercase como espera el backend
      'start_date': _formatDate(employee.fechaInicio), // formato YYYY-MM-DD
      'end_date': _formatDate(employee.fechaFin), // formato YYYY-MM-DD
      'role': employee.role ?? 'pilot', // rol por defecto: pilot
    };

    debugPrint('📤 Enviando registro a: ${Config.baseUrl}/register');
    debugPrint('📦 Payload: ${json.encode(payload)}');

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      debugPrint('📥 Status Code: ${response.statusCode}');
      debugPrint('📥 Response: ${response.body}');

      final data = json.decode(response.body) as Map<String, dynamic>;
      final registerResponse = RegisterResponseModel.fromMap(data);

      if (response.statusCode == 201 && registerResponse.success) {
        // Registro exitoso
        return registerResponse;
      } else {
        // Error del backend (409 duplicado u otro error)
        throw RegisterException(
          message: registerResponse.message,
          code: registerResponse.code,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is RegisterException) {
        rethrow;
      }
      // Error de conexión u otro error de red
      debugPrint('❌ Error de conexión: $e');
      throw RegisterException(
        message:
            'Error de conexión con el servidor. Verifica que el backend esté corriendo.',
        code: 'CONNECTION_ERROR',
        statusCode: 0,
      );
    }
  }
}
