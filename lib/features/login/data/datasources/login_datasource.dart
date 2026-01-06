import 'dart:convert';

import 'package:flight_hours_app/core/config/config.dart';
import 'package:flight_hours_app/features/login/data/models/login_response_model.dart';
import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Custom exception for login errors with backend error codes
class LoginException implements Exception {
  final String message;
  final String code;
  final int statusCode;

  LoginException({
    required this.message,
    required this.code,
    required this.statusCode,
  });

  /// Check if this is an email not verified error
  bool get isEmailNotVerified =>
      code == 'MOD_KC_LOGIN_EMAIL_NOT_VERIFIED_ERR_00001';

  @override
  String toString() => message;
}

class LoginDatasource {
  /// Logs in an employee with email and password
  ///
  /// Returns [LoginEntity] on successful login (200)
  /// Throws [LoginException] on error (401 email not verified, or other errors)
  Future<LoginEntity> loginEmployee(String email, String password) async {
    debugPrint('📤 Sending login to: ${Config.baseUrl}/login');
    debugPrint('📧 Email: $email');

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/login'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      debugPrint('📥 Status Code: ${response.statusCode}');
      debugPrint('📥 Response: ${response.body}');

      final data = json.decode(response.body) as Map<String, dynamic>;
      final loginResponse = LoginResponseModel.fromMap(data);

      if (response.statusCode == 200 && loginResponse.success) {
        // Successful login - return token data
        if (loginResponse.data == null) {
          throw LoginException(
            message: 'Invalid response: missing token data',
            code: 'INVALID_RESPONSE',
            statusCode: response.statusCode,
          );
        }

        return LoginEntity(
          accessToken: loginResponse.data!.accessToken,
          refreshToken: loginResponse.data!.refreshToken,
          expiresIn: loginResponse.data!.expiresIn,
          tokenType: loginResponse.data!.tokenType,
          employeeId: loginResponse.data!.employeeId,
          email: email,
        );
      } else {
        // Login failed - throw exception with backend message and code
        throw LoginException(
          message: loginResponse.message,
          code: loginResponse.code,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is LoginException) {
        rethrow;
      }
      // Network or parsing error
      debugPrint('❌ Connection error: $e');
      throw LoginException(
        message:
            'Connection error with the server. Please verify the backend is running.',
        code: 'CONNECTION_ERROR',
        statusCode: 0,
      );
    }
  }
}
