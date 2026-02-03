import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/employee/data/models/delete_employee_model.dart';

void main() {
  group('DeleteEmployeeResponseModel', () {
    test('fromMap should parse success response', () {
      final json = {
        'success': true,
        'code': 'DELETE_SUCCESS',
        'message': 'Employee deleted successfully',
      };

      final result = DeleteEmployeeResponseModel.fromMap(json);

      expect(result.success, isTrue);
      expect(result.code, equals('DELETE_SUCCESS'));
      expect(result.message, equals('Employee deleted successfully'));
    });

    test('fromMap should parse error response', () {
      final json = {
        'success': false,
        'code': 'DELETE_FAILED',
        'message': 'Cannot delete employee',
      };

      final result = DeleteEmployeeResponseModel.fromMap(json);

      expect(result.success, isFalse);
      expect(result.code, equals('DELETE_FAILED'));
    });

    test('fromMap should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final result = DeleteEmployeeResponseModel.fromMap(json);

      expect(result.success, isFalse);
      expect(result.code, isEmpty);
      expect(result.message, isEmpty);
    });

    test('fromJson should parse JSON string', () {
      const jsonStr = '{"success":true,"code":"OK","message":"Deleted"}';

      final result = DeleteEmployeeResponseModel.fromJson(jsonStr);

      expect(result.success, isTrue);
      expect(result.code, equals('OK'));
      expect(result.message, equals('Deleted'));
    });
  });
}
