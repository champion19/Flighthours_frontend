import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/login/data/models/login_response_model.dart';

void main() {
  group('LoginResponseModel', () {
    test('fromMap should parse successful login response', () {
      // Arrange
      final json = {
        'success': true,
        'code': 'AUTH_SUCCESS',
        'message': 'Login successful',
        'data': {
          'access_token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
          'refresh_token': 'refresh_token_123',
          'expires_in': 3600,
          'token_type': 'Bearer',
          'employee_id': 'EMP123',
        },
      };

      // Act
      final result = LoginResponseModel.fromMap(json);

      // Assert
      expect(result.success, isTrue);
      expect(result.code, equals('AUTH_SUCCESS'));
      expect(result.message, equals('Login successful'));
      expect(result.data, isNotNull);
      expect(result.data!.accessToken, startsWith('eyJhbGciOiJ'));
      expect(result.data!.refreshToken, equals('refresh_token_123'));
      expect(result.data!.expiresIn, equals(3600));
      expect(result.data!.tokenType, equals('Bearer'));
      expect(result.data!.employeeId, equals('EMP123'));
    });

    test('fromMap should parse failed login response', () {
      // Arrange
      final json = {
        'success': false,
        'code': 'AUTH_FAILED',
        'message': 'Invalid credentials',
        'data': null,
      };

      // Act
      final result = LoginResponseModel.fromMap(json);

      // Assert
      expect(result.success, isFalse);
      expect(result.code, equals('AUTH_FAILED'));
      expect(result.data, isNull);
    });

    test('fromJson should parse JSON string correctly', () {
      // Arrange
      const jsonString =
          '{"success":true,"code":"OK","message":"Done","data":{"access_token":"token","refresh_token":"refresh","expires_in":3600,"token_type":"Bearer"}}';

      // Act
      final result = LoginResponseModel.fromJson(jsonString);

      // Assert
      expect(result.success, isTrue);
      expect(result.data!.accessToken, equals('token'));
    });

    test('toMap and toJson should serialize correctly', () {
      // Arrange
      final model = LoginResponseModel(
        success: true,
        code: 'OK',
        message: 'Success',
        data: TokenData(
          accessToken: 'token123',
          refreshToken: 'refresh456',
          expiresIn: 3600,
          tokenType: 'Bearer',
        ),
      );

      // Act
      final map = model.toMap();
      final jsonStr = model.toJson();

      // Assert
      expect(map['success'], isTrue);
      expect(map['data']['access_token'], equals('token123'));
      expect(jsonStr, contains('"access_token":"token123"'));
    });
  });

  group('TokenData', () {
    test('fromMap should parse all fields correctly', () {
      // Arrange
      final json = {
        'access_token': 'access123',
        'refresh_token': 'refresh456',
        'expires_in': 7200,
        'token_type': 'Bearer',
        'employee_id': 'EMP789',
      };

      // Act
      final result = TokenData.fromMap(json);

      // Assert
      expect(result.accessToken, equals('access123'));
      expect(result.refreshToken, equals('refresh456'));
      expect(result.expiresIn, equals(7200));
      expect(result.tokenType, equals('Bearer'));
      expect(result.employeeId, equals('EMP789'));
    });

    test('fromMap should use defaults for missing fields', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final result = TokenData.fromMap(json);

      // Assert
      expect(result.accessToken, equals(''));
      expect(result.refreshToken, equals(''));
      expect(result.expiresIn, equals(0));
      expect(result.tokenType, equals('Bearer'));
      expect(result.employeeId, isNull);
    });

    test('toMap should serialize correctly', () {
      // Arrange
      final tokenData = TokenData(
        accessToken: 'token',
        refreshToken: 'refresh',
        expiresIn: 3600,
        tokenType: 'Bearer',
        employeeId: 'EMP001',
      );

      // Act
      final result = tokenData.toMap();

      // Assert
      expect(result['access_token'], equals('token'));
      expect(result['refresh_token'], equals('refresh'));
      expect(result['expires_in'], equals(3600));
      expect(result['employee_id'], equals('EMP001'));
    });
  });
}
