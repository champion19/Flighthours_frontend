import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/email_verification/data/models/email_verification_model.dart';

/// Email verification data source using Dio
class EmailVerificationDatasource {
  final Dio _dio;

  EmailVerificationDatasource({Dio? dio}) : _dio = dio ?? DioClient().client;

  Future<EmailVerificationModel> verifyEmail(String email) async {
    try {
      final response = await _dio.get(
        '/Flighthours/email/status',
        queryParameters: {'email': email},
      );

      // Dio already parses JSON to Map
      return EmailVerificationModel.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to verify email: ${e.response?.data}');
      }
      throw Exception('Connection error while verifying email');
    }
  }
}
