import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';

void main() {
  group('AirportStatusResponseModel', () {
    test('fromJson should parse success response with data', () {
      final json = {
        'success': true,
        'code': 'MOD_APT_ACTIVATE_EXI_00002',
        'message': 'The airport has been activated successfully',
        'data': {'id': 'airport123', 'status': 'active', 'updated': true},
      };

      final result = AirportStatusResponseModel.fromJson(json);

      expect(result.success, isTrue);
      expect(result.code, equals('MOD_APT_ACTIVATE_EXI_00002'));
      expect(
        result.message,
        equals('The airport has been activated successfully'),
      );
      expect(result.id, equals('airport123'));
      expect(result.status, equals('active'));
      expect(result.updated, isTrue);
    });

    test('fromJson should parse response without data', () {
      final json = {
        'success': false,
        'code': 'ERROR_001',
        'message': 'Operation failed',
      };

      final result = AirportStatusResponseModel.fromJson(json);

      expect(result.success, isFalse);
      expect(result.code, equals('ERROR_001'));
      expect(result.id, isNull);
      expect(result.status, isNull);
      expect(result.updated, isNull);
    });

    test('fromJson should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final result = AirportStatusResponseModel.fromJson(json);

      expect(result.success, isFalse);
      expect(result.code, isEmpty);
      expect(result.message, isEmpty);
    });

    test('fromJsonString should parse JSON string', () {
      const jsonStr =
          '{"success":true,"code":"OK","message":"Done","data":{"id":"456","status":"inactive","updated":true}}';

      final result = AirportStatusResponseModel.fromJsonString(jsonStr);

      expect(result.success, isTrue);
      expect(result.id, equals('456'));
      expect(result.status, equals('inactive'));
    });

    test('fromError should create error response model', () {
      final json = {
        'success': false,
        'code': 'VALIDATION_ERROR',
        'message': 'Invalid operation',
      };

      final result = AirportStatusResponseModel.fromError(json);

      expect(result.success, isFalse);
      expect(result.code, equals('VALIDATION_ERROR'));
      expect(result.message, equals('Invalid operation'));
    });

    test('fromError should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final result = AirportStatusResponseModel.fromError(json);

      expect(result.success, isFalse);
      expect(result.code, equals('UNKNOWN_ERROR'));
      expect(result.message, equals('An unknown error occurred'));
    });
  });
}
