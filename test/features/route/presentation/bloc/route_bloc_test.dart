import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/route/data/models/route_model.dart';
import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';
import 'package:flight_hours_app/features/route/domain/usecases/get_route_by_id_use_case.dart';
import 'package:flight_hours_app/features/route/domain/usecases/list_routes_use_case.dart';
import 'package:flight_hours_app/features/route/presentation/bloc/route_bloc.dart';
import 'package:flight_hours_app/features/route/presentation/bloc/route_event.dart';
import 'package:flight_hours_app/features/route/presentation/bloc/route_state.dart';

class MockListRoutesUseCase extends Mock implements ListRoutesUseCase {}

class MockGetRouteByIdUseCase extends Mock implements GetRouteByIdUseCase {}

void main() {
  group('RouteEvent', () {
    test('FetchRoutes should be a valid event', () {
      final event = FetchRoutes();
      expect(event, isA<RouteEvent>());
      expect(event.props, isEmpty);
    });

    group('FetchRouteById', () {
      test('should create with required routeId', () {
        const event = FetchRouteById(routeId: 'route123');
        expect(event.routeId, equals('route123'));
      });

      test('props should contain routeId', () {
        const event = FetchRouteById(routeId: 'route123');
        expect(event.props.length, equals(1));
        expect(event.props, contains('route123'));
      });

      test('two events with same id should be equal', () {
        const event1 = FetchRouteById(routeId: 'abc');
        const event2 = FetchRouteById(routeId: 'abc');
        expect(event1, equals(event2));
      });
    });

    group('SearchRoutes', () {
      test('should create with required query', () {
        const event = SearchRoutes(query: 'JFK');
        expect(event.query, equals('JFK'));
      });

      test('props should contain query', () {
        const event = SearchRoutes(query: 'search term');
        expect(event.props.length, equals(1));
      });
    });
  });

  group('RouteState', () {
    test('RouteInitial should be a valid state', () {
      final state = RouteInitial();
      expect(state, isA<RouteState>());
      expect(state.props, isEmpty);
    });

    test('RouteLoading should be a valid state', () {
      final state = RouteLoading();
      expect(state, isA<RouteState>());
    });

    group('RouteSuccess', () {
      test('should create with routes list', () {
        const routes = [
          RouteEntity(
            id: '1',
            originAirportId: 'o1',
            destinationAirportId: 'd1',
          ),
          RouteEntity(
            id: '2',
            originAirportId: 'o2',
            destinationAirportId: 'd2',
          ),
        ];

        const state = RouteSuccess(routes);
        expect(state.routes.length, equals(2));
        expect(state.routes.first.id, equals('1'));
      });

      test('props should contain routes', () {
        const state = RouteSuccess([]);
        expect(state.props.length, equals(1));
      });
    });

    group('RouteDetailSuccess', () {
      test('should create with route entity', () {
        const route = RouteEntity(
          id: 'route1',
          originAirportId: 'jfk',
          destinationAirportId: 'lhr',
          originAirportCode: 'JFK',
          destinationAirportCode: 'LHR',
        );

        const state = RouteDetailSuccess(route);
        expect(state.route.id, equals('route1'));
        expect(state.route.originAirportCode, equals('JFK'));
      });

      test('props should contain route', () {
        const route = RouteEntity(
          id: '1',
          originAirportId: 'o1',
          destinationAirportId: 'd1',
        );
        const state = RouteDetailSuccess(route);
        expect(state.props.length, equals(1));
      });
    });

    group('RouteError', () {
      test('should create with message', () {
        const state = RouteError('Network error');
        expect(state.message, equals('Network error'));
      });

      test('props should contain message', () {
        const state = RouteError('Error');
        expect(state.props.length, equals(1));
      });
    });
  });

  group('RouteBloc', () {
    late MockListRoutesUseCase mockListUseCase;
    late MockGetRouteByIdUseCase mockGetByIdUseCase;

    setUp(() {
      mockListUseCase = MockListRoutesUseCase();
      mockGetByIdUseCase = MockGetRouteByIdUseCase();
    });

    test('initial state should be RouteInitial', () {
      final bloc = RouteBloc(
        listRoutesUseCase: mockListUseCase,
        getRouteByIdUseCase: mockGetByIdUseCase,
      );
      expect(bloc.state, isA<RouteInitial>());
    });

    blocTest<RouteBloc, RouteState>(
      'emits [Loading, Success] when FetchRoutes succeeds',
      setUp: () {
        when(() => mockListUseCase.call()).thenAnswer(
          (_) async => const Right([
            RouteModel(
              id: 'r1',
              originAirportId: 'o1',
              destinationAirportId: 'd1',
            ),
          ]),
        );
      },
      build:
          () => RouteBloc(
            listRoutesUseCase: mockListUseCase,
            getRouteByIdUseCase: mockGetByIdUseCase,
          ),
      act: (bloc) => bloc.add(FetchRoutes()),
      expect: () => [isA<RouteLoading>(), isA<RouteSuccess>()],
    );

    blocTest<RouteBloc, RouteState>(
      'emits [Loading, Error] when FetchRoutes fails',
      setUp: () {
        when(() => mockListUseCase.call()).thenAnswer(
          (_) async => const Left(Failure(message: 'Failed to load routes')),
        );
      },
      build:
          () => RouteBloc(
            listRoutesUseCase: mockListUseCase,
            getRouteByIdUseCase: mockGetByIdUseCase,
          ),
      act: (bloc) => bloc.add(FetchRoutes()),
      expect: () => [isA<RouteLoading>(), isA<RouteError>()],
    );

    blocTest<RouteBloc, RouteState>(
      'emits [DetailSuccess] when FetchRouteById succeeds',
      setUp: () {
        when(() => mockGetByIdUseCase.call(any())).thenAnswer(
          (_) async => const Right(
            RouteModel(
              id: 'r1',
              originAirportId: 'o1',
              destinationAirportId: 'd1',
            ),
          ),
        );
      },
      build:
          () => RouteBloc(
            listRoutesUseCase: mockListUseCase,
            getRouteByIdUseCase: mockGetByIdUseCase,
          ),
      act: (bloc) => bloc.add(const FetchRouteById(routeId: 'r1')),
      expect: () => [isA<RouteDetailSuccess>()],
    );

    blocTest<RouteBloc, RouteState>(
      'emits nothing when FetchRouteById returns Left',
      setUp: () {
        when(() => mockGetByIdUseCase.call(any())).thenAnswer(
          (_) async =>
              const Left(Failure(message: 'Route not found', statusCode: 404)),
        );
      },
      build:
          () => RouteBloc(
            listRoutesUseCase: mockListUseCase,
            getRouteByIdUseCase: mockGetByIdUseCase,
          ),
      act: (bloc) => bloc.add(const FetchRouteById(routeId: 'notfound')),
      expect: () => [],
    );
  });
}
