import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';

void main() {
  group('AirportEntity', () {
    test('should create entity with required fields', () {
      const entity = AirportEntity(id: 'airport123', name: 'El Dorado');

      expect(entity.id, equals('airport123'));
      expect(entity.name, equals('El Dorado'));
    });

    test('should create entity with all fields', () {
      const entity = AirportEntity(
        id: 'airport456',
        uuid: 'uuid-5678',
        name: 'Jose Maria Cordova',
        code: 'MDE',
        iataCode: 'MDE',
        city: 'Medellin',
        country: 'Colombia',
        status: 'active',
        airportType: 'Internacional',
      );

      expect(entity.id, equals('airport456'));
      expect(entity.uuid, equals('uuid-5678'));
      expect(entity.name, equals('Jose Maria Cordova'));
      expect(entity.code, equals('MDE'));
      expect(entity.iataCode, equals('MDE'));
      expect(entity.city, equals('Medellin'));
      expect(entity.country, equals('Colombia'));
      expect(entity.status, equals('active'));
      expect(entity.airportType, equals('Internacional'));
    });

    test('should handle null optional fields', () {
      const entity = AirportEntity(id: 'airport789', name: 'LAX');

      expect(entity.uuid, isNull);
      expect(entity.code, isNull);
      expect(entity.iataCode, isNull);
      expect(entity.city, isNull);
      expect(entity.country, isNull);
      expect(entity.status, isNull);
      expect(entity.airportType, isNull);
    });

    test('props should contain all fields for Equatable', () {
      const entity = AirportEntity(
        id: 'test',
        uuid: 'uuid',
        name: 'Test',
        code: 'TST',
        iataCode: 'TST',
        city: 'City',
        country: 'Country',
        status: 'active',
        airportType: 'Nacional',
      );

      expect(entity.props.length, equals(9));
    });
  });
}
