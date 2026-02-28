import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/crew_member_type/presentation/bloc/crew_member_type_event.dart';
import 'package:flight_hours_app/features/aircraft_model/data/models/aircraft_model_status_response_model.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_status_response_entity.dart';

void main() {
  group('CrewMemberTypeEvent', () {
    test('FetchCrewMemberTypes should store role and have correct props', () {
      const event = FetchCrewMemberTypes('captain');
      expect(event.role, 'captain');
      expect(event.props, ['captain']);
    });
  });

  group('AircraftModelStatusResponseEntity', () {
    test('should create with required and optional fields', () {
      const entity = AircraftModelStatusResponseEntity(
        success: true,
        code: 'OK',
        message: 'Activated',
        id: '1',
        status: 'active',
        updated: true,
      );
      expect(entity.success, isTrue);
      expect(entity.code, 'OK');
      expect(entity.id, '1');
      expect(entity.status, 'active');
      expect(entity.updated, isTrue);
    });

    test('should allow null optional fields', () {
      const entity = AircraftModelStatusResponseEntity(
        success: false,
        code: 'ERR',
        message: 'Error',
      );
      expect(entity.id, isNull);
      expect(entity.status, isNull);
      expect(entity.updated, isNull);
    });
  });

  group('AircraftModelStatusResponseModel', () {
    test('fromJson should parse valid response with data', () {
      final model = AircraftModelStatusResponseModel.fromJson({
        'success': true,
        'code': 'MOD_AM_ACT_EXI_04201',
        'message': 'The aircraft model has been activated successfully',
        'data': {'id': 'abc123', 'status': 'active', 'updated': true},
      });
      expect(model.success, isTrue);
      expect(model.id, 'abc123');
      expect(model.status, 'active');
      expect(model.updated, isTrue);
    });

    test('fromJson should handle null data', () {
      final model = AircraftModelStatusResponseModel.fromJson({
        'success': false,
        'code': 'ERR',
        'message': 'Error',
      });
      expect(model.id, isNull);
      expect(model.status, isNull);
    });

    test('fromJsonString should parse JSON string', () {
      final model = AircraftModelStatusResponseModel.fromJsonString(
        '{"success":true,"code":"OK","message":"ok","data":{"id":"1","status":"active","updated":true}}',
      );
      expect(model.success, isTrue);
      expect(model.id, '1');
    });

    test('fromError should create error response', () {
      final model = AircraftModelStatusResponseModel.fromError({
        'success': false,
        'code': 'ERR_NOT_FOUND',
        'message': 'Not found',
      });
      expect(model.success, isFalse);
      expect(model.code, 'ERR_NOT_FOUND');
    });

    test('fromError should handle missing fields', () {
      final model = AircraftModelStatusResponseModel.fromError({});
      expect(model.success, isFalse);
      expect(model.code, 'UNKNOWN_ERROR');
      expect(model.message, 'An unknown error occurred');
    });
  });
}
