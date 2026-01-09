import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/login/data/models/login_response_model.dart';
import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';
import 'package:flutter/material.dart';

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

/// Login data source using Dio
///
/// Note: This endpoint doesn't require authentication (it's used to GET the token)
/// but we still use DioClient for:
/// - Consistent logging across the app
/// - Same timeout configuration
/// - Centralized base URL
class LoginDatasource {
  final Dio _dio;

  LoginDatasource({Dio? dio}) : _dio = dio ?? DioClient().client;

  /// Logs in an employee with email and password
  ///
  /// Returns [LoginEntity] on successful login (200)
  /// Throws [LoginException] on error (401 email not verified, or other errors)
  Future<LoginEntity> loginEmployee(String email, String password) async {
    debugPrint('📤 Sending login request...');

    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      // Dio already parses JSON to Map
      final loginResponse = LoginResponseModel.fromMap(response.data);

      if (response.statusCode == 200 && loginResponse.success) {
        // Successful login - return token data
        if (loginResponse.data == null) {
          throw LoginException(
            message: 'Invalid response: missing token data',
            code: 'INVALID_RESPONSE',
            statusCode: response.statusCode ?? 0,
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
          statusCode: response.statusCode ?? 0,
        );
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        // Server responded with an error
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          final loginResponse = LoginResponseModel.fromMap(data);
          throw LoginException(
            message: loginResponse.message,
            code: loginResponse.code,
            statusCode: e.response!.statusCode ?? 0,
          );
        }
        throw LoginException(
          message: 'Server error',
          code: 'SERVER_ERROR',
          statusCode: e.response!.statusCode ?? 0,
        );
      }

      // Connection error (timeout, no internet, etc.)
      debugPrint('❌ Connection error: ${e.message}');

      String errorMessage;
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage =
            'Connection error with the server. Please verify the backend is running.';
      } else {
        errorMessage = 'Network error. Please check your connection.';
      }

      throw LoginException(
        message: errorMessage,
        code: 'CONNECTION_ERROR',
        statusCode: 0,
      );
    } on LoginException {
      rethrow;
    } catch (e) {
      // Unexpected error
      debugPrint('❌ Unexpected error: $e');
      throw LoginException(
        message: 'Unexpected error occurred. Please try again.',
        code: 'UNEXPECTED_ERROR',
        statusCode: 0,
      );
    }
  }
}
