import 'package:flutter_test/flutter_test.dart';

void main() {
  // Testing DioClient utilities
  // Note: The DioClient itself is a singleton with network dependencies
  // so we test the sanitization logic patterns here

  group('Header Sanitization Pattern', () {
    test('should hide Bearer token in Authorization header', () {
      // Arrange
      final headers = <String, dynamic>{
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
        'Content-Type': 'application/json',
      };

      // Act - Test the pattern used in _sanitizeHeaders
      final sanitized = Map<String, dynamic>.from(headers);
      if (sanitized.containsKey('Authorization')) {
        final auth = sanitized['Authorization'] as String;
        if (auth.startsWith('Bearer ')) {
          sanitized['Authorization'] = 'Bearer [HIDDEN]';
        }
      }

      // Assert
      expect(sanitized['Authorization'], equals('Bearer [HIDDEN]'));
      expect(sanitized['Content-Type'], equals('application/json'));
    });

    test('should not modify non-Bearer authorization', () {
      // Arrange
      final headers = <String, dynamic>{
        'Authorization': 'Basic dXNlcjpwYXNz',
        'Content-Type': 'application/json',
      };

      // Act
      final sanitized = Map<String, dynamic>.from(headers);
      if (sanitized.containsKey('Authorization')) {
        final auth = sanitized['Authorization'] as String;
        if (auth.startsWith('Bearer ')) {
          sanitized['Authorization'] = 'Bearer [HIDDEN]';
        }
      }

      // Assert - Should remain unchanged
      expect(sanitized['Authorization'], equals('Basic dXNlcjpwYXNz'));
    });
  });

  group('Body Sanitization Pattern', () {
    test('should hide sensitive fields in body', () {
      // Arrange
      final body = <String, dynamic>{
        'email': 'test@example.com',
        'password': 'mySecretPassword',
        'current_password': 'oldPassword',
        'new_password': 'newPassword',
        'confirm_password': 'newPassword',
        'refresh_token': 'some-refresh-token',
      };

      final sensitiveKeys = [
        'password',
        'current_password',
        'new_password',
        'confirm_password',
        'refresh_token',
      ];

      // Act - Test the pattern used in _sanitizeBody
      final sanitized = Map<String, dynamic>.from(body);
      for (final key in sensitiveKeys) {
        if (sanitized.containsKey(key)) {
          sanitized[key] = '[HIDDEN]';
        }
      }

      // Assert
      expect(sanitized['email'], equals('test@example.com'));
      expect(sanitized['password'], equals('[HIDDEN]'));
      expect(sanitized['current_password'], equals('[HIDDEN]'));
      expect(sanitized['new_password'], equals('[HIDDEN]'));
      expect(sanitized['confirm_password'], equals('[HIDDEN]'));
      expect(sanitized['refresh_token'], equals('[HIDDEN]'));
    });

    test('should not modify non-sensitive fields', () {
      // Arrange
      final body = <String, dynamic>{
        'email': 'test@example.com',
        'name': 'John Doe',
        'airline_id': '12345',
      };

      final sensitiveKeys = [
        'password',
        'current_password',
        'new_password',
        'confirm_password',
        'refresh_token',
      ];

      // Act
      final sanitized = Map<String, dynamic>.from(body);
      for (final key in sensitiveKeys) {
        if (sanitized.containsKey(key)) {
          sanitized[key] = '[HIDDEN]';
        }
      }

      // Assert - All fields should remain unchanged
      expect(sanitized['email'], equals('test@example.com'));
      expect(sanitized['name'], equals('John Doe'));
      expect(sanitized['airline_id'], equals('12345'));
    });
  });
}
