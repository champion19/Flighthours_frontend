import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';

void main() {
  group('AirlineEntity Extended Tests', () {
    test('should create airline entity with all fields', () {
      const airline = AirlineEntity(
        id: '1',
        uuid: 'uuid-123',
        name: 'Avianca',
        code: 'AV',
        active: true,
      );

      expect(airline.id, equals('1'));
      expect(airline.uuid, equals('uuid-123'));
      expect(airline.name, equals('Avianca'));
      expect(airline.code, equals('AV'));
      expect(airline.active, isTrue);
    });

    test('should create airline entity with default active value', () {
      const airline = AirlineEntity(id: '1', name: 'Test Airline');

      expect(airline.active, isTrue);
    });

    test('should create airline entity with active false', () {
      const airline = AirlineEntity(
        id: '1',
        name: 'Inactive Airline',
        active: false,
      );

      expect(airline.active, isFalse);
    });

    test('two airlines with same values should be equal', () {
      const airline1 = AirlineEntity(id: '1', name: 'Avianca', code: 'AV');
      const airline2 = AirlineEntity(id: '1', name: 'Avianca', code: 'AV');

      expect(airline1, equals(airline2));
    });

    test('two airlines with different ids should not be equal', () {
      const airline1 = AirlineEntity(id: '1', name: 'Avianca');
      const airline2 = AirlineEntity(id: '2', name: 'Avianca');

      expect(airline1, isNot(equals(airline2)));
    });

    test('two airlines with different names should not be equal', () {
      const airline1 = AirlineEntity(id: '1', name: 'Avianca');
      const airline2 = AirlineEntity(id: '1', name: 'LATAM');

      expect(airline1, isNot(equals(airline2)));
    });

    test('props should contain all fields', () {
      const airline = AirlineEntity(
        id: '1',
        uuid: 'uuid',
        name: 'Airline',
        code: 'AL',
        active: true,
      );

      expect(airline.props, containsAll(['1', 'uuid', 'Airline', 'AL', true]));
    });

    test('should create airline with null optional fields', () {
      const airline = AirlineEntity(id: '1', name: 'Test');

      expect(airline.uuid, isNull);
      expect(airline.code, isNull);
    });
  });
}
