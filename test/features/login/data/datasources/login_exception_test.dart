import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/login/data/datasources/login_datasource.dart';

void main() {
  group('LoginException', () {
    test('should create with required fields', () {
      final exception = LoginException(
        message: 'Test error',
        code: 'TEST_ERR_001',
        statusCode: 401,
      );

      expect(exception.message, equals('Test error'));
      expect(exception.code, equals('TEST_ERR_001'));
      expect(exception.statusCode, equals(401));
    });

    test('toString should return message', () {
      final exception = LoginException(
        message: 'Error message',
        code: 'CODE',
        statusCode: 500,
      );

      expect(exception.toString(), equals('Error message'));
    });

    group('isEmailNotVerified', () {
      test('should return true for email not verified code', () {
        final exception = LoginException(
          message: 'Email not verified',
          code: 'MOD_KC_LOGIN_EMAIL_NOT_VERIFIED_ERR_00001',
          statusCode: 401,
        );

        expect(exception.isEmailNotVerified, isTrue);
      });

      test('should return false for other error codes', () {
        final exception = LoginException(
          message: 'Some error',
          code: 'OTHER_ERROR',
          statusCode: 401,
        );

        expect(exception.isEmailNotVerified, isFalse);
      });

      test('should return false for empty code', () {
        final exception = LoginException(
          message: 'Error',
          code: '',
          statusCode: 400,
        );

        expect(exception.isEmailNotVerified, isFalse);
      });
    });
  });
}
