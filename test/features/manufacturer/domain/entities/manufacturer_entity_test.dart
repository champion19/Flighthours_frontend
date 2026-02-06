import 'package:flight_hours_app/features/manufacturer/domain/entities/manufacturer_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ManufacturerEntity', () {
    test('should create entity with all required fields', () {
      const manufacturer = ManufacturerEntity(id: 'test-id', name: 'Boeing');

      expect(manufacturer.id, 'test-id');
      expect(manufacturer.name, 'Boeing');
      expect(manufacturer.uuid, isNull);
      expect(manufacturer.country, isNull);
      expect(manufacturer.description, isNull);
      expect(manufacturer.status, isNull);
    });

    test('should create entity with all optional fields', () {
      const manufacturer = ManufacturerEntity(
        id: 'test-id',
        uuid: 'uuid-123',
        name: 'Airbus',
        country: 'France',
        description: 'European aircraft manufacturer',
        status: 'active',
      );

      expect(manufacturer.id, 'test-id');
      expect(manufacturer.uuid, 'uuid-123');
      expect(manufacturer.name, 'Airbus');
      expect(manufacturer.country, 'France');
      expect(manufacturer.description, 'European aircraft manufacturer');
      expect(manufacturer.status, 'active');
    });

    test('should have correct props for equality', () {
      const manufacturer1 = ManufacturerEntity(
        id: 'test-id',
        uuid: 'uuid-123',
        name: 'Boeing',
        country: 'USA',
        description: 'American manufacturer',
        status: 'active',
      );

      const manufacturer2 = ManufacturerEntity(
        id: 'test-id',
        uuid: 'uuid-123',
        name: 'Boeing',
        country: 'USA',
        description: 'American manufacturer',
        status: 'active',
      );

      expect(manufacturer1, equals(manufacturer2));
      expect(manufacturer1.props.length, 6);
    });

    test('should not be equal when fields differ', () {
      const manufacturer1 = ManufacturerEntity(id: 'id-1', name: 'Boeing');
      const manufacturer2 = ManufacturerEntity(id: 'id-2', name: 'Boeing');

      expect(manufacturer1, isNot(equals(manufacturer2)));
    });
  });
}
