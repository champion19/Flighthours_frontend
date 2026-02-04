import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airline_route/presentation/bloc/airline_route_event.dart';
import 'package:flight_hours_app/features/airline_route/presentation/bloc/airline_route_state.dart';
import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';

void main() {
  group('AirlineRouteEvent', () {
    test('FetchAirlineRoutes should be a valid event', () {
      final event = FetchAirlineRoutes();
      expect(event, isA<AirlineRouteEvent>());
      expect(event.props, isEmpty);
    });

    group('FetchAirlineRouteById', () {
      test('should create with required airlineRouteId', () {
        const event = FetchAirlineRouteById(airlineRouteId: 'ar123');

        expect(event.airlineRouteId, equals('ar123'));
      });

      test('props should contain airlineRouteId', () {
        const event = FetchAirlineRouteById(airlineRouteId: 'ar123');

        expect(event.props.length, equals(1));
        expect(event.props, contains('ar123'));
      });
    });

    group('SearchAirlineRoutes', () {
      test('should create with required query', () {
        const event = SearchAirlineRoutes(query: 'JFK-LHR');

        expect(event.query, equals('JFK-LHR'));
      });

      test('props should contain query', () {
        const event = SearchAirlineRoutes(query: 'search');

        expect(event.props.length, equals(1));
      });
    });

    group('ActivateAirlineRoute', () {
      test('should create with required airlineRouteId', () {
        const event = ActivateAirlineRoute(airlineRouteId: 'ar456');

        expect(event.airlineRouteId, equals('ar456'));
      });

      test('props should contain airlineRouteId', () {
        const event = ActivateAirlineRoute(airlineRouteId: 'id1');

        expect(event.props.length, equals(1));
      });
    });

    group('DeactivateAirlineRoute', () {
      test('should create with required airlineRouteId', () {
        const event = DeactivateAirlineRoute(airlineRouteId: 'ar789');

        expect(event.airlineRouteId, equals('ar789'));
      });

      test('props should contain airlineRouteId', () {
        const event = DeactivateAirlineRoute(airlineRouteId: 'id2');

        expect(event.props.length, equals(1));
      });
    });
  });

  group('AirlineRouteState', () {
    test('AirlineRouteInitial should be a valid state', () {
      final state = AirlineRouteInitial();
      expect(state, isA<AirlineRouteState>());
      expect(state.props, isEmpty);
    });

    test('AirlineRouteLoading should be a valid state', () {
      final state = AirlineRouteLoading();
      expect(state, isA<AirlineRouteState>());
    });

    group('AirlineRouteSuccess', () {
      test('should create with airlineRoutes list', () {
        const routes = [
          AirlineRouteEntity(id: '1', routeId: 'r1', airlineId: 'a1'),
          AirlineRouteEntity(id: '2', routeId: 'r2', airlineId: 'a1'),
        ];

        const state = AirlineRouteSuccess(routes);

        expect(state.airlineRoutes.length, equals(2));
      });

      test('props should contain airlineRoutes', () {
        const state = AirlineRouteSuccess([]);

        expect(state.props.length, equals(1));
      });
    });

    group('AirlineRouteDetailSuccess', () {
      test('should create with airlineRoute entity', () {
        const route = AirlineRouteEntity(
          id: 'ar1',
          routeId: 'r1',
          airlineId: 'a1',
          originAirportCode: 'JFK',
          destinationAirportCode: 'LHR',
        );

        const state = AirlineRouteDetailSuccess(route);

        expect(state.airlineRoute.id, equals('ar1'));
      });

      test('props should contain airlineRoute', () {
        const route = AirlineRouteEntity(id: '1', routeId: 'r', airlineId: 'a');
        const state = AirlineRouteDetailSuccess(route);

        expect(state.props.length, equals(1));
      });
    });

    group('AirlineRouteError', () {
      test('should create with message', () {
        const state = AirlineRouteError('Network error');

        expect(state.message, equals('Network error'));
      });

      test('props should contain message', () {
        const state = AirlineRouteError('Error');

        expect(state.props.length, equals(1));
      });
    });

    test('AirlineRouteStatusUpdating should be a valid state', () {
      final state = AirlineRouteStatusUpdating();
      expect(state, isA<AirlineRouteState>());
    });

    group('AirlineRouteStatusUpdateSuccess', () {
      test('should create with message', () {
        const state = AirlineRouteStatusUpdateSuccess('Route activated');

        expect(state.message, equals('Route activated'));
      });

      test('props should contain message', () {
        const state = AirlineRouteStatusUpdateSuccess('msg');

        expect(state.props.length, equals(1));
      });
    });

    group('AirlineRouteStatusUpdateError', () {
      test('should create with message', () {
        const state = AirlineRouteStatusUpdateError('Activation failed');

        expect(state.message, equals('Activation failed'));
      });

      test('props should contain message', () {
        const state = AirlineRouteStatusUpdateError('error');

        expect(state.props.length, equals(1));
      });
    });
  });
}
