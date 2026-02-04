import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/core/validator/form_validator.dart';

void main() {
  group('FormValidator', () {
    group('validateEmail', () {
      test('should return error for null value', () {
        final result = FormValidator.validateEmail(null);
        expect(result, isNotNull);
        expect(result, contains('requerido'));
      });

      test('should return error for empty value', () {
        final result = FormValidator.validateEmail('');
        expect(result, isNotNull);
        expect(result, contains('requerido'));
      });

      test('should return error for invalid email format', () {
        expect(FormValidator.validateEmail('invalid'), isNotNull);
        expect(FormValidator.validateEmail('invalid@'), isNotNull);
        expect(FormValidator.validateEmail('@invalid.com'), isNotNull);
      });

      test('should return null for valid email', () {
        expect(FormValidator.validateEmail('test@example.com'), isNull);
        expect(FormValidator.validateEmail('user.name@domain.org'), isNull);
      });
    });

    group('validatePassword', () {
      test('should return error for null value', () {
        final result = FormValidator.validatePassword(null);
        expect(result, isNotNull);
        expect(result, contains('requerida'));
      });

      test('should return error for empty value', () {
        final result = FormValidator.validatePassword('');
        expect(result, isNotNull);
        expect(result, contains('requerida'));
      });

      test('should return error for password too short', () {
        final result = FormValidator.validatePassword('short');
        expect(result, isNotNull);
        expect(result, contains('8 caracteres'));
      });

      test('should return null for valid password (8+ chars)', () {
        expect(FormValidator.validatePassword('password'), isNull);
        expect(FormValidator.validatePassword('longpassword123'), isNull);
      });
    });
  });
}
