import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/aircraft_model/data/models/aircraft_model_status_response_model.dart';

void main() {
  group('AircraftModelStatusResponseModel', () {
    test('fromJson creates model with all fields', () {
      final json = {
        'success': true,
        'code': 'MOD_AM_ACT_04201',
        'message': 'Activated successfully',
        'data': {'id': 'am-001', 'status': 'active', 'updated': true},
      };

      final model = AircraftModelStatusResponseModel.fromJson(json);

      expect(model.success, true);
      expect(model.code, 'MOD_AM_ACT_04201');
      expect(model.message, 'Activated successfully');
      expect(model.id, 'am-001');
      expect(model.status, 'active');
      expect(model.updated, true);
    });

    test('fromJson handles missing data', () {
      final json = {
        'success': false,
        'code': 'ERROR',
        'message': 'Something failed',
      };

      final model = AircraftModelStatusResponseModel.fromJson(json);

      expect(model.success, false);
      expect(model.id, isNull);
      expect(model.status, isNull);
      expect(model.updated, isNull);
    });

    test('fromJson uses defaults for missing fields', () {
      final json = <String, dynamic>{};

      final model = AircraftModelStatusResponseModel.fromJson(json);

      expect(model.success, false);
      expect(model.code, '');
      expect(model.message, '');
    });

    test('fromJsonString parses JSON string', () {
      const jsonStr =
          '{"success":true,"code":"TEST","message":"OK","data":{"id":"1","status":"active","updated":true}}';

      final model = AircraftModelStatusResponseModel.fromJsonString(jsonStr);

      expect(model.success, true);
      expect(model.code, 'TEST');
      expect(model.id, '1');
    });

    test('fromError creates error response', () {
      final json = {
        'success': false,
        'code': 'AM_ERR_001',
        'message': 'Model not found',
      };

      final model = AircraftModelStatusResponseModel.fromError(json);

      expect(model.success, false);
      expect(model.code, 'AM_ERR_001');
      expect(model.message, 'Model not found');
    });

    test('fromError uses defaults for missing fields', () {
      final json = <String, dynamic>{};

      final model = AircraftModelStatusResponseModel.fromError(json);

      expect(model.success, false);
      expect(model.code, 'UNKNOWN_ERROR');
      expect(model.message, 'An unknown error occurred');
    });
  });
}
