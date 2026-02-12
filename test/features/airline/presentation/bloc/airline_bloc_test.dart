import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_model.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/activate_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/deactivate_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/get_airline_by_id_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/list_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_bloc.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_event.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_state.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';

class MockListAirlineUseCase extends Mock implements ListAirlineUseCase {}

class MockGetAirlineByIdUseCase extends Mock implements GetAirlineByIdUseCase {}

class MockActivateAirlineUseCase extends Mock
    implements ActivateAirlineUseCase {}

class MockDeactivateAirlineUseCase extends Mock
    implements DeactivateAirlineUseCase {}

void main() {
  group('AirlineEvent', () {
    test('FetchAirlines should be a valid event', () {
      final event = FetchAirlines();
      expect(event, isA<AirlineEvent>());
      expect(event.props, isEmpty);
    });

    group('FetchAirlineById', () {
      test('should create with required airlineId', () {
        const event = FetchAirlineById(airlineId: 'airline123');

        expect(event.airlineId, equals('airline123'));
      });

      test('props should contain airlineId', () {
        const event = FetchAirlineById(airlineId: 'airline123');

        expect(event.props.length, equals(1));
        expect(event.props, contains('airline123'));
      });

      test('two events with same id should be equal', () {
        const event1 = FetchAirlineById(airlineId: 'abc');
        const event2 = FetchAirlineById(airlineId: 'abc');

        expect(event1, equals(event2));
      });
    });

    group('ActivateAirline', () {
      test('should create with required airlineId', () {
        const event = ActivateAirline(airlineId: 'airline456');

        expect(event.airlineId, equals('airline456'));
      });

      test('props should contain airlineId', () {
        const event = ActivateAirline(airlineId: 'id123');

        expect(event.props.length, equals(1));
      });
    });

    group('DeactivateAirline', () {
      test('should create with required airlineId', () {
        const event = DeactivateAirline(airlineId: 'airline789');

        expect(event.airlineId, equals('airline789'));
      });

      test('props should contain airlineId', () {
        const event = DeactivateAirline(airlineId: 'id456');

        expect(event.props.length, equals(1));
      });
    });
  });

  group('AirlineState', () {
    test('AirlineInitial should be a valid state', () {
      final state = AirlineInitial();
      expect(state, isA<AirlineState>());
      expect(state.props, isEmpty);
    });

    test('AirlineLoading should be a valid state', () {
      final state = AirlineLoading();
      expect(state, isA<AirlineState>());
    });

    group('AirlineSuccess', () {
      test('should create with airlines list', () {
        const airlines = [
          AirlineEntity(id: '1', name: 'Avianca'),
          AirlineEntity(id: '2', name: 'LATAM'),
        ];

        const state = AirlineSuccess(airlines);

        expect(state.airlines.length, equals(2));
        expect(state.airlines.first.name, equals('Avianca'));
      });

      test('props should contain airlines', () {
        const state = AirlineSuccess([]);

        expect(state.props.length, equals(1));
      });
    });

    group('AirlineDetailSuccess', () {
      test('should create with airline entity', () {
        const airline = AirlineEntity(id: '1', name: 'Avianca');

        const state = AirlineDetailSuccess(airline);

        expect(state.airline.id, equals('1'));
        expect(state.airline.name, equals('Avianca'));
      });

      test('props should contain airline', () {
        const airline = AirlineEntity(id: '1', name: 'Test');
        const state = AirlineDetailSuccess(airline);

        expect(state.props.length, equals(1));
      });
    });

    group('AirlineError', () {
      test('should create with message', () {
        const state = AirlineError('Network error');

        expect(state.message, equals('Network error'));
      });

      test('props should contain message', () {
        const state = AirlineError('Error');

        expect(state.props.length, equals(1));
      });
    });

    group('AirlineStatusUpdating', () {
      test('should create with airlineId', () {
        const state = AirlineStatusUpdating(airlineId: 'airline123');

        expect(state.airlineId, equals('airline123'));
      });
    });

    group('AirlineStatusUpdateSuccess', () {
      test('should create with message, code and optional newStatus', () {
        const state = AirlineStatusUpdateSuccess(
          message: 'Activated',
          code: 'OK',
          newStatus: 'active',
        );

        expect(state.message, equals('Activated'));
        expect(state.code, equals('OK'));
        expect(state.newStatus, equals('active'));
      });

      test('props should contain message and code', () {
        const state = AirlineStatusUpdateSuccess(message: 'msg', code: 'code');

        expect(state.props.length, equals(2));
      });
    });

    group('AirlineStatusUpdateError', () {
      test('should create with message and code', () {
        const state = AirlineStatusUpdateError(
          message: 'Failed',
          code: 'ERR001',
        );

        expect(state.message, equals('Failed'));
        expect(state.code, equals('ERR001'));
      });
    });
  });

  // Tests for AirlineBloc logic using bloc_test
  group('AirlineBloc', () {
    late MockListAirlineUseCase mockListUseCase;
    late MockGetAirlineByIdUseCase mockGetByIdUseCase;
    late MockActivateAirlineUseCase mockActivateUseCase;
    late MockDeactivateAirlineUseCase mockDeactivateUseCase;

    setUp(() {
      mockListUseCase = MockListAirlineUseCase();
      mockGetByIdUseCase = MockGetAirlineByIdUseCase();
      mockActivateUseCase = MockActivateAirlineUseCase();
      mockDeactivateUseCase = MockDeactivateAirlineUseCase();
    });

    test('initial state should be AirlineInitial', () {
      final bloc = AirlineBloc(
        listAirlineUseCase: mockListUseCase,
        getAirlineByIdUseCase: mockGetByIdUseCase,
        activateAirlineUseCase: mockActivateUseCase,
        deactivateAirlineUseCase: mockDeactivateUseCase,
      );
      expect(bloc.state, isA<AirlineInitial>());
    });

    blocTest<AirlineBloc, AirlineState>(
      'emits [Loading, Success] when FetchAirlines succeeds',
      setUp: () {
        when(() => mockListUseCase.call()).thenAnswer(
          (_) async => const Right([
            AirlineModel(id: 'a1', name: 'Avianca', code: 'AV'),
          ]),
        );
      },
      build:
          () => AirlineBloc(
            listAirlineUseCase: mockListUseCase,
            getAirlineByIdUseCase: mockGetByIdUseCase,
            activateAirlineUseCase: mockActivateUseCase,
            deactivateAirlineUseCase: mockDeactivateUseCase,
          ),
      act: (bloc) => bloc.add(FetchAirlines()),
      expect: () => [isA<AirlineLoading>(), isA<AirlineSuccess>()],
    );

    blocTest<AirlineBloc, AirlineState>(
      'emits [Loading, Error] when FetchAirlines fails',
      setUp: () {
        when(() => mockListUseCase.call()).thenAnswer(
          (_) async => const Left(Failure(message: 'Failed to load airlines')),
        );
      },
      build:
          () => AirlineBloc(
            listAirlineUseCase: mockListUseCase,
            getAirlineByIdUseCase: mockGetByIdUseCase,
            activateAirlineUseCase: mockActivateUseCase,
            deactivateAirlineUseCase: mockDeactivateUseCase,
          ),
      act: (bloc) => bloc.add(FetchAirlines()),
      expect: () => [isA<AirlineLoading>(), isA<AirlineError>()],
    );

    blocTest<AirlineBloc, AirlineState>(
      'emits [DetailSuccess] when FetchAirlineById succeeds',
      setUp: () {
        when(() => mockGetByIdUseCase.call(any())).thenAnswer(
          (_) async =>
              const Right(AirlineModel(id: 'a1', name: 'Avianca', code: 'AV')),
        );
      },
      build:
          () => AirlineBloc(
            listAirlineUseCase: mockListUseCase,
            getAirlineByIdUseCase: mockGetByIdUseCase,
            activateAirlineUseCase: mockActivateUseCase,
            deactivateAirlineUseCase: mockDeactivateUseCase,
          ),
      act: (bloc) => bloc.add(const FetchAirlineById(airlineId: 'a1')),
      expect: () => [isA<AirlineDetailSuccess>()],
    );

    blocTest<AirlineBloc, AirlineState>(
      'emits [Updating, UpdateSuccess] when ActivateAirline succeeds',
      setUp: () {
        when(() => mockActivateUseCase.call(any())).thenAnswer(
          (_) async => Right(
            AirlineStatusResponseModel(
              success: true,
              code: 'ACTIVATED',
              message: 'Airline activated',
            ),
          ),
        );
      },
      build:
          () => AirlineBloc(
            listAirlineUseCase: mockListUseCase,
            getAirlineByIdUseCase: mockGetByIdUseCase,
            activateAirlineUseCase: mockActivateUseCase,
            deactivateAirlineUseCase: mockDeactivateUseCase,
          ),
      act: (bloc) => bloc.add(const ActivateAirline(airlineId: 'a1')),
      expect:
          () => [
            isA<AirlineStatusUpdating>(),
            isA<AirlineStatusUpdateSuccess>(),
          ],
    );

    blocTest<AirlineBloc, AirlineState>(
      'emits [Updating, UpdateError] when DeactivateAirline fails',
      setUp: () {
        when(() => mockDeactivateUseCase.call(any())).thenAnswer(
          (_) async => Right(
            AirlineStatusResponseModel(
              success: false,
              code: 'ALREADY_INACTIVE',
              message: 'Already inactive',
            ),
          ),
        );
      },
      build:
          () => AirlineBloc(
            listAirlineUseCase: mockListUseCase,
            getAirlineByIdUseCase: mockGetByIdUseCase,
            activateAirlineUseCase: mockActivateUseCase,
            deactivateAirlineUseCase: mockDeactivateUseCase,
          ),
      act: (bloc) => bloc.add(const DeactivateAirline(airlineId: 'a1')),
      expect:
          () => [isA<AirlineStatusUpdating>(), isA<AirlineStatusUpdateError>()],
    );
  });
}
