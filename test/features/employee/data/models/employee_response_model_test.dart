import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_response_model.dart';

void main() {
  group('EmployeeResponseModel', () {
    test('fromMap should parse valid JSON correctly', () {
      // Arrange
      final json = {
        'success': true,
        'code': 'EMP_SUCCESS',
        'message': 'Employee retrieved successfully',
        'data': {
          'id': '12345',
          'name': 'John Doe',
          'email': 'john@example.com',
          'airline': 'Avianca',
          'identification_number': '123456789',
          'bp': 'BP001',
          'start_date': '2024-01-01',
          'end_date': '2025-01-01',
          'active': true,
          'role': 'pilot',
        },
      };

      // Act
      final result = EmployeeResponseModel.fromMap(json);

      // Assert
      expect(result.success, isTrue);
      expect(result.code, equals('EMP_SUCCESS'));
      expect(result.message, equals('Employee retrieved successfully'));
      expect(result.data, isNotNull);
      expect(result.data!.id, equals('12345'));
      expect(result.data!.name, equals('John Doe'));
      expect(result.data!.email, equals('john@example.com'));
      expect(result.data!.airline, equals('Avianca'));
      expect(result.data!.identificationNumber, equals('123456789'));
      expect(result.data!.bp, equals('BP001'));
      expect(result.data!.active, isTrue);
      expect(result.data!.role, equals('pilot'));
    });

    test('fromMap should handle missing optional fields', () {
      // Arrange
      final json = {
        'success': true,
        'code': 'EMP_SUCCESS',
        'message': 'Employee retrieved',
        'data': {
          'id': '12345',
          'name': 'John Doe',
          'email': 'john@example.com',
        },
      };

      // Act
      final result = EmployeeResponseModel.fromMap(json);

      // Assert
      expect(result.data, isNotNull);
      expect(result.data!.airline, isNull);
      expect(result.data!.identificationNumber, isNull);
      expect(result.data!.bp, isNull);
      expect(result.data!.startDate, isNull);
      expect(result.data!.endDate, isNull);
      expect(result.data!.role, isNull);
      expect(result.data!.active, isTrue); // default value
    });

    test('fromMap should handle null data', () {
      // Arrange
      final json = {
        'success': false,
        'code': 'EMP_NOT_FOUND',
        'message': 'Employee not found',
        'data': null,
      };

      // Act
      final result = EmployeeResponseModel.fromMap(json);

      // Assert
      expect(result.success, isFalse);
      expect(result.code, equals('EMP_NOT_FOUND'));
      expect(result.data, isNull);
    });

    test('fromMap should handle missing fields with defaults', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final result = EmployeeResponseModel.fromMap(json);

      // Assert
      expect(result.success, isFalse);
      expect(result.code, equals(''));
      expect(result.message, equals(''));
      expect(result.data, isNull);
    });

    test('fromJson should parse JSON string correctly', () {
      // Arrange
      const jsonString =
          '{"success":true,"code":"OK","message":"Success","data":{"id":"1","name":"Test","email":"test@test.com"}}';

      // Act
      final result = EmployeeResponseModel.fromJson(jsonString);

      // Assert
      expect(result.success, isTrue);
      expect(result.data!.id, equals('1'));
      expect(result.data!.name, equals('Test'));
    });
  });

  group('EmployeeData', () {
    test('fromMap should parse dates correctly', () {
      // Arrange
      final json = {
        'id': '1',
        'name': 'Test',
        'email': 'test@test.com',
        'start_date': '2024-06-15',
        'end_date': '2025-06-15',
      };

      // Act
      final result = EmployeeData.fromMap(json);

      // Assert
      expect(result.startDate, isNotNull);
      expect(result.startDate!.year, equals(2024));
      expect(result.startDate!.month, equals(6));
      expect(result.startDate!.day, equals(15));
      expect(result.endDate, isNotNull);
    });

    test('toMap should serialize correctly', () {
      // Arrange
      final employee = EmployeeData(
        id: '123',
        name: 'John Doe',
        email: 'john@example.com',
        airline: 'Avianca',
        identificationNumber: '987654321',
        bp: 'BP002',
        active: true,
        role: 'pilot',
      );

      // Act
      final result = employee.toMap();

      // Assert
      expect(result['id'], equals('123'));
      expect(result['name'], equals('John Doe'));
      expect(result['email'], equals('john@example.com'));
      expect(result['airline'], equals('Avianca'));
      expect(result['identification_number'], equals('987654321'));
      expect(result['bp'], equals('BP002'));
      expect(result['active'], isTrue);
      expect(result['role'], equals('pilot'));
    });

    test('fromMap should handle invalid date format', () {
      // Arrange
      final json = {
        'id': '1',
        'name': 'Test',
        'email': 'test@test.com',
        'start_date': 'invalid-date',
      };

      // Act
      final result = EmployeeData.fromMap(json);

      // Assert
      expect(result.startDate, isNull); // DateTime.tryParse returns null
    });
  });
}
