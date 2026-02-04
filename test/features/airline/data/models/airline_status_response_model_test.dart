import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';

void main() {
  group('AirlineStatusResponseModel', () {
    test('fromJson should parse success response with data', () {
      final json = {
        'success': true,
        'code': 'MOD_AIR_ACTIVATE_EXI_00002',
        'message': 'The airline has been activated successfully',
        'data': {'id': 'airline123', 'status': 'active', 'updated': true},
      };

      final result = AirlineStatusResponseModel.fromJson(json);

      expect(result.success, isTrue);
      expect(result.code, equals('MOD_AIR_ACTIVATE_EXI_00002'));
      expect(
        result.message,
        equals('The airline has been activated successfully'),
      );
      expect(result.id, equals('airline123'));
      expect(result.status, equals('active'));
      expect(result.updated, isTrue);
    });

    test('fromJson should parse response without data', () {
      final json = {
        'success': false,
        'code': 'ERROR_001',
        'message': 'Operation failed',
      };

      final result = AirlineStatusResponseModel.fromJson(json);

      expect(result.success, isFalse);
      expect(result.code, equals('ERROR_001'));
      expect(result.id, isNull);
      expect(result.status, isNull);
      expect(result.updated, isNull);
    });

    test('fromJson should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final result = AirlineStatusResponseModel.fromJson(json);

      expect(result.success, isFalse);
      expect(result.code, isEmpty);
      expect(result.message, isEmpty);
    });

    test('fromJsonString should parse JSON string', () {
      const jsonStr =
          '{"success":true,"code":"OK","message":"Done","data":{"id":"123","status":"active","updated":true}}';

      final result = AirlineStatusResponseModel.fromJsonString(jsonStr);

      expect(result.success, isTrue);
      expect(result.id, equals('123'));
      expect(result.status, equals('active'));
    });

    test('fromError should create error response model', () {
      final json = {
        'success': false,
        'code': 'SERVER_ERROR',
        'message': 'Internal server error',
      };

      final result = AirlineStatusResponseModel.fromError(json);

      expect(result.success, isFalse);
      expect(result.code, equals('SERVER_ERROR'));
      expect(result.message, equals('Internal server error'));
    });

    test('fromError should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final result = AirlineStatusResponseModel.fromError(json);

      expect(result.success, isFalse);
      expect(result.code, equals('UNKNOWN_ERROR'));
      expect(result.message, equals('An unknown error occurred'));
    });

    test('fromJson should handle deactivate success', () {
      final json = {
        'success': true,
        'code': 'MOD_AIR_DEACTIVATE_00001',
        'message': 'The airline has been deactivated',
        'data': {'id': 'airline456', 'status': 'inactive', 'updated': true},
      };

      final result = AirlineStatusResponseModel.fromJson(json);

      expect(result.status, equals('inactive'));
      expect(result.updated, isTrue);
    });
  });
}
