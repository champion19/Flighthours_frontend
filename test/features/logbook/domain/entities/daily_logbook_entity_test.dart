import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';

void main() {
  group('DailyLogbookEntity', () {
    test('should create entity with all fields', () {
      final entity = DailyLogbookEntity(
        id: 'logbook123',
        uuid: 'uuid-1234',
        employeeId: 'emp456',
        logDate: DateTime(2026, 2, 15),
        bookPage: 100,
        status: true,
      );

      expect(entity.id, equals('logbook123'));
      expect(entity.uuid, equals('uuid-1234'));
      expect(entity.employeeId, equals('emp456'));
      expect(entity.bookPage, equals(100));
      expect(entity.status, isTrue);
    });

    group('displayId', () {
      test('should return LB- prefix with first 4 chars for long IDs', () {
        const entity = DailyLogbookEntity(id: 'abcd12345678');

        expect(entity.displayId, equals('LB-ABCD'));
      });

      test('should return LB- with full ID for short IDs', () {
        const entity = DailyLogbookEntity(id: '123');

        expect(entity.displayId, equals('LB-123'));
      });
    });

    group('formattedDate', () {
      test('should format date as MM/DD/YY', () {
        final entity = DailyLogbookEntity(
          id: 'test',
          logDate: DateTime(2026, 2, 15),
        );

        expect(entity.formattedDate, equals('02/15/26'));
      });

      test('should return Unknown Date when logDate is null', () {
        const entity = DailyLogbookEntity(id: 'test');

        expect(entity.formattedDate, equals('Unknown Date'));
      });
    });

    group('fullFormattedDate', () {
      test('should format date as Month Day, Year', () {
        final entity = DailyLogbookEntity(
          id: 'test',
          logDate: DateTime(2026, 10, 26),
        );

        expect(entity.fullFormattedDate, equals('October 26, 2026'));
      });

      test('should handle January', () {
        final entity = DailyLogbookEntity(
          id: 'test',
          logDate: DateTime(2026, 1, 5),
        );

        expect(entity.fullFormattedDate, equals('January 5, 2026'));
      });

      test('should handle December', () {
        final entity = DailyLogbookEntity(
          id: 'test',
          logDate: DateTime(2025, 12, 25),
        );

        expect(entity.fullFormattedDate, equals('December 25, 2025'));
      });

      test('should return Unknown Date when logDate is null', () {
        const entity = DailyLogbookEntity(id: 'test');

        expect(entity.fullFormattedDate, equals('Unknown Date'));
      });
    });

    group('displayStatus', () {
      test('should return Active when status is true', () {
        const entity = DailyLogbookEntity(id: 'test', status: true);

        expect(entity.displayStatus, equals('Active'));
      });

      test('should return Inactive when status is false', () {
        const entity = DailyLogbookEntity(id: 'test', status: false);

        expect(entity.displayStatus, equals('Inactive'));
      });

      test('should return Active when status is null (default)', () {
        const entity = DailyLogbookEntity(id: 'test');

        expect(entity.displayStatus, equals('Active'));
      });
    });

    group('isActive', () {
      test('should return true when status is true', () {
        const entity = DailyLogbookEntity(id: 'test', status: true);

        expect(entity.isActive, isTrue);
      });

      test('should return false when status is false', () {
        const entity = DailyLogbookEntity(id: 'test', status: false);

        expect(entity.isActive, isFalse);
      });

      test('should return true when status is null (default)', () {
        const entity = DailyLogbookEntity(id: 'test');

        expect(entity.isActive, isTrue);
      });
    });

    test('props should contain all fields for Equatable', () {
      final entity = DailyLogbookEntity(
        id: 'test',
        uuid: 'uuid',
        employeeId: 'emp',
        logDate: DateTime(2026, 1, 1),
        bookPage: 100,
        status: true,
      );

      expect(entity.props.length, equals(6));
    });
  });
}
