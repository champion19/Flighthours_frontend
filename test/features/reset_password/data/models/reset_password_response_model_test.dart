import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/reset_password/data/models/reset_password_response_model.dart';

void main() {
  group('ResetPasswordResponseModel', () {
    test('fromMap should parse success response', () {
      final json = {
        'success': true,
        'code': 'RESET_EMAIL_SENT',
        'message': 'Password reset email has been sent',
      };

      final result = ResetPasswordResponseModel.fromMap(json);

      expect(result.success, isTrue);
      expect(result.code, equals('RESET_EMAIL_SENT'));
      expect(result.message, equals('Password reset email has been sent'));
    });

    test('fromMap should parse error response', () {
      final json = {
        'success': false,
        'code': 'USER_NOT_FOUND',
        'message': 'No user found with that email',
      };

      final result = ResetPasswordResponseModel.fromMap(json);

      expect(result.success, isFalse);
      expect(result.code, equals('USER_NOT_FOUND'));
    });

    test('fromMap should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final result = ResetPasswordResponseModel.fromMap(json);

      expect(result.success, isFalse);
      expect(result.code, isEmpty);
      expect(result.message, isEmpty);
    });

    test('fromJson should parse JSON string', () {
      const jsonStr = '{"success":true,"code":"OK","message":"Done"}';

      final result = ResetPasswordResponseModel.fromJson(jsonStr);

      expect(result.success, isTrue);
      expect(result.code, equals('OK'));
    });

    test('toMap should serialize correctly', () {
      final model = ResetPasswordResponseModel(
        success: true,
        code: 'SUCCESS',
        message: 'Operation completed',
      );

      final map = model.toMap();

      expect(map['success'], isTrue);
      expect(map['code'], equals('SUCCESS'));
      expect(map['message'], equals('Operation completed'));
    });

    test('toJson should return valid JSON string', () {
      final model = ResetPasswordResponseModel(
        success: false,
        code: 'ERROR',
        message: 'Failed',
      );

      final jsonStr = model.toJson();

      expect(jsonStr, contains('"success":false'));
      expect(jsonStr, contains('"code":"ERROR"'));
    });
  });
}
