import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';

void main() {
  group('AirportEntity Extended Tests', () {
    test('should create airport entity with all fields', () {
      const airport = AirportEntity(
        id: '1',
        uuid: 'uuid-123',
        name: 'El Dorado International',
        iataCode: 'BOG',
        city: 'Bogota',
        country: 'Colombia',
        status: 'active',
      );

      expect(airport.id, equals('1'));
      expect(airport.uuid, equals('uuid-123'));
      expect(airport.name, equals('El Dorado International'));
      expect(airport.iataCode, equals('BOG'));
      expect(airport.city, equals('Bogota'));
      expect(airport.country, equals('Colombia'));
      expect(airport.status, equals('active'));
    });

    test('should create airport entity with null optional fields', () {
      const airport = AirportEntity(
        id: '1',
        name: 'Test Airport',
        iataCode: 'TST',
      );

      expect(airport.uuid, isNull);
      expect(airport.city, isNull);
      expect(airport.country, isNull);
    });

    test('should create airport entity with status inactive', () {
      const airport = AirportEntity(
        id: '1',
        name: 'Closed Airport',
        iataCode: 'CLS',
        status: 'inactive',
      );

      expect(airport.status, equals('inactive'));
    });

    test('two airports with same values should be equal', () {
      const airport1 = AirportEntity(id: '1', name: 'Airport', iataCode: 'APT');
      const airport2 = AirportEntity(id: '1', name: 'Airport', iataCode: 'APT');

      expect(airport1, equals(airport2));
    });

    test('two airports with different ids should not be equal', () {
      const airport1 = AirportEntity(id: '1', name: 'Airport', iataCode: 'APT');
      const airport2 = AirportEntity(id: '2', name: 'Airport', iataCode: 'APT');

      expect(airport1, isNot(equals(airport2)));
    });

    test('two airports with different iata codes should not be equal', () {
      const airport1 = AirportEntity(id: '1', name: 'Airport', iataCode: 'BOG');
      const airport2 = AirportEntity(id: '1', name: 'Airport', iataCode: 'MDE');

      expect(airport1, isNot(equals(airport2)));
    });

    test('props should contain all fields', () {
      const airport = AirportEntity(
        id: '1',
        uuid: 'uuid',
        name: 'Airport',
        iataCode: 'APT',
        city: 'City',
        country: 'Country',
        status: 'active',
      );

      expect(
        airport.props,
        containsAll([
          '1',
          'uuid',
          'Airport',
          'APT',
          'City',
          'Country',
          'active',
        ]),
      );
    });

    test('two airports with same status should be equal', () {
      const airport1 = AirportEntity(
        id: '1',
        name: 'Airport',
        iataCode: 'APT',
        status: 'active',
      );
      const airport2 = AirportEntity(
        id: '1',
        name: 'Airport',
        iataCode: 'APT',
        status: 'active',
      );

      expect(airport1, equals(airport2));
    });
  });
}
