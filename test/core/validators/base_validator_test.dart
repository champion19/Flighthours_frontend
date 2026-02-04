import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/core/validators/base_validator.dart';
import 'package:flight_hours_app/core/validators/validators.dart';

void main() {
  group('RequiredValidator', () {
    late RequiredValidator validator;

    setUp(() {
      validator = const RequiredValidator();
    });

    test('should return error for null value', () {
      expect(validator.validate(null), isNotNull);
    });

    test('should return error for empty string', () {
      expect(validator.validate(''), isNotNull);
    });

    test('should return error for whitespace only', () {
      expect(validator.validate('   '), isNotNull);
    });

    test('should return null for non-empty value', () {
      expect(validator.validate('value'), isNull);
    });

    test('should use custom message when provided', () {
      final customValidator = const RequiredValidator(
        customMessage: 'Custom error',
      );
      final result = customValidator.validate('');
      expect(result, equals('Custom error'));
    });
  });

  group('MinLengthValidator', () {
    test('should return error for null value', () {
      const validator = MinLengthValidator(5);
      expect(validator.validate(null), isNotNull);
    });

    test('should return error for value shorter than minLength', () {
      const validator = MinLengthValidator(5);
      expect(validator.validate('abc'), isNotNull);
    });

    test('should return null for value at minLength', () {
      const validator = MinLengthValidator(5);
      expect(validator.validate('abcde'), isNull);
    });

    test('should return null for value longer than minLength', () {
      const validator = MinLengthValidator(5);
      expect(validator.validate('abcdefg'), isNull);
    });
  });

  group('MaxLengthValidator', () {
    test('should return null for null value', () {
      const validator = MaxLengthValidator(5);
      expect(validator.validate(null), isNull);
    });

    test('should return error for value longer than maxLength', () {
      const validator = MaxLengthValidator(5);
      expect(validator.validate('abcdefg'), isNotNull);
    });

    test('should return null for value at maxLength', () {
      const validator = MaxLengthValidator(5);
      expect(validator.validate('abcde'), isNull);
    });

    test('should return null for value shorter than maxLength', () {
      const validator = MaxLengthValidator(5);
      expect(validator.validate('abc'), isNull);
    });
  });

  group('RegexValidator', () {
    test('should return null for null value', () {
      final validator = RegexValidator(RegExp(r'^[0-9]+$'));
      expect(validator.validate(null), isNull);
    });

    test('should return error for value not matching pattern', () {
      final validator = RegexValidator(RegExp(r'^[0-9]+$'));
      expect(validator.validate('abc'), isNotNull);
    });

    test('should return null for value matching pattern', () {
      final validator = RegexValidator(RegExp(r'^[0-9]+$'));
      expect(validator.validate('12345'), isNull);
    });
  });

  group('ValidatorComposer', () {
    test('should return null when all validators pass', () {
      const composer = ValidatorComposer([
        RequiredValidator(),
        MinLengthValidator(3),
      ]);

      expect(composer.validate('hello'), isNull);
    });

    test('should return first error when first validator fails', () {
      const composer = ValidatorComposer([
        RequiredValidator(),
        MinLengthValidator(3),
      ]);

      expect(composer.validate(''), isNotNull);
    });

    test('should return second error when second validator fails', () {
      const composer = ValidatorComposer([
        RequiredValidator(),
        MinLengthValidator(5),
      ]);

      expect(composer.validate('ab'), isNotNull);
    });

    test('should return null for empty validators list', () {
      const composer = ValidatorComposer([]);
      expect(composer.validate('anything'), isNull);
    });
  });
}
