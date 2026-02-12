import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airline_route/data/datasources/airline_route_remote_data_source.dart';
import 'package:flight_hours_app/features/airline_route/domain/usecases/list_airline_routes_use_case.dart';
import 'package:flight_hours_app/features/airline_route/domain/usecases/get_airline_route_by_id_use_case.dart';
import 'package:flight_hours_app/features/airline_route/presentation/bloc/airline_route_bloc.dart';
import 'package:flight_hours_app/features/airline_route/presentation/bloc/airline_route_event.dart';
import 'package:flight_hours_app/features/airline_route/presentation/bloc/airline_route_state.dart';
import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';

class MockListAirlineRoutesUseCase extends Mock
    implements ListAirlineRoutesUseCase {}

class MockGetAirlineRouteByIdUseCase extends Mock
    implements GetAirlineRouteByIdUseCase {}

class MockAirlineRouteRemoteDataSource extends Mock
    implements AirlineRouteRemoteDataSource {}

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

  group('AirlineRouteBloc', () {
    late MockListAirlineRoutesUseCase mockListUseCase;
    late MockGetAirlineRouteByIdUseCase mockGetByIdUseCase;
    late MockAirlineRouteRemoteDataSource mockDataSource;

    setUp(() {
      mockListUseCase = MockListAirlineRoutesUseCase();
      mockGetByIdUseCase = MockGetAirlineRouteByIdUseCase();
      mockDataSource = MockAirlineRouteRemoteDataSource();
    });

    test('initial state should be AirlineRouteInitial', () {
      final bloc = AirlineRouteBloc(
        listAirlineRoutesUseCase: mockListUseCase,
        getAirlineRouteByIdUseCase: mockGetByIdUseCase,
        dataSource: mockDataSource,
      );
      expect(bloc.state, isA<AirlineRouteInitial>());
    });

    blocTest<AirlineRouteBloc, AirlineRouteState>(
      'emits [Loading, Success] when FetchAirlineRoutes succeeds',
      setUp: () {
        when(() => mockListUseCase.call()).thenAnswer(
          (_) async => const Right([
            AirlineRouteEntity(id: 'ar1', routeId: 'r1', airlineId: 'a1'),
          ]),
        );
      },
      build:
          () => AirlineRouteBloc(
            listAirlineRoutesUseCase: mockListUseCase,
            getAirlineRouteByIdUseCase: mockGetByIdUseCase,
            dataSource: mockDataSource,
          ),
      act: (bloc) => bloc.add(FetchAirlineRoutes()),
      expect: () => [isA<AirlineRouteLoading>(), isA<AirlineRouteSuccess>()],
    );

    blocTest<AirlineRouteBloc, AirlineRouteState>(
      'emits [Loading, Error] when FetchAirlineRoutes fails',
      setUp: () {
        when(() => mockListUseCase.call()).thenAnswer(
          (_) async => const Left(Failure(message: 'Failed to load routes')),
        );
      },
      build:
          () => AirlineRouteBloc(
            listAirlineRoutesUseCase: mockListUseCase,
            getAirlineRouteByIdUseCase: mockGetByIdUseCase,
            dataSource: mockDataSource,
          ),
      act: (bloc) => bloc.add(FetchAirlineRoutes()),
      expect: () => [isA<AirlineRouteLoading>(), isA<AirlineRouteError>()],
    );

    blocTest<AirlineRouteBloc, AirlineRouteState>(
      'emits [DetailSuccess] when FetchAirlineRouteById succeeds',
      setUp: () {
        when(() => mockGetByIdUseCase.call(any())).thenAnswer(
          (_) async => const Right(
            AirlineRouteEntity(id: 'ar1', routeId: 'r1', airlineId: 'a1'),
          ),
        );
      },
      build:
          () => AirlineRouteBloc(
            listAirlineRoutesUseCase: mockListUseCase,
            getAirlineRouteByIdUseCase: mockGetByIdUseCase,
            dataSource: mockDataSource,
          ),
      act:
          (bloc) =>
              bloc.add(const FetchAirlineRouteById(airlineRouteId: 'ar1')),
      expect: () => [isA<AirlineRouteDetailSuccess>()],
    );

    blocTest<AirlineRouteBloc, AirlineRouteState>(
      'emits nothing when FetchAirlineRouteById returns Left',
      setUp: () {
        when(() => mockGetByIdUseCase.call(any())).thenAnswer(
          (_) async =>
              const Left(Failure(message: 'Route not found', statusCode: 404)),
        );
      },
      build:
          () => AirlineRouteBloc(
            listAirlineRoutesUseCase: mockListUseCase,
            getAirlineRouteByIdUseCase: mockGetByIdUseCase,
            dataSource: mockDataSource,
          ),
      act:
          (bloc) =>
              bloc.add(const FetchAirlineRouteById(airlineRouteId: 'notfound')),
      expect: () => [],
    );
  });
}
