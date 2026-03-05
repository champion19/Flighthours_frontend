import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/tail_number/domain/entities/tail_number_entity.dart';

void main() {
  group('TailNumberEntity', () {
    test('should create with required fields', () {
      const entity = TailNumberEntity(id: '1', tailNumber: 'HK-1333');
      expect(entity.id, '1');
      expect(entity.tailNumber, 'HK-1333');
    });

    test('should create with all fields', () {
      const entity = TailNumberEntity(
        id: '1',
        tailNumber: 'HK-1333',
        modelName: 'A320',
        airlineName: 'Avianca',
        aircraftModelId: 'am1',
        airlineId: 'al1',
      );
      expect(entity.modelName, 'A320');
      expect(entity.airlineName, 'Avianca');
      expect(entity.aircraftModelId, 'am1');
      expect(entity.airlineId, 'al1');
    });

    test('props should contain all fields', () {
      const entity = TailNumberEntity(
        id: '1',
        tailNumber: 'HK-1333',
        modelName: 'A320',
        airlineName: 'AV',
        aircraftModelId: 'am1',
        airlineId: 'al1',
      );
      expect(entity.props, ['1', 'HK-1333', 'A320', 'AV', 'am1', 'al1']);
    });

    test('two entities with same values should be equal', () {
      const a = TailNumberEntity(id: '1', tailNumber: 'HK-1333');
      const b = TailNumberEntity(id: '1', tailNumber: 'HK-1333');
      expect(a, equals(b));
    });

    test('two entities with different values should not be equal', () {
      const a = TailNumberEntity(id: '1', tailNumber: 'HK-1333');
      const b = TailNumberEntity(id: '2', tailNumber: 'HK-9999');
      expect(a, isNot(equals(b)));
    });
  });
}
