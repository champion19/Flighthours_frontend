import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';

void main() {
  group('RouteEntity', () {
    test('should create entity with all fields', () {
      const entity = RouteEntity(
        id: 'route123',
        uuid: 'uuid-1234',
        originAirportId: 'airport1',
        destinationAirportId: 'airport2',
        originAirportName: 'El Dorado',
        originAirportCode: 'BOG',
        originCountry: 'Colombia',
        destinationAirportName: 'Jose Maria Cordova',
        destinationAirportCode: 'MDE',
        destinationCountry: 'Colombia',
        routeType: 'Nacional',
        estimatedFlightTime: '00:45:00',
        status: 'active',
      );

      expect(entity.id, equals('route123'));
      expect(entity.originAirportCode, equals('BOG'));
      expect(entity.routeType, equals('Nacional'));
    });

    group('displayId', () {
      test('should return FR- prefix with first 3 chars for long IDs', () {
        const entity = RouteEntity(
          id: 'abc123456789',
          originAirportId: 'a1',
          destinationAirportId: 'a2',
        );

        expect(entity.displayId, equals('FR-ABC'));
      });

      test('should return FR- with full ID for short IDs', () {
        const entity = RouteEntity(
          id: '123',
          originAirportId: 'a1',
          destinationAirportId: 'a2',
        );

        expect(entity.displayId, equals('FR-123'));
      });
    });

    group('formattedFlightTime', () {
      test('should return formatted time with hours and minutes', () {
        const entity = RouteEntity(
          id: 'route1',
          originAirportId: 'a1',
          destinationAirportId: 'a2',
          estimatedFlightTime: '07:30:00',
        );

        expect(entity.formattedFlightTime, equals('7h 30m'));
      });

      test('should return only hours when minutes are 0', () {
        const entity = RouteEntity(
          id: 'route1',
          originAirportId: 'a1',
          destinationAirportId: 'a2',
          estimatedFlightTime: '03:00:00',
        );

        expect(entity.formattedFlightTime, equals('3h'));
      });

      test('should return only minutes when hours are 0', () {
        const entity = RouteEntity(
          id: 'route1',
          originAirportId: 'a1',
          destinationAirportId: 'a2',
          estimatedFlightTime: '00:45:00',
        );

        expect(entity.formattedFlightTime, equals('45m'));
      });

      test('should return N/A when estimatedFlightTime is null', () {
        const entity = RouteEntity(
          id: 'route1',
          originAirportId: 'a1',
          destinationAirportId: 'a2',
        );

        expect(entity.formattedFlightTime, equals('N/A'));
      });

      test('should return N/A when estimatedFlightTime is empty', () {
        const entity = RouteEntity(
          id: 'route1',
          originAirportId: 'a1',
          destinationAirportId: 'a2',
          estimatedFlightTime: '',
        );

        expect(entity.formattedFlightTime, equals('N/A'));
      });

      test('should return raw value when hours and minutes are 0', () {
        const entity = RouteEntity(
          id: 'route1',
          originAirportId: 'a1',
          destinationAirportId: 'a2',
          estimatedFlightTime: '00:00:30',
        );

        expect(entity.formattedFlightTime, equals('00:00:30'));
      });
    });

    group('countriesDisplay', () {
      test('should display countries with arrow', () {
        const entity = RouteEntity(
          id: 'route1',
          originAirportId: 'a1',
          destinationAirportId: 'a2',
          originCountry: 'Colombia',
          destinationCountry: 'United States',
        );

        expect(entity.countriesDisplay, equals('Colombia → United States'));
      });

      test('should display Unknown for null countries', () {
        const entity = RouteEntity(
          id: 'route1',
          originAirportId: 'a1',
          destinationAirportId: 'a2',
        );

        expect(entity.countriesDisplay, equals('Unknown → Unknown'));
      });
    });

    group('isInternational', () {
      test('should return true for Internacional route type', () {
        const entity = RouteEntity(
          id: 'route1',
          originAirportId: 'a1',
          destinationAirportId: 'a2',
          routeType: 'Internacional',
        );

        expect(entity.isInternational, isTrue);
      });

      test('should return false for Nacional route type', () {
        const entity = RouteEntity(
          id: 'route1',
          originAirportId: 'a1',
          destinationAirportId: 'a2',
          routeType: 'Nacional',
        );

        expect(entity.isInternational, isFalse);
      });

      test(
        'should return true when countries are different and no routeType',
        () {
          const entity = RouteEntity(
            id: 'route1',
            originAirportId: 'a1',
            destinationAirportId: 'a2',
            originCountry: 'Colombia',
            destinationCountry: 'Peru',
          );

          expect(entity.isInternational, isTrue);
        },
      );

      test('should return false when countries are same and no routeType', () {
        const entity = RouteEntity(
          id: 'route1',
          originAirportId: 'a1',
          destinationAirportId: 'a2',
          originCountry: 'Colombia',
          destinationCountry: 'Colombia',
        );

        expect(entity.isInternational, isFalse);
      });
    });

    test('props should contain all fields for Equatable', () {
      const entity = RouteEntity(
        id: 'route1',
        uuid: 'uuid',
        originAirportId: 'a1',
        destinationAirportId: 'a2',
        originAirportName: 'Origin',
        originAirportCode: 'ORG',
        originCountry: 'Country1',
        destinationAirportName: 'Dest',
        destinationAirportCode: 'DST',
        destinationCountry: 'Country2',
        routeType: 'Nacional',
        estimatedFlightTime: '01:00:00',
        status: 'active',
      );

      expect(entity.props.length, equals(13));
    });
  });
}
