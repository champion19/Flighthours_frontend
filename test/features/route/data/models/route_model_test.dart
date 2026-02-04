import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/route/data/models/route_model.dart';

void main() {
  group('RouteModel', () {
    test('fromJson should parse valid JSON correctly', () {
      // Arrange
      final json = {
        'id': 'route123',
        'uuid': 'uuid-1234-5678',
        'origin_airport_id': 'airport1',
        'destination_airport_id': 'airport2',
        'origin_airport_name': 'El Dorado International',
        'origin_airport_code': 'BOG',
        'origin_country': 'Colombia',
        'destination_airport_name': 'Jose Maria Cordova',
        'destination_airport_code': 'MDE',
        'destination_country': 'Colombia',
        'route_type': 'Nacional',
        'estimated_flight_time': '00:45:00',
        'status': 'active',
      };

      // Act
      final result = RouteModel.fromJson(json);

      // Assert
      expect(result.id, equals('route123'));
      expect(result.uuid, equals('uuid-1234-5678'));
      expect(result.originAirportId, equals('airport1'));
      expect(result.destinationAirportId, equals('airport2'));
      expect(result.originAirportName, equals('El Dorado International'));
      expect(result.originAirportCode, equals('BOG'));
      expect(result.originCountry, equals('Colombia'));
      expect(result.destinationAirportName, equals('Jose Maria Cordova'));
      expect(result.destinationAirportCode, equals('MDE'));
      expect(result.destinationCountry, equals('Colombia'));
      expect(result.routeType, equals('Nacional'));
      expect(result.estimatedFlightTime, equals('00:45:00'));
      expect(result.status, equals('active'));
    });

    test('fromJson should handle iata_code field names', () {
      // Arrange
      final json = {
        'id': 'route123',
        'origin_airport_id': 'airport1',
        'destination_airport_id': 'airport2',
        'origin_iata_code': 'BOG',
        'destination_iata_code': 'MDE',
      };

      // Act
      final result = RouteModel.fromJson(json);

      // Assert
      expect(result.originAirportCode, equals('BOG'));
      expect(result.destinationAirportCode, equals('MDE'));
    });

    test('fromJson should use defaults for missing required fields', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final result = RouteModel.fromJson(json);

      // Assert
      expect(result.id, equals(''));
      expect(result.originAirportId, equals(''));
      expect(result.destinationAirportId, equals(''));
      expect(result.uuid, isNull);
      expect(result.originAirportName, isNull);
      expect(result.routeType, isNull);
    });

    test('fromJson should handle null optional fields', () {
      // Arrange
      final json = {
        'id': 'route123',
        'origin_airport_id': 'airport1',
        'destination_airport_id': 'airport2',
      };

      // Act
      final result = RouteModel.fromJson(json);

      // Assert
      expect(result.originAirportName, isNull);
      expect(result.originAirportCode, isNull);
      expect(result.destinationAirportName, isNull);
      expect(result.status, isNull);
    });

    test('toJson should serialize correctly', () {
      // Arrange
      const model = RouteModel(
        id: 'route123',
        uuid: 'uuid-1234',
        originAirportId: 'airport1',
        destinationAirportId: 'airport2',
        originAirportName: 'El Dorado',
        originAirportCode: 'BOG',
        originCountry: 'Colombia',
        destinationAirportName: 'Jose Maria Cordova',
        destinationAirportCode: 'MDE',
        destinationCountry: 'Colombia',
        routeType: 'Nacional',
        estimatedFlightTime: '00:45:00',
        status: 'active',
      );

      // Act
      final result = model.toJson();

      // Assert
      expect(result['id'], equals('route123'));
      expect(result['uuid'], equals('uuid-1234'));
      expect(result['origin_airport_id'], equals('airport1'));
      expect(result['destination_airport_id'], equals('airport2'));
      expect(result['origin_airport_name'], equals('El Dorado'));
      expect(result['origin_airport_code'], equals('BOG'));
      expect(result['destination_airport_code'], equals('MDE'));
      expect(result['route_type'], equals('Nacional'));
      expect(result['estimated_flight_time'], equals('00:45:00'));
      expect(result['status'], equals('active'));
    });

    test('fromJson should handle international route', () {
      // Arrange
      final json = {
        'id': 'route456',
        'origin_airport_id': 'airport1',
        'destination_airport_id': 'airport3',
        'origin_airport_name': 'El Dorado International',
        'origin_airport_code': 'BOG',
        'origin_country': 'Colombia',
        'destination_airport_name': 'Miami International',
        'destination_airport_code': 'MIA',
        'destination_country': 'United States',
        'route_type': 'Internacional',
        'estimated_flight_time': '03:30:00',
        'status': 'active',
      };

      // Act
      final result = RouteModel.fromJson(json);

      // Assert
      expect(result.routeType, equals('Internacional'));
      expect(result.originCountry, equals('Colombia'));
      expect(result.destinationCountry, equals('United States'));
    });
  });
}
