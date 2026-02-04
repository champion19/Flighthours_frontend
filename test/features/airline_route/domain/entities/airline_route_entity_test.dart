import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';

void main() {
  group('AirlineRouteEntity', () {
    test('should create entity with all fields', () {
      const entity = AirlineRouteEntity(
        id: 'route123',
        uuid: 'uuid-1234',
        routeId: 'rt001',
        airlineId: 'air001',
        routeName: 'JFK → LAX',
        airlineName: 'Global Air',
        originAirportCode: 'JFK',
        destinationAirportCode: 'LAX',
        status: 'active',
      );

      expect(entity.id, equals('route123'));
      expect(entity.routeId, equals('rt001'));
      expect(entity.airlineId, equals('air001'));
    });

    group('displayId', () {
      test('should return AR- prefix with first 4 chars for long IDs', () {
        const entity = AirlineRouteEntity(
          id: 'abcd12345678',
          routeId: 'rt001',
          airlineId: 'air001',
        );

        expect(entity.displayId, equals('AR-ABCD'));
      });

      test('should return AR- with full ID for short IDs', () {
        const entity = AirlineRouteEntity(
          id: '0125',
          routeId: 'rt001',
          airlineId: 'air001',
        );

        expect(entity.displayId, equals('AR-0125'));
      });
    });

    group('routeDisplay', () {
      test('should return formatted route with arrow', () {
        const entity = AirlineRouteEntity(
          id: 'test',
          routeId: 'rt001',
          airlineId: 'air001',
          originAirportCode: 'BOG',
          destinationAirportCode: 'MDE',
        );

        expect(entity.routeDisplay, equals('BOG → MDE'));
      });

      test('should return routeName when codes are null', () {
        const entity = AirlineRouteEntity(
          id: 'test',
          routeId: 'rt001',
          airlineId: 'air001',
          routeName: 'New York to Los Angeles',
        );

        expect(entity.routeDisplay, equals('New York to Los Angeles'));
      });

      test('should return Unknown Route when no info', () {
        const entity = AirlineRouteEntity(
          id: 'test',
          routeId: 'rt001',
          airlineId: 'air001',
        );

        expect(entity.routeDisplay, equals('Unknown Route'));
      });
    });

    group('displayStatus', () {
      test('should return Active for active status', () {
        const entity = AirlineRouteEntity(
          id: 'test',
          routeId: 'rt001',
          airlineId: 'air001',
          status: 'active',
        );

        expect(entity.displayStatus, equals('Active'));
      });

      test('should return Inactive for inactive status', () {
        const entity = AirlineRouteEntity(
          id: 'test',
          routeId: 'rt001',
          airlineId: 'air001',
          status: 'inactive',
        );

        expect(entity.displayStatus, equals('Inactive'));
      });

      test('should return Pending for pending status', () {
        const entity = AirlineRouteEntity(
          id: 'test',
          routeId: 'rt001',
          airlineId: 'air001',
          status: 'pending',
        );

        expect(entity.displayStatus, equals('Pending'));
      });

      test('should return Unknown for null status', () {
        const entity = AirlineRouteEntity(
          id: 'test',
          routeId: 'rt001',
          airlineId: 'air001',
        );

        expect(entity.displayStatus, equals('Unknown'));
      });

      test('should handle case-insensitive status', () {
        const entity = AirlineRouteEntity(
          id: 'test',
          routeId: 'rt001',
          airlineId: 'air001',
          status: 'ACTIVE',
        );

        expect(entity.displayStatus, equals('Active'));
      });
    });

    group('status checks', () {
      test('isActive should return true for active status', () {
        const entity = AirlineRouteEntity(
          id: 'test',
          routeId: 'rt001',
          airlineId: 'air001',
          status: 'active',
        );

        expect(entity.isActive, isTrue);
        expect(entity.isInactive, isFalse);
        expect(entity.isPending, isFalse);
      });

      test('isInactive should return true for inactive status', () {
        const entity = AirlineRouteEntity(
          id: 'test',
          routeId: 'rt001',
          airlineId: 'air001',
          status: 'inactive',
        );

        expect(entity.isActive, isFalse);
        expect(entity.isInactive, isTrue);
        expect(entity.isPending, isFalse);
      });

      test('isPending should return true for pending status', () {
        const entity = AirlineRouteEntity(
          id: 'test',
          routeId: 'rt001',
          airlineId: 'air001',
          status: 'pending',
        );

        expect(entity.isActive, isFalse);
        expect(entity.isInactive, isFalse);
        expect(entity.isPending, isTrue);
      });
    });

    test('props should contain all fields for Equatable', () {
      const entity = AirlineRouteEntity(
        id: 'test',
        uuid: 'uuid',
        routeId: 'rt001',
        airlineId: 'air001',
        routeName: 'Name',
        airlineName: 'Airline',
        originAirportCode: 'BOG',
        destinationAirportCode: 'MDE',
        status: 'active',
      );

      expect(entity.props.length, equals(9));
    });
  });
}
