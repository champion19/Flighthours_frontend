import 'dart:convert';

import 'package:flight_hours_app/core/config/config.dart';
import 'package:flight_hours_app/features/reset_password/data/models/reset_password_response_model.dart';
import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Custom exception for password reset errors
class ResetPasswordException implements Exception {
  final String message;
  final String code;
  final int statusCode;

  ResetPasswordException({
    required this.message,
    required this.code,
    required this.statusCode,
  });

  @override
  String toString() => message;
}

class ResetPasswordDatasource {
  /// Sends a password reset request for the given email
  ///
  /// Returns [ResetPasswordEntity] on successful request (200)
  /// Throws [ResetPasswordException] on error
  Future<ResetPasswordEntity> requestPasswordReset(String email) async {
    debugPrint(
      '📤 Sending password reset request to: ${Config.baseUrl}/auth/password-reset',
    );
    debugPrint('📧 Email: $email');

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/auth/password-reset'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{'email': email}),
      );

      debugPrint('📥 Status Code: ${response.statusCode}');
      debugPrint('📥 Response: ${response.body}');

      final data = json.decode(response.body) as Map<String, dynamic>;
      final resetResponse = ResetPasswordResponseModel.fromMap(data);

      if (response.statusCode == 200 && resetResponse.success) {
        // Successful password reset request
        return ResetPasswordEntity(
          success: resetResponse.success,
          code: resetResponse.code,
          message: resetResponse.message,
        );
      } else {
        // Password reset request failed - throw exception with backend message and code
        throw ResetPasswordException(
          message: resetResponse.message,
          code: resetResponse.code,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ResetPasswordException) {
        rethrow;
      }
      // Network or parsing error
      debugPrint('❌ Connection error: $e');
      throw ResetPasswordException(
        message:
            'Connection error with the server. Please verify the backend is running.',
        code: 'CONNECTION_ERROR',
        statusCode: 0,
      );
    }
  }
}
