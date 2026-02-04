import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';

void main() {
  group('EmployeeUpdateRequest', () {
    test('should create with required fields', () {
      final request = EmployeeUpdateRequest(
        name: 'John Doe',
        identificationNumber: '12345678',
      );

      expect(request.name, equals('John Doe'));
      expect(request.identificationNumber, equals('12345678'));
    });

    test('toJson should return JSON string', () {
      final request = EmployeeUpdateRequest(
        name: 'John Doe',
        identificationNumber: '12345678',
      );

      final json = request.toJson();
      expect(json, contains('John Doe'));
      expect(json, contains('12345678'));
    });

    test('toMap should return correct map', () {
      final request = EmployeeUpdateRequest(
        name: 'Jane Doe',
        identificationNumber: '87654321',
      );

      final map = request.toMap();
      expect(map['name'], equals('Jane Doe'));
      expect(map['identificationNumber'], equals('87654321'));
    });
  });

  group('EmployeeUpdateResponseModel', () {
    test('fromMap should parse valid response', () {
      final json = {
        'success': true,
        'code': 'OK',
        'message': 'Updated successfully',
        'data': {'id': 'emp123', 'updated': true},
      };

      final model = EmployeeUpdateResponseModel.fromMap(json);

      expect(model.success, isTrue);
      expect(model.code, equals('OK'));
      expect(model.message, equals('Updated successfully'));
      expect(model.data, isNotNull);
      expect(model.data!.id, equals('emp123'));
      expect(model.data!.updated, isTrue);
    });

    test('fromMap should handle missing data', () {
      final json = {'success': false, 'code': 'ERR', 'message': 'Failed'};

      final model = EmployeeUpdateResponseModel.fromMap(json);

      expect(model.success, isFalse);
      expect(model.data, isNull);
    });

    test('fromMap should handle null fields with defaults', () {
      final json = <String, dynamic>{};

      final model = EmployeeUpdateResponseModel.fromMap(json);

      expect(model.success, isFalse);
      expect(model.code, isEmpty);
      expect(model.message, isEmpty);
    });

    test('fromJson should parse JSON string', () {
      const jsonStr = '{"success": true, "code": "OK", "message": "Success"}';

      final model = EmployeeUpdateResponseModel.fromJson(jsonStr);

      expect(model.success, isTrue);
      expect(model.code, equals('OK'));
    });
  });

  group('UpdateResultData', () {
    test('fromMap should parse valid data', () {
      final json = {'id': 'emp123', 'updated': true};

      final data = UpdateResultData.fromMap(json);

      expect(data.id, equals('emp123'));
      expect(data.updated, isTrue);
    });

    test('fromMap should handle null fields with defaults', () {
      final json = <String, dynamic>{};

      final data = UpdateResultData.fromMap(json);

      expect(data.id, isEmpty);
      expect(data.updated, isFalse);
    });
  });
}
