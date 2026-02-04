import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airline_route/data/models/airline_route_model.dart';

void main() {
  group('AirlineRouteModel', () {
    test('fromJson should parse valid JSON correctly', () {
      // Arrange
      final json = {
        'id': 'route123',
        'uuid': 'uuid-1234-5678',
        'route_id': 'RT001',
        'airline_id': 'AIR001',
        'route_name': 'BOG → CLO',
        'airline_name': 'Avianca',
        'origin_airport_code': 'BOG',
        'destination_airport_code': 'CLO',
        'status': 'active',
      };

      // Act
      final result = AirlineRouteModel.fromJson(json);

      // Assert
      expect(result.id, equals('route123'));
      expect(result.uuid, equals('uuid-1234-5678'));
      expect(result.routeId, equals('RT001'));
      expect(result.airlineId, equals('AIR001'));
      expect(result.routeName, equals('BOG → CLO'));
      expect(result.airlineName, equals('Avianca'));
      expect(result.originAirportCode, equals('BOG'));
      expect(result.destinationAirportCode, equals('CLO'));
      expect(result.status, equals('active'));
    });

    test(
      'fromJson should handle origin_iata_code and destination_iata_code',
      () {
        // Arrange - backend uses iata_code instead of airport_code
        final json = {
          'id': 'route123',
          'route_id': 'RT001',
          'airline_id': 'AIR001',
          'origin_iata_code': 'MTR',
          'destination_iata_code': 'BOG',
          'status': true,
        };

        // Act
        final result = AirlineRouteModel.fromJson(json);

        // Assert
        expect(result.originAirportCode, equals('MTR'));
        expect(result.destinationAirportCode, equals('BOG'));
      },
    );

    test('fromJson should parse boolean status correctly', () {
      // Arrange - status as boolean true
      final jsonActive = {
        'id': 'route1',
        'route_id': 'RT001',
        'airline_id': 'AIR001',
        'status': true,
      };

      // Arrange - status as boolean false
      final jsonInactive = {
        'id': 'route2',
        'route_id': 'RT002',
        'airline_id': 'AIR001',
        'status': false,
      };

      // Act
      final resultActive = AirlineRouteModel.fromJson(jsonActive);
      final resultInactive = AirlineRouteModel.fromJson(jsonInactive);

      // Assert
      expect(resultActive.status, equals('active'));
      expect(resultInactive.status, equals('inactive'));
    });

    test('fromJson should handle null status', () {
      // Arrange
      final json = {
        'id': 'route1',
        'route_id': 'RT001',
        'airline_id': 'AIR001',
        'status': null,
      };

      // Act
      final result = AirlineRouteModel.fromJson(json);

      // Assert
      expect(result.status, isNull);
    });

    test('fromJson should use defaults for missing required fields', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final result = AirlineRouteModel.fromJson(json);

      // Assert
      expect(result.id, equals(''));
      expect(result.routeId, equals(''));
      expect(result.airlineId, equals(''));
      expect(result.uuid, isNull);
      expect(result.routeName, isNull);
    });

    test('toJson should serialize correctly', () {
      // Arrange
      const model = AirlineRouteModel(
        id: 'route123',
        uuid: 'uuid-1234',
        routeId: 'RT001',
        airlineId: 'AIR001',
        routeName: 'BOG → CLO',
        airlineName: 'Avianca',
        originAirportCode: 'BOG',
        destinationAirportCode: 'CLO',
        status: 'active',
      );

      // Act
      final result = model.toJson();

      // Assert
      expect(result['id'], equals('route123'));
      expect(result['uuid'], equals('uuid-1234'));
      expect(result['route_id'], equals('RT001'));
      expect(result['airline_id'], equals('AIR001'));
      expect(result['route_name'], equals('BOG → CLO'));
      expect(result['airline_name'], equals('Avianca'));
      expect(result['origin_airport_code'], equals('BOG'));
      expect(result['destination_airport_code'], equals('CLO'));
      expect(result['status'], equals('active'));
    });

    test('fromJson should handle string status', () {
      // Arrange
      final json = {
        'id': 'route1',
        'route_id': 'RT001',
        'airline_id': 'AIR001',
        'status': 'inactive',
      };

      // Act
      final result = AirlineRouteModel.fromJson(json);

      // Assert
      expect(result.status, equals('inactive'));
    });
  });
}
