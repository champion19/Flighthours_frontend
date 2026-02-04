import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/core/constants/validation_messages.dart';

void main() {
  group('ValidationMessages', () {
    group('Static constants', () {
      test('should have email validation messages', () {
        expect(ValidationMessages.emailRequired, equals('Email is required'));
        expect(ValidationMessages.emailInvalid, equals('Enter a valid email'));
        expect(
          ValidationMessages.invalidEmail,
          equals('Enter a valid email address'),
        );
      });

      test('should have password validation messages', () {
        expect(
          ValidationMessages.passwordRequired,
          equals('Password is required'),
        );
        expect(ValidationMessages.passwordTooShort, contains('8 characters'));
        expect(ValidationMessages.passwordTooWeak, contains('uppercase'));
        expect(
          ValidationMessages.passwordMismatch,
          equals('Passwords do not match'),
        );
      });

      test('should have password requirement messages', () {
        expect(ValidationMessages.passwordMinLength, contains('8 characters'));
        expect(ValidationMessages.passwordUppercase, contains('uppercase'));
        expect(ValidationMessages.passwordLowercase, contains('lowercase'));
        expect(ValidationMessages.passwordNumber, contains('number'));
        expect(ValidationMessages.passwordSpecialChar, contains('special'));
      });

      test('should have authentication error messages', () {
        expect(
          ValidationMessages.invalidCredentials,
          equals('Invalid email or password'),
        );
      });

      test('should have network error messages', () {
        expect(ValidationMessages.networkError, contains('Connection error'));
        expect(ValidationMessages.serverError, contains('Server error'));
        expect(ValidationMessages.timeoutError, contains('timed out'));
        expect(ValidationMessages.genericError, contains('unexpected error'));
      });

      test('should have success messages', () {
        expect(ValidationMessages.loginSuccess, equals('Login successful'));
        expect(
          ValidationMessages.logoutSuccess,
          equals('Logged out successfully'),
        );
      });

      test('should have generic validation messages', () {
        expect(
          ValidationMessages.requiredField,
          equals('This field is required'),
        );
        expect(ValidationMessages.invalidFormat, equals('Invalid format'));
      });

      test('should have name validation messages', () {
        expect(ValidationMessages.nameRequired, equals('Name is required'));
        expect(ValidationMessages.nameMinLength, contains('2 characters'));
        expect(ValidationMessages.nameInvalid, contains('valid name'));
      });

      test('should have identity validation messages', () {
        expect(
          ValidationMessages.identityRequired,
          equals('ID number is required'),
        );
        expect(ValidationMessages.identityInvalid, contains('valid ID'));
        expect(ValidationMessages.identityMinLength, contains('7 digits'));
      });

      test('should have phone validation messages', () {
        expect(
          ValidationMessages.phoneRequired,
          equals('Phone number is required'),
        );
        expect(ValidationMessages.phoneInvalid, contains('valid phone'));
        expect(ValidationMessages.phoneFormat, contains('10 and 13'));
      });

      test('should have numeric validation messages', () {
        expect(ValidationMessages.numberRequired, contains('must be a number'));
        expect(ValidationMessages.numberInvalid, contains('valid number'));
      });

      test('should have length validation messages with placeholders', () {
        expect(ValidationMessages.minLength, contains('@min'));
        expect(ValidationMessages.maxLength, contains('@max'));
        expect(ValidationMessages.exactLength, contains('@length'));
      });
    });

    group('Dynamic helper methods', () {
      test('minLengthWithValue should return formatted message', () {
        expect(
          ValidationMessages.minLengthWithValue(5),
          equals('Minimum 5 characters'),
        );
        expect(
          ValidationMessages.minLengthWithValue(10),
          equals('Minimum 10 characters'),
        );
      });

      test('maxLengthWithValue should return formatted message', () {
        expect(
          ValidationMessages.maxLengthWithValue(50),
          equals('Maximum 50 characters'),
        );
        expect(
          ValidationMessages.maxLengthWithValue(100),
          equals('Maximum 100 characters'),
        );
      });

      test('exactLengthWithValue should return formatted message', () {
        expect(
          ValidationMessages.exactLengthWithValue(8),
          equals('Must be exactly 8 characters'),
        );
        expect(
          ValidationMessages.exactLengthWithValue(12),
          equals('Must be exactly 12 characters'),
        );
      });

      test('rangeLength should return formatted message', () {
        expect(
          ValidationMessages.rangeLength(5, 10),
          equals('Must be between 5 and 10 characters'),
        );
        expect(
          ValidationMessages.rangeLength(2, 50),
          equals('Must be between 2 and 50 characters'),
        );
      });
    });
  });
}
