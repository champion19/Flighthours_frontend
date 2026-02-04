import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/core/validators/field_validators.dart';

void main() {
  group('EmailValidator', () {
    late EmailValidator validator;

    setUp(() {
      validator = const EmailValidator();
    });

    test('should return error for empty value', () {
      expect(validator.validate(''), isNotNull);
      expect(validator.validate(null), isNotNull);
    });

    test('should return error for invalid email format', () {
      expect(validator.validate('invalid'), isNotNull);
      expect(validator.validate('invalid@'), isNotNull);
      expect(validator.validate('@invalid.com'), isNotNull);
      expect(validator.validate('no spaces@test.com'), isNotNull);
    });

    test('should return null for valid email', () {
      expect(validator.validate('test@example.com'), isNull);
      expect(validator.validate('user.name@domain.co'), isNull);
      expect(validator.validate('user-name@domain.org'), isNull);
    });
  });

  group('PasswordValidator', () {
    test('should return error for empty value', () {
      const validator = PasswordValidator();
      expect(validator.validate(''), isNotNull);
      expect(validator.validate(null), isNotNull);
    });

    test('should return error for password too short', () {
      const validator = PasswordValidator(minLength: 8);
      expect(validator.validate('Short1'), isNotNull);
    });

    test('should return error for missing uppercase', () {
      const validator = PasswordValidator(requireUppercase: true);
      expect(validator.validate('lowercase123'), isNotNull);
    });

    test('should return error for missing lowercase', () {
      const validator = PasswordValidator(requireLowercase: true);
      expect(validator.validate('UPPERCASE123'), isNotNull);
    });

    test('should return error for missing number', () {
      const validator = PasswordValidator(requireNumber: true);
      expect(validator.validate('NoNumberHere'), isNotNull);
    });

    test('should return error for missing special char when required', () {
      const validator = PasswordValidator(requireSpecialChar: true);
      expect(validator.validate('Password123'), isNotNull);
    });

    test('should return null for valid password', () {
      const validator = PasswordValidator();
      expect(validator.validate('Password123'), isNull);
    });

    test('should accept password with special char when required', () {
      const validator = PasswordValidator(requireSpecialChar: true);
      expect(validator.validate('Password123!'), isNull);
    });
  });

  group('ConfirmPasswordValidator', () {
    test('should return error for empty value', () {
      const validator = ConfirmPasswordValidator('password');
      expect(validator.validate(''), isNotNull);
      expect(validator.validate(null), isNotNull);
    });

    test('should return error for mismatched passwords', () {
      const validator = ConfirmPasswordValidator('password123');
      expect(validator.validate('different'), isNotNull);
    });

    test('should return null for matching passwords', () {
      const validator = ConfirmPasswordValidator('password123');
      expect(validator.validate('password123'), isNull);
    });
  });

  group('NameValidator', () {
    late NameValidator validator;

    setUp(() {
      validator = const NameValidator();
    });

    test('should return error for empty value', () {
      expect(validator.validate(''), isNotNull);
      expect(validator.validate(null), isNotNull);
    });

    test('should return error for name too short', () {
      const shortValidator = NameValidator(minLength: 2);
      expect(shortValidator.validate('A'), isNotNull);
    });

    test('should return error for name too long', () {
      const longValidator = NameValidator(maxLength: 10);
      expect(
        longValidator.validate('Very Long Name That Exceeds Limit'),
        isNotNull,
      );
    });

    test('should return error for invalid characters', () {
      expect(validator.validate('Name123'), isNotNull);
      expect(validator.validate('Name@Special'), isNotNull);
    });

    test('should return null for valid name', () {
      expect(validator.validate('John Doe'), isNull);
      expect(validator.validate('María José'), isNull);
      expect(validator.validate('José Ñoño'), isNull);
    });
  });

  group('IdentityValidator', () {
    late IdentityValidator validator;

    setUp(() {
      validator = const IdentityValidator();
    });

    test('should return error for empty value', () {
      expect(validator.validate(''), isNotNull);
      expect(validator.validate(null), isNotNull);
    });

    test('should return error for non-numeric value', () {
      expect(validator.validate('abc123'), isNotNull);
      expect(validator.validate('12-34-56'), isNotNull);
    });

    test('should return error for too short identity', () {
      const shortValidator = IdentityValidator(minLength: 7);
      expect(shortValidator.validate('12345'), isNotNull);
    });

    test('should return error for too long identity', () {
      const longValidator = IdentityValidator(maxLength: 10);
      expect(longValidator.validate('12345678901234'), isNotNull);
    });

    test('should return null for valid identity', () {
      expect(validator.validate('12345678'), isNull);
      expect(validator.validate('1234567890'), isNull);
    });
  });

  group('PhoneValidator', () {
    late PhoneValidator validator;

    setUp(() {
      validator = const PhoneValidator();
    });

    test('should return error for empty value', () {
      expect(validator.validate(''), isNotNull);
      expect(validator.validate(null), isNotNull);
    });

    test('should return error for invalid phone format', () {
      expect(validator.validate('12345'), isNotNull); // Too short
      expect(
        validator.validate('abc1234567890'),
        isNotNull,
      ); // Contains letters
    });

    test('should return null for valid phone number', () {
      expect(validator.validate('1234567890'), isNull);
      expect(validator.validate('+571234567890'), isNull);
    });
  });
}
