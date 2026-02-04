import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';

void main() {
  group('AirlineStatusResponseModel', () {
    test('fromJson should parse valid response with data', () {
      final json = {
        'success': true,
        'code': 'MOD_AIR_ACTIVATE_EXI_00002',
        'message': 'The airline has been activated successfully',
        'data': {'id': 'airline123', 'status': 'active', 'updated': true},
      };

      final model = AirlineStatusResponseModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.code, equals('MOD_AIR_ACTIVATE_EXI_00002'));
      expect(model.message, contains('activated'));
      expect(model.id, equals('airline123'));
      expect(model.status, equals('active'));
      expect(model.updated, isTrue);
    });

    test('fromJson should handle response without data', () {
      final json = {'success': false, 'code': 'ERROR', 'message': 'Failed'};

      final model = AirlineStatusResponseModel.fromJson(json);

      expect(model.success, isFalse);
      expect(model.id, isNull);
      expect(model.status, isNull);
      expect(model.updated, isNull);
    });

    test('fromJson should handle empty json with defaults', () {
      final json = <String, dynamic>{};

      final model = AirlineStatusResponseModel.fromJson(json);

      expect(model.success, isFalse);
      expect(model.code, isEmpty);
      expect(model.message, isEmpty);
    });

    test('fromJsonString should parse JSON string', () {
      const jsonStr = '{"success": true, "code": "OK", "message": "Success"}';

      final model = AirlineStatusResponseModel.fromJsonString(jsonStr);

      expect(model.success, isTrue);
      expect(model.code, equals('OK'));
    });

    test('fromError should parse error response', () {
      final json = {
        'success': false,
        'code': 'ERR_001',
        'message': 'Error occurred',
      };

      final model = AirlineStatusResponseModel.fromError(json);

      expect(model.success, isFalse);
      expect(model.code, equals('ERR_001'));
      expect(model.message, equals('Error occurred'));
    });

    test('fromError should handle empty json with defaults', () {
      final json = <String, dynamic>{};

      final model = AirlineStatusResponseModel.fromError(json);

      expect(model.success, isFalse);
      expect(model.code, equals('UNKNOWN_ERROR'));
      expect(model.message, contains('unknown error'));
    });
  });

  group('AirportStatusResponseModel', () {
    test('fromJson should parse valid response with data', () {
      final json = {
        'success': true,
        'code': 'MOD_APT_ACTIVATE_EXI_00002',
        'message': 'The airport has been activated successfully',
        'data': {'id': 'airport123', 'status': 'active', 'updated': true},
      };

      final model = AirportStatusResponseModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.code, equals('MOD_APT_ACTIVATE_EXI_00002'));
      expect(model.message, contains('activated'));
      expect(model.id, equals('airport123'));
      expect(model.status, equals('active'));
      expect(model.updated, isTrue);
    });

    test('fromJson should handle response without data', () {
      final json = {'success': false, 'code': 'ERROR', 'message': 'Failed'};

      final model = AirportStatusResponseModel.fromJson(json);

      expect(model.success, isFalse);
      expect(model.id, isNull);
      expect(model.status, isNull);
      expect(model.updated, isNull);
    });

    test('fromJson should handle empty json with defaults', () {
      final json = <String, dynamic>{};

      final model = AirportStatusResponseModel.fromJson(json);

      expect(model.success, isFalse);
      expect(model.code, isEmpty);
      expect(model.message, isEmpty);
    });

    test('fromJsonString should parse JSON string', () {
      const jsonStr = '{"success": true, "code": "OK", "message": "Success"}';

      final model = AirportStatusResponseModel.fromJsonString(jsonStr);

      expect(model.success, isTrue);
      expect(model.code, equals('OK'));
    });

    test('fromError should parse error response', () {
      final json = {
        'success': false,
        'code': 'ERR_001',
        'message': 'Error occurred',
      };

      final model = AirportStatusResponseModel.fromError(json);

      expect(model.success, isFalse);
      expect(model.code, equals('ERR_001'));
      expect(model.message, equals('Error occurred'));
    });

    test('fromError should handle empty json with defaults', () {
      final json = <String, dynamic>{};

      final model = AirportStatusResponseModel.fromError(json);

      expect(model.success, isFalse);
      expect(model.code, equals('UNKNOWN_ERROR'));
      expect(model.message, contains('unknown error'));
    });
  });
}
