import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/reset_password/data/datasources/reset_password_datasource.dart';

void main() {
  group('ResetPasswordException', () {
    test('should create with required fields', () {
      final exception = ResetPasswordException(
        message: 'Test error',
        code: 'TEST_ERR_001',
        statusCode: 400,
      );

      expect(exception.message, equals('Test error'));
      expect(exception.code, equals('TEST_ERR_001'));
      expect(exception.statusCode, equals(400));
    });

    test('toString should return message', () {
      final exception = ResetPasswordException(
        message: 'Error message',
        code: 'CODE',
        statusCode: 500,
      );

      expect(exception.toString(), equals('Error message'));
    });

    test('should handle different status codes', () {
      final exception401 = ResetPasswordException(
        message: 'Unauthorized',
        code: 'UNAUTHORIZED',
        statusCode: 401,
      );

      final exception404 = ResetPasswordException(
        message: 'Not found',
        code: 'NOT_FOUND',
        statusCode: 404,
      );

      expect(exception401.statusCode, equals(401));
      expect(exception404.statusCode, equals(404));
    });

    test('should handle zero status code for connection errors', () {
      final exception = ResetPasswordException(
        message: 'Connection error',
        code: 'CONNECTION_ERROR',
        statusCode: 0,
      );

      expect(exception.statusCode, equals(0));
      expect(exception.code, equals('CONNECTION_ERROR'));
    });
  });
}
