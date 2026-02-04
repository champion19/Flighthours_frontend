import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/employee/data/models/change_password_model.dart';

void main() {
  group('ChangePasswordRequest', () {
    test('toMap should serialize correctly', () {
      // Arrange
      final request = ChangePasswordRequest(
        email: 'test@example.com',
        currentPassword: 'oldPass123',
        newPassword: 'newPass456',
        confirmPassword: 'newPass456',
      );

      // Act
      final result = request.toMap();

      // Assert
      expect(result['email'], equals('test@example.com'));
      expect(result['current_password'], equals('oldPass123'));
      expect(result['new_password'], equals('newPass456'));
      expect(result['confirm_password'], equals('newPass456'));
    });

    test('toJson should produce valid JSON string', () {
      // Arrange
      final request = ChangePasswordRequest(
        email: 'test@example.com',
        currentPassword: 'oldPass123',
        newPassword: 'newPass456',
        confirmPassword: 'newPass456',
      );

      // Act
      final result = request.toJson();

      // Assert
      expect(result, contains('"email":"test@example.com"'));
      expect(result, contains('"current_password":"oldPass123"'));
      expect(result, contains('"new_password":"newPass456"'));
    });
  });

  group('ChangePasswordResponseModel', () {
    test('fromMap should parse success response correctly', () {
      // Arrange
      final json = {
        'success': true,
        'code': 'PWD_CHANGED',
        'message': 'Password changed successfully',
        'data': {'changed': true, 'email': 'test@example.com'},
      };

      // Act
      final result = ChangePasswordResponseModel.fromMap(json);

      // Assert
      expect(result.success, isTrue);
      expect(result.code, equals('PWD_CHANGED'));
      expect(result.data, isNotNull);
      expect(result.data!.changed, isTrue);
      expect(result.data!.email, equals('test@example.com'));
    });

    test('fromMap should handle error response', () {
      // Arrange
      final json = {
        'success': false,
        'code': 'PWD_INVALID',
        'message': 'Current password is incorrect',
        'data': null,
      };

      // Act
      final result = ChangePasswordResponseModel.fromMap(json);

      // Assert
      expect(result.success, isFalse);
      expect(result.code, equals('PWD_INVALID'));
      expect(result.data, isNull);
    });

    test('fromJson should parse JSON string correctly', () {
      // Arrange
      const jsonString =
          '{"success":true,"code":"OK","message":"Done","data":{"changed":true,"email":"test@test.com"}}';

      // Act
      final result = ChangePasswordResponseModel.fromJson(jsonString);

      // Assert
      expect(result.success, isTrue);
      expect(result.data!.changed, isTrue);
    });
  });

  group('ChangePasswordData', () {
    test('fromMap should parse correctly', () {
      // Arrange
      final json = {'changed': true, 'email': 'test@example.com'};

      // Act
      final result = ChangePasswordData.fromMap(json);

      // Assert
      expect(result.changed, isTrue);
      expect(result.email, equals('test@example.com'));
    });

    test('fromMap should use defaults for missing fields', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final result = ChangePasswordData.fromMap(json);

      // Assert
      expect(result.changed, isFalse);
      expect(result.email, equals(''));
    });
  });
}
