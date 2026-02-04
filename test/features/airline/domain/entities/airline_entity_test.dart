import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';

void main() {
  group('AirlineEntity', () {
    test('should create entity with required fields', () {
      const entity = AirlineEntity(id: 'airline123', name: 'Avianca');

      expect(entity.id, equals('airline123'));
      expect(entity.name, equals('Avianca'));
    });

    test('should create entity with all fields', () {
      const entity = AirlineEntity(
        id: 'airline456',
        uuid: 'uuid-1234',
        name: 'LATAM',
        code: 'LA',
      );

      expect(entity.id, equals('airline456'));
      expect(entity.uuid, equals('uuid-1234'));
      expect(entity.name, equals('LATAM'));
      expect(entity.code, equals('LA'));
    });

    test('should handle null optional fields', () {
      const entity = AirlineEntity(id: 'airline789', name: 'Copa');

      expect(entity.uuid, isNull);
      expect(entity.code, isNull);
    });

    test('props should contain all fields for Equatable', () {
      const entity = AirlineEntity(
        id: 'test',
        uuid: 'uuid',
        name: 'Test',
        code: 'TS',
      );

      expect(entity.props.length, equals(4));
      expect(entity.props, contains('test'));
      expect(entity.props, contains('uuid'));
      expect(entity.props, contains('Test'));
      expect(entity.props, contains('TS'));
    });
  });
}
