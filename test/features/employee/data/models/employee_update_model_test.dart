import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';

void main() {
  group('EmployeeUpdateRequest', () {
    test('should create request with required fields', () {
      final request = EmployeeUpdateRequest(
        name: 'John Doe',
        identificationNumber: '123456789',
      );

      expect(request.name, equals('John Doe'));
      expect(request.identificationNumber, equals('123456789'));
    });

    test('toMap should return correct map', () {
      final request = EmployeeUpdateRequest(
        name: 'Jane Doe',
        identificationNumber: '987654321',
      );

      final map = request.toMap();

      expect(map['name'], equals('Jane Doe'));
      expect(map['identificationNumber'], equals('987654321'));
    });

    test('toJson should return valid JSON string', () {
      final request = EmployeeUpdateRequest(
        name: 'Test User',
        identificationNumber: 'ABC123',
      );

      final json = request.toJson();

      expect(json, contains('"name":"Test User"'));
      expect(json, contains('"identificationNumber":"ABC123"'));
    });
  });

  group('EmployeeUpdateResponseModel', () {
    test('fromMap should parse success response', () {
      final json = {
        'success': true,
        'code': 'UPDATE_SUCCESS',
        'message': 'Employee updated successfully',
        'data': {'id': 'emp123', 'updated': true},
      };

      final result = EmployeeUpdateResponseModel.fromMap(json);

      expect(result.success, isTrue);
      expect(result.code, equals('UPDATE_SUCCESS'));
      expect(result.message, equals('Employee updated successfully'));
      expect(result.data, isNotNull);
      expect(result.data!.id, equals('emp123'));
      expect(result.data!.updated, isTrue);
    });

    test('fromMap should handle null data', () {
      final json = {
        'success': false,
        'code': 'UPDATE_FAILED',
        'message': 'Update failed',
      };

      final result = EmployeeUpdateResponseModel.fromMap(json);

      expect(result.success, isFalse);
      expect(result.data, isNull);
    });

    test('fromMap should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final result = EmployeeUpdateResponseModel.fromMap(json);

      expect(result.success, isFalse);
      expect(result.code, isEmpty);
      expect(result.message, isEmpty);
    });

    test('fromJson should parse JSON string', () {
      const jsonStr =
          '{"success":true,"code":"OK","message":"Success","data":{"id":"123","updated":true}}';

      final result = EmployeeUpdateResponseModel.fromJson(jsonStr);

      expect(result.success, isTrue);
      expect(result.data!.id, equals('123'));
    });
  });

  group('UpdateResultData', () {
    test('fromMap should parse correctly', () {
      final json = {'id': 'emp456', 'updated': true};

      final result = UpdateResultData.fromMap(json);

      expect(result.id, equals('emp456'));
      expect(result.updated, isTrue);
    });

    test('fromMap should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final result = UpdateResultData.fromMap(json);

      expect(result.id, isEmpty);
      expect(result.updated, isFalse);
    });
  });
}
