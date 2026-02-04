import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';

void main() {
  group('ResetPasswordEntity', () {
    test('should create entity with required fields', () {
      final entity = ResetPasswordEntity(
        success: true,
        code: 'RESET_SENT',
        message: 'Password reset email sent',
      );

      expect(entity.success, isTrue);
      expect(entity.code, equals('RESET_SENT'));
      expect(entity.message, equals('Password reset email sent'));
    });

    test('should create entity with failure status', () {
      final entity = ResetPasswordEntity(
        success: false,
        code: 'USER_NOT_FOUND',
        message: 'User not found',
      );

      expect(entity.success, isFalse);
      expect(entity.code, equals('USER_NOT_FOUND'));
    });
  });
}
