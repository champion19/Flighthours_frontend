import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/reset_password/data/models/reset_password_response_model.dart';
import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';
import 'package:flutter/material.dart';

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

/// Reset password data source using Dio
///
/// Note: This endpoint doesn't require authentication
class ResetPasswordDatasource {
  final Dio _dio;

  ResetPasswordDatasource({Dio? dio}) : _dio = dio ?? DioClient().client;

  /// Sends a password reset request for the given email
  ///
  /// Returns [ResetPasswordEntity] on successful request (200)
  /// Throws [ResetPasswordException] on error
  Future<ResetPasswordEntity> requestPasswordReset(String email) async {
    debugPrint('📤 Sending password reset request...');

    try {
      final response = await _dio.post(
        '/auth/password-reset',
        data: {'email': email},
      );

      // Dio already parses JSON to Map
      final resetResponse = ResetPasswordResponseModel.fromMap(response.data);

      if (response.statusCode == 200 && resetResponse.success) {
        // Successful password reset request
        return ResetPasswordEntity(
          success: resetResponse.success,
          code: resetResponse.code,
          message: resetResponse.message,
        );
      } else {
        // Password reset request failed
        throw ResetPasswordException(
          message: resetResponse.message,
          code: resetResponse.code,
          statusCode: response.statusCode ?? 0,
        );
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        // Server responded with an error
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          final resetResponse = ResetPasswordResponseModel.fromMap(data);
          throw ResetPasswordException(
            message: resetResponse.message,
            code: resetResponse.code,
            statusCode: e.response!.statusCode ?? 0,
          );
        }
        throw ResetPasswordException(
          message: 'Server error',
          code: 'SERVER_ERROR',
          statusCode: e.response!.statusCode ?? 0,
        );
      }

      // Connection error
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

      throw ResetPasswordException(
        message: errorMessage,
        code: 'CONNECTION_ERROR',
        statusCode: 0,
      );
    } on ResetPasswordException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');
      throw ResetPasswordException(
        message: 'Unexpected error occurred. Please try again.',
        code: 'UNEXPECTED_ERROR',
        statusCode: 0,
      );
    }
  }
}
