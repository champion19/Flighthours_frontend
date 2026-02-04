import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/core/validators/validator_utils.dart';

void main() {
  group('ValidatorUtils', () {
    group('email', () {
      test('should return EmailValidator', () {
        final validator = ValidatorUtils.email();
        expect(validator.validate('test@example.com'), isNull);
        expect(validator.validate('invalid'), isNotNull);
      });

      test('should accept custom message', () {
        final validator = ValidatorUtils.email(customMessage: 'Custom');
        expect(validator.validate(''), equals('Custom'));
      });
    });

    group('password', () {
      test('should return PasswordValidator with defaults', () {
        final validator = ValidatorUtils.password();
        expect(validator.validate('Password123'), isNull);
      });

      test('should accept custom parameters', () {
        final validator = ValidatorUtils.password(
          minLength: 10,
          requireSpecialChar: true,
        );
        expect(validator.validate('Pass123!'), isNotNull); // Too short
      });
    });

    group('confirmPassword', () {
      test('should return ConfirmPasswordValidator', () {
        final validator = ValidatorUtils.confirmPassword('password123');
        expect(validator.validate('password123'), isNull);
        expect(validator.validate('different'), isNotNull);
      });
    });

    group('name', () {
      test('should return NameValidator with defaults', () {
        final validator = ValidatorUtils.name();
        expect(validator.validate('John Doe'), isNull);
      });

      test('should accept custom minLength and maxLength', () {
        final validator = ValidatorUtils.name(minLength: 3, maxLength: 10);
        expect(validator.validate('AB'), isNotNull); // Too short
      });
    });

    group('identity', () {
      test('should return IdentityValidator with defaults', () {
        final validator = ValidatorUtils.identity();
        expect(validator.validate('12345678'), isNull);
      });

      test('should accept custom minLength and maxLength', () {
        final validator = ValidatorUtils.identity(minLength: 8, maxLength: 12);
        expect(validator.validate('12345'), isNotNull); // Too short
      });
    });

    group('phone', () {
      test('should return PhoneValidator', () {
        final validator = ValidatorUtils.phone();
        expect(validator.validate('1234567890'), isNull);
        expect(validator.validate('12345'), isNotNull);
      });
    });

    group('required', () {
      test('should return RequiredValidator', () {
        final validator = ValidatorUtils.required();
        expect(validator.validate('value'), isNull);
        expect(validator.validate(''), isNotNull);
      });
    });

    group('minLength', () {
      test('should return MinLengthValidator', () {
        final validator = ValidatorUtils.minLength(5);
        expect(validator.validate('hello'), isNull);
        expect(validator.validate('hi'), isNotNull);
      });
    });

    group('maxLength', () {
      test('should return MaxLengthValidator', () {
        final validator = ValidatorUtils.maxLength(5);
        expect(validator.validate('hi'), isNull);
        expect(validator.validate('hello world'), isNotNull);
      });
    });

    group('compose', () {
      test('should return ValidatorComposer', () {
        final validator = ValidatorUtils.compose([
          ValidatorUtils.required(),
          ValidatorUtils.minLength(3),
        ]);
        expect(validator.validate('hello'), isNull);
        expect(validator.validate('ab'), isNotNull);
      });
    });

    group('regex', () {
      test('should return RegexValidator', () {
        final validator = ValidatorUtils.regex(RegExp(r'^[A-Z]+$'));
        expect(validator.validate('ABC'), isNull);
        expect(validator.validate('abc'), isNotNull);
      });
    });
  });
}
