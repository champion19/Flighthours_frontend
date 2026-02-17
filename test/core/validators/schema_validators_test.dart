import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/core/validators/field_validators.dart';
import 'package:flight_hours_app/core/constants/schema_constants.dart';

void main() {
  // ════════════════════════════════════════════════════════════════
  // Tests para CAMBIOS en validators existentes (alineación backend)
  // ════════════════════════════════════════════════════════════════

  group('EmailValidator — maxLength (backend: 150)', () {
    const validator = EmailValidator();

    test('should reject email longer than 150 characters', () {
      final longEmail = '${'a' * 140}@test.com'; // 149 chars ok
      final tooLongEmail = '${'a' * 145}@test.com'; // > 150 chars
      expect(validator.validate(longEmail), isNull);
      expect(validator.validate(tooLongEmail), isNotNull);
    });

    test('should accept email at exactly 150 characters', () {
      // 140 + @ + test + . + com = 140 + 9 = 149 (within limit)
      final email = '${'a' * 140}@test.com';
      expect(validator.validate(email), isNull);
    });
  });

  group('PasswordValidator — maxLength (backend: 64 for register)', () {
    const validator = PasswordValidator(); // default max 64

    test('should reject password longer than 64 characters', () {
      final longPassword = 'Aa1${'x' * 62}'; // 65 chars
      expect(validator.validate(longPassword), isNotNull);
    });

    test('should accept password at exactly 64 characters', () {
      final password = 'Aa1${'x' * 61}'; // 64 chars
      expect(validator.validate(password), isNull);
    });

    test('should use login maxLength 128 when specified', () {
      const loginValidator = PasswordValidator(
        minLength: SchemaConstants.loginPasswordMinLength,
        maxLength: SchemaConstants.loginPasswordMaxLength,
        requireUppercase: false,
        requireLowercase: false,
        requireNumber: false,
      );
      final password100 = 'x' * 100; // within 128
      final password130 = 'x' * 130; // exceeds 128
      expect(loginValidator.validate(password100), isNull);
      expect(loginValidator.validate(password130), isNotNull);
    });
  });

  group('IdentityValidator — maxLength 10, digits only (backend)', () {
    const validator = IdentityValidator();

    test('should reject ID longer than 10 digits', () {
      expect(validator.validate('12345678901'), isNotNull); // 11 digits
    });

    test('should accept ID with exactly 10 digits', () {
      expect(validator.validate('1234567890'), isNull);
    });

    test('should reject non-digit characters', () {
      expect(validator.validate('1234567a'), isNotNull);
      expect(validator.validate('12-34567'), isNotNull);
      expect(validator.validate('1234 567'), isNotNull);
    });

    test('should accept valid 7-10 digit IDs', () {
      expect(validator.validate('1234567'), isNull); // min: 7
      expect(validator.validate('12345678'), isNull);
      expect(validator.validate('1234567890'), isNull); // max: 10
    });
  });

  // ════════════════════════════════════════════════════════════════
  // Tests para NUEVOS validators
  // ════════════════════════════════════════════════════════════════

  group('NumericOnlyValidator', () {
    const validator = NumericOnlyValidator();

    test('should accept null and empty (optional)', () {
      expect(validator.validate(null), isNull);
      expect(validator.validate(''), isNull);
    });

    test('should accept digits only', () {
      expect(validator.validate('12345'), isNull);
      expect(validator.validate('0'), isNull);
    });

    test('should reject letters', () {
      expect(validator.validate('abc'), isNotNull);
      expect(validator.validate('123abc'), isNotNull);
    });

    test('should reject special characters', () {
      expect(validator.validate('12-34'), isNotNull);
      expect(validator.validate('12.34'), isNotNull);
      expect(validator.validate('+12'), isNotNull);
    });
  });

  group('LicensePlateValidator (max 7, ^[A-Z0-9-]+\$)', () {
    const validator = LicensePlateValidator();

    test('should require a value (not optional)', () {
      expect(validator.validate(null), isNotNull);
      expect(validator.validate(''), isNotNull);
    });

    test('should accept valid plates', () {
      expect(validator.validate('HK-5432'), isNull); // 7 chars
      expect(validator.validate('CC-BFA'), isNull); // 6 chars
      expect(validator.validate('N123AB'), isNull);
    });

    test('should reject plates longer than 7 characters', () {
      expect(validator.validate('HK-54321'), isNotNull); // 8 chars
    });

    test('should reject lowercase letters', () {
      expect(validator.validate('hk-5432'), isNotNull);
    });

    test('should reject special characters other than hyphen', () {
      expect(validator.validate('HK_5432'), isNotNull);
      expect(validator.validate('HK.543'), isNotNull);
      expect(validator.validate('HK 543'), isNotNull);
    });
  });

  group('FlightNumberValidator (required, max 20)', () {
    const validator = FlightNumberValidator();

    test('should require a value', () {
      expect(validator.validate(null), isNotNull);
      expect(validator.validate(''), isNotNull);
    });

    test('should accept valid flight numbers', () {
      expect(validator.validate('AV123'), isNull);
      expect(validator.validate('LA4567'), isNull);
      expect(validator.validate('12345678901234567890'), isNull); // 20 chars
    });

    test('should reject flight numbers longer than 20', () {
      expect(
        validator.validate('123456789012345678901'), // 21 chars
        isNotNull,
      );
    });
  });

  group('CompanionNameValidator (optional, max 100)', () {
    const validator = CompanionNameValidator();

    test('should accept null and empty (optional)', () {
      expect(validator.validate(null), isNull);
      expect(validator.validate(''), isNull);
    });

    test('should accept names up to 100 characters', () {
      expect(validator.validate('Juan Pérez'), isNull);
      expect(validator.validate('a' * 100), isNull);
    });

    test('should reject names longer than 100 characters', () {
      expect(validator.validate('a' * 101), isNotNull);
    });
  });

  group('BpValidator (optional, max 16)', () {
    const validator = BpValidator();

    test('should accept null and empty (optional)', () {
      expect(validator.validate(null), isNull);
      expect(validator.validate(''), isNull);
    });

    test('should accept BP codes up to 16 characters', () {
      expect(validator.validate('BP001'), isNull);
      expect(validator.validate('1234567890123456'), isNull); // 16 chars
    });

    test('should reject BP codes longer than 16 characters', () {
      expect(validator.validate('12345678901234567'), isNotNull); // 17
    });
  });

  group('PassengersValidator (optional, integer >= 0)', () {
    const validator = PassengersValidator();

    test('should accept null and empty (optional)', () {
      expect(validator.validate(null), isNull);
      expect(validator.validate(''), isNull);
      expect(validator.validate('  '), isNull);
    });

    test('should accept zero and positive integers', () {
      expect(validator.validate('0'), isNull);
      expect(validator.validate('1'), isNull);
      expect(validator.validate('150'), isNull);
      expect(validator.validate('999'), isNull);
    });

    test('should reject negative numbers', () {
      expect(validator.validate('-1'), isNotNull);
      expect(validator.validate('-10'), isNotNull);
    });

    test('should reject non-integer values', () {
      expect(validator.validate('abc'), isNotNull);
      expect(validator.validate('12.5'), isNotNull);
    });
  });

  group('TimeFieldValidator (optional, ^\\d{2}:\\d{2}\$)', () {
    const validator = TimeFieldValidator();

    test('should accept null and empty (optional)', () {
      expect(validator.validate(null), isNull);
      expect(validator.validate(''), isNull);
      expect(validator.validate('  '), isNull);
    });

    test('should accept valid HH:MM format', () {
      expect(validator.validate('00:00'), isNull);
      expect(validator.validate('23:59'), isNull);
      expect(validator.validate('12:30'), isNull);
      expect(validator.validate('09:05'), isNull);
    });

    test('should reject invalid formats', () {
      expect(validator.validate('9:30'), isNotNull); // single digit hour
      expect(validator.validate('12:5'), isNotNull); // single digit minute
      expect(validator.validate('1230'), isNotNull); // no colon
      expect(validator.validate('12:30:00'), isNotNull); // too long
      expect(validator.validate('ab:cd'), isNotNull); // letters
    });
  });

  group('BookPageValidator (optional, integer >= 1)', () {
    const validator = BookPageValidator();

    test('should accept null and empty (optional)', () {
      expect(validator.validate(null), isNull);
      expect(validator.validate(''), isNull);
      expect(validator.validate('  '), isNull);
    });

    test('should accept positive integers', () {
      expect(validator.validate('1'), isNull);
      expect(validator.validate('50'), isNull);
      expect(validator.validate('999'), isNull);
    });

    test('should reject zero', () {
      expect(validator.validate('0'), isNotNull);
    });

    test('should reject negative numbers', () {
      expect(validator.validate('-1'), isNotNull);
    });

    test('should reject non-integer values', () {
      expect(validator.validate('abc'), isNotNull);
      expect(validator.validate('1.5'), isNotNull);
    });
  });

  // ════════════════════════════════════════════════════════════════
  // Tests para SchemaConstants (verificar valores del backend)
  // ════════════════════════════════════════════════════════════════

  group('SchemaConstants — values match backend JSON schemas', () {
    test('email constraints match login/register schemas', () {
      expect(SchemaConstants.emailMinLength, 5);
      expect(SchemaConstants.emailMaxLength, 150);
    });

    test('password constraints match schemas', () {
      expect(SchemaConstants.loginPasswordMaxLength, 128);
      expect(SchemaConstants.passwordMinLength, 8);
      expect(SchemaConstants.passwordMaxLength, 64);
    });

    test('identification constraints match register/update schemas', () {
      expect(SchemaConstants.identificationMinLength, 7);
      expect(SchemaConstants.identificationMaxLength, 10);
    });

    test('license plate constraints match schema', () {
      expect(SchemaConstants.licensePlateMaxLength, 7);
      expect(SchemaConstants.licensePlatePattern.hasMatch('HK-5432'), isTrue);
      expect(SchemaConstants.licensePlatePattern.hasMatch('hk-5432'), isFalse);
    });

    test('logbook detail constraints match schema', () {
      expect(SchemaConstants.flightNumberMaxLength, 20);
      expect(SchemaConstants.companionNameMaxLength, 100);
      expect(SchemaConstants.passengersMinimum, 0);
      expect(SchemaConstants.timePattern.hasMatch('12:30'), isTrue);
      expect(SchemaConstants.timePattern.hasMatch('1230'), isFalse);
    });

    test('airline employee bp constraint matches schema', () {
      expect(SchemaConstants.bpMaxLength, 16);
    });
  });
}
