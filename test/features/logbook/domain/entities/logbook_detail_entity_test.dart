import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';

void main() {
  group('LogbookDetailEntity', () {
    test('should create entity with all fields', () {
      const entity = LogbookDetailEntity(
        id: 'detail123',
        uuid: 'uuid-1234',
        dailyLogbookId: 'logbook456',
        flightNumber: '4043',
        routeCode: 'MDE-BOG',
        originIataCode: 'MDE',
        destinationIataCode: 'BOG',
        pilotRole: 'PM',
        passengers: 174,
      );

      expect(entity.id, equals('detail123'));
      expect(entity.flightNumber, equals('4043'));
      expect(entity.passengers, equals(174));
    });

    group('displayId', () {
      test('should return FL- prefix with first 4 chars for long IDs', () {
        const entity = LogbookDetailEntity(id: 'abcd12345678');

        expect(entity.displayId, equals('FL-ABCD'));
      });

      test('should return FL- with full ID for short IDs', () {
        const entity = LogbookDetailEntity(id: '123');

        expect(entity.displayId, equals('FL-123'));
      });
    });

    group('routeDisplay', () {
      test('should return routeCode when present', () {
        const entity = LogbookDetailEntity(id: 'test', routeCode: 'BOG-MDE');

        expect(entity.routeDisplay, equals('BOG-MDE'));
      });

      test('should build from IATA codes when routeCode is null', () {
        const entity = LogbookDetailEntity(
          id: 'test',
          originIataCode: 'JFK',
          destinationIataCode: 'LAX',
        );

        expect(entity.routeDisplay, equals('JFK-LAX'));
      });

      test('should return Unknown Route when no route info', () {
        const entity = LogbookDetailEntity(id: 'test');

        expect(entity.routeDisplay, equals('Unknown Route'));
      });

      test('should return Unknown Route when routeCode is empty', () {
        const entity = LogbookDetailEntity(id: 'test', routeCode: '');

        expect(entity.routeDisplay, equals('Unknown Route'));
      });
    });

    group('formattedDate', () {
      test('should use flightRealDate first', () {
        final entity = LogbookDetailEntity(
          id: 'test',
          flightRealDate: DateTime(2026, 3, 15),
          logDate: DateTime(2026, 3, 20),
        );

        expect(entity.formattedDate, equals('03/15/26'));
      });

      test('should fallback to logDate when flightRealDate is null', () {
        final entity = LogbookDetailEntity(
          id: 'test',
          logDate: DateTime(2026, 4, 25),
        );

        expect(entity.formattedDate, equals('04/25/26'));
      });

      test('should return Unknown when both dates are null', () {
        const entity = LogbookDetailEntity(id: 'test');

        expect(entity.formattedDate, equals('Unknown'));
      });
    });

    group('startTime', () {
      test('should format outTime as HH:MM', () {
        const entity = LogbookDetailEntity(id: 'test', outTime: '21:17:00');

        expect(entity.startTime, equals('21:17'));
      });

      test('should return --:-- when outTime is null', () {
        const entity = LogbookDetailEntity(id: 'test');

        expect(entity.startTime, equals('--:--'));
      });
    });

    group('endTime', () {
      test('should format inTime as HH:MM', () {
        const entity = LogbookDetailEntity(id: 'test', inTime: '22:07:00');

        expect(entity.endTime, equals('22:07'));
      });

      test('should return --:-- when inTime is null', () {
        const entity = LogbookDetailEntity(id: 'test');

        expect(entity.endTime, equals('--:--'));
      });
    });

    group('displayPilotRole', () {
      test('should return pilot role when present', () {
        const entity = LogbookDetailEntity(id: 'test', pilotRole: 'PIC');

        expect(entity.displayPilotRole, equals('PIC'));
      });

      test('should return Unknown when pilotRole is null', () {
        const entity = LogbookDetailEntity(id: 'test');

        expect(entity.displayPilotRole, equals('Unknown'));
      });
    });

    group('aircraftDisplay', () {
      test('should show license plate and short model', () {
        const entity = LogbookDetailEntity(
          id: 'test',
          licensePlate: 'CC-BAQ',
          modelName: 'A320-112',
        );

        expect(entity.aircraftDisplay, equals('CC-BAQ (A320)'));
      });

      test('should return licensePlate when modelName is null', () {
        const entity = LogbookDetailEntity(id: 'test', licensePlate: 'CC-XYZ');

        expect(entity.aircraftDisplay, equals('CC-XYZ'));
      });

      test('should return modelName when licensePlate is null', () {
        const entity = LogbookDetailEntity(id: 'test', modelName: 'B737-800');

        expect(entity.aircraftDisplay, equals('B737-800'));
      });

      test('should return Unknown Aircraft when both are null', () {
        const entity = LogbookDetailEntity(id: 'test');

        expect(entity.aircraftDisplay, equals('Unknown Aircraft'));
      });
    });

    test('props should contain all fields for Equatable', () {
      const entity = LogbookDetailEntity(
        id: 'test',
        uuid: 'uuid',
        dailyLogbookId: 'logbook',
        flightNumber: '4043',
        routeCode: 'MDE-BOG',
        pilotRole: 'PM',
      );

      expect(entity.props.length, equals(26));
    });
  });
}
