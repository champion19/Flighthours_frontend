import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airline_route/data/datasources/airline_route_remote_data_source.dart';
import 'package:flight_hours_app/features/airline_route/data/models/airline_route_model.dart';

void main() {
  group('AirlineRouteModel tests', () {
    test('fromJson creates model with all fields', () {
      final json = {
        'id': '1',
        'uuid': 'uuid-123',
        'route_id': 'route-1',
        'airline_id': 'airline-1',
        'route_name': 'Bogota-Medellin',
        'airline_name': 'Avianca',
        'origin_airport_code': 'BOG',
        'destination_airport_code': 'MDE',
        'status': 'active',
      };

      final model = AirlineRouteModel.fromJson(json);

      expect(model.id, equals('1'));
      expect(model.uuid, equals('uuid-123'));
      expect(model.routeId, equals('route-1'));
      expect(model.airlineId, equals('airline-1'));
      expect(model.routeName, equals('Bogota-Medellin'));
      expect(model.airlineName, equals('Avianca'));
      expect(model.originAirportCode, equals('BOG'));
      expect(model.destinationAirportCode, equals('MDE'));
      expect(model.status, equals('active'));
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': '1',
        'route_id': 'route-1',
        'airline_id': 'airline-1',
      };

      final model = AirlineRouteModel.fromJson(json);

      expect(model.id, equals('1'));
      expect(model.uuid, isNull);
      expect(model.routeName, isNull);
      expect(model.status, isNull);
    });

    test('fromJson handles bool status true', () {
      final json = {
        'id': '1',
        'route_id': 'route-1',
        'airline_id': 'airline-1',
        'status': true,
      };

      final model = AirlineRouteModel.fromJson(json);

      expect(model.status, equals('active'));
    });

    test('fromJson handles bool status false', () {
      final json = {
        'id': '1',
        'route_id': 'route-1',
        'airline_id': 'airline-1',
        'status': false,
      };

      final model = AirlineRouteModel.fromJson(json);

      expect(model.status, equals('inactive'));
    });

    test('fromJson handles origin_iata_code fallback', () {
      final json = {
        'id': '1',
        'route_id': 'route-1',
        'airline_id': 'airline-1',
        'origin_iata_code': 'BOG',
        'destination_iata_code': 'MDE',
      };

      final model = AirlineRouteModel.fromJson(json);

      expect(model.originAirportCode, equals('BOG'));
      expect(model.destinationAirportCode, equals('MDE'));
    });

    test('toJson creates correct json', () {
      final model = AirlineRouteModel(
        id: '1',
        uuid: 'uuid-123',
        routeId: 'route-1',
        airlineId: 'airline-1',
        routeName: 'Route1',
        airlineName: 'Airline1',
        originAirportCode: 'BOG',
        destinationAirportCode: 'MDE',
        status: 'active',
      );

      final json = model.toJson();

      expect(json['id'], equals('1'));
      expect(json['uuid'], equals('uuid-123'));
      expect(json['route_id'], equals('route-1'));
      expect(json['airline_id'], equals('airline-1'));
      expect(json['route_name'], equals('Route1'));
    });
  });

  group('AirlineRouteStatusResponse additional tests', () {
    test('fromJson creates response with success true', () {
      final json = {'success': true, 'message': 'Activated'};
      final response = AirlineRouteStatusResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, equals('Activated'));
    });

    test('fromJson creates response with success false', () {
      final json = {'success': false, 'message': 'Failed'};
      final response = AirlineRouteStatusResponse.fromJson(json);

      expect(response.success, isFalse);
      expect(response.message, equals('Failed'));
    });

    test('fromError creates error response with message key', () {
      final data = {'message': 'Error message'};
      final response = AirlineRouteStatusResponse.fromError(data);

      expect(response.success, isFalse);
      expect(response.message, equals('Error message'));
    });

    test('fromError creates error response with error key', () {
      final data = {'error': 'Error details'};
      final response = AirlineRouteStatusResponse.fromError(data);

      expect(response.success, isFalse);
      expect(response.message, equals('Error details'));
    });

    test('fromError handles null data gracefully', () {
      final response = AirlineRouteStatusResponse.fromError(null);

      expect(response.success, isFalse);
      expect(response.message, equals('An error occurred'));
    });

    test('fromError handles string data gracefully', () {
      final response = AirlineRouteStatusResponse.fromError('Some error');

      expect(response.success, isFalse);
      expect(response.message, equals('An error occurred'));
    });

    test('fromError handles list data gracefully', () {
      final response = AirlineRouteStatusResponse.fromError(['error']);

      expect(response.success, isFalse);
      expect(response.message, equals('An error occurred'));
    });

    test('fromJson uses defaults when fields missing', () {
      final json = <String, dynamic>{};
      final response = AirlineRouteStatusResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, equals('Operation completed'));
    });
  });
}
