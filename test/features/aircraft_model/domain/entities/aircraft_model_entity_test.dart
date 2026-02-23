import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';

void main() {
  group('AircraftModelEntity', () {
    test('should create with required fields', () {
      const entity = AircraftModelEntity(id: '1', name: 'A320');
      expect(entity.id, '1');
      expect(entity.name, 'A320');
    });

    test('should create with all fields', () {
      const entity = AircraftModelEntity(
        id: '1',
        name: 'A320',
        aircraftTypeName: 'Narrow Body',
        family: 'A320',
        manufacturerName: 'Airbus',
        engineName: 'CFM56',
        status: 'active',
      );
      expect(entity.aircraftTypeName, 'Narrow Body');
      expect(entity.family, 'A320');
      expect(entity.manufacturerName, 'Airbus');
      expect(entity.engineName, 'CFM56');
      expect(entity.status, 'active');
    });

    test('props should contain all fields', () {
      const entity = AircraftModelEntity(
        id: '1',
        name: 'A320',
        aircraftTypeName: 'NB',
        family: 'A320',
        manufacturerName: 'Airbus',
        engineName: 'CFM56',
        status: 'active',
      );
      expect(entity.props, [
        '1',
        'A320',
        'NB',
        'A320',
        'Airbus',
        'CFM56',
        'active',
      ]);
    });

    test('two entities with same values should be equal', () {
      const a = AircraftModelEntity(id: '1', name: 'A320');
      const b = AircraftModelEntity(id: '1', name: 'A320');
      expect(a, equals(b));
    });

    test('two entities with different values should not be equal', () {
      const a = AircraftModelEntity(id: '1', name: 'A320');
      const b = AircraftModelEntity(id: '2', name: 'B737');
      expect(a, isNot(equals(b)));
    });
  });
}
