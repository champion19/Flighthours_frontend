import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/register/data/models/register_response_model.dart';

void main() {
  group('RegisterResponseModel', () {
    test('fromMap should parse successful registration response', () {
      // Arrange
      final json = {
        'success': true,
        'code': 'REG_SUCCESS',
        'message': 'Registration completed successfully',
      };

      // Act
      final result = RegisterResponseModel.fromMap(json);

      // Assert
      expect(result.success, isTrue);
      expect(result.code, equals('REG_SUCCESS'));
      expect(result.message, equals('Registration completed successfully'));
    });

    test('fromMap should parse failed registration response', () {
      // Arrange
      final json = {
        'success': false,
        'code': 'EMAIL_EXISTS',
        'message': 'Email already registered',
      };

      // Act
      final result = RegisterResponseModel.fromMap(json);

      // Assert
      expect(result.success, isFalse);
      expect(result.code, equals('EMAIL_EXISTS'));
      expect(result.message, equals('Email already registered'));
    });

    test('fromMap should use defaults for missing fields', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final result = RegisterResponseModel.fromMap(json);

      // Assert
      expect(result.success, isFalse);
      expect(result.code, equals(''));
      expect(result.message, equals(''));
    });

    test('fromJson should parse JSON string correctly', () {
      // Arrange
      const jsonString = '{"success":true,"code":"OK","message":"Done"}';

      // Act
      final result = RegisterResponseModel.fromJson(jsonString);

      // Assert
      expect(result.success, isTrue);
      expect(result.code, equals('OK'));
    });

    test('toMap should serialize correctly', () {
      // Arrange
      final model = RegisterResponseModel(
        success: true,
        code: 'REG_SUCCESS',
        message: 'Registration completed',
      );

      // Act
      final result = model.toMap();

      // Assert
      expect(result['success'], isTrue);
      expect(result['code'], equals('REG_SUCCESS'));
      expect(result['message'], equals('Registration completed'));
    });

    test('toJson should produce valid JSON string', () {
      // Arrange
      final model = RegisterResponseModel(
        success: true,
        code: 'OK',
        message: 'Success',
      );

      // Act
      final result = model.toJson();

      // Assert
      expect(result, contains('"success":true'));
      expect(result, contains('"code":"OK"'));
    });
  });
}
