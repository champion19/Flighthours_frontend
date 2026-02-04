import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/register/domain/entities/airline_entity.dart';

void main() {
  group('AirlineEntity (register)', () {
    test('should create entity with required fields', () {
      final entity = AirlineEntity(id: 'air123', name: 'Avianca');

      expect(entity.id, equals('air123'));
      expect(entity.name, equals('Avianca'));
    });

    group('copyWith', () {
      test('should copy with new id', () {
        final original = AirlineEntity(id: 'air123', name: 'Avianca');

        final copied = original.copyWith(id: 'air456');

        expect(copied.id, equals('air456'));
        expect(copied.name, equals('Avianca')); // unchanged
      });

      test('should copy with new name', () {
        final original = AirlineEntity(id: 'air123', name: 'Avianca');

        final copied = original.copyWith(name: 'LATAM');

        expect(copied.id, equals('air123')); // unchanged
        expect(copied.name, equals('LATAM'));
      });

      test('should copy with all new fields', () {
        final original = AirlineEntity(id: 'air123', name: 'Avianca');

        final copied = original.copyWith(id: 'air999', name: 'Copa');

        expect(copied.id, equals('air999'));
        expect(copied.name, equals('Copa'));
      });

      test('should keep original values when no arguments passed', () {
        final original = AirlineEntity(id: 'air123', name: 'Avianca');

        final copied = original.copyWith();

        expect(copied.id, equals('air123'));
        expect(copied.name, equals('Avianca'));
      });
    });
  });
}
