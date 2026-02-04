import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_model.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/activate_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/deactivate_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/get_airport_by_id_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/list_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_bloc.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_event.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_state.dart';

class MockListAirportUseCase extends Mock implements ListAirportUseCase {}

class MockGetAirportByIdUseCase extends Mock implements GetAirportByIdUseCase {}

class MockActivateAirportUseCase extends Mock
    implements ActivateAirportUseCase {}

class MockDeactivateAirportUseCase extends Mock
    implements DeactivateAirportUseCase {}

void main() {
  group('AirportEvent', () {
    test('FetchAirports should be a valid event', () {
      final event = FetchAirports();
      expect(event, isA<AirportEvent>());
      expect(event.props, isEmpty);
    });

    group('FetchAirportById', () {
      test('should create with required airportId', () {
        const event = FetchAirportById(airportId: 'airport123');

        expect(event.airportId, equals('airport123'));
      });

      test('props should contain airportId', () {
        const event = FetchAirportById(airportId: 'airport123');

        expect(event.props.length, equals(1));
        expect(event.props, contains('airport123'));
      });

      test('two events with same id should be equal', () {
        const event1 = FetchAirportById(airportId: 'abc');
        const event2 = FetchAirportById(airportId: 'abc');

        expect(event1, equals(event2));
      });
    });

    group('ActivateAirport', () {
      test('should create with required airportId', () {
        const event = ActivateAirport(airportId: 'airport456');

        expect(event.airportId, equals('airport456'));
      });

      test('props should contain airportId', () {
        const event = ActivateAirport(airportId: 'id123');

        expect(event.props.length, equals(1));
      });
    });

    group('DeactivateAirport', () {
      test('should create with required airportId', () {
        const event = DeactivateAirport(airportId: 'airport789');

        expect(event.airportId, equals('airport789'));
      });

      test('props should contain airportId', () {
        const event = DeactivateAirport(airportId: 'id456');

        expect(event.props.length, equals(1));
      });
    });
  });

  group('AirportState', () {
    test('AirportInitial should be a valid state', () {
      final state = AirportInitial();
      expect(state, isA<AirportState>());
      expect(state.props, isEmpty);
    });

    test('AirportLoading should be a valid state', () {
      final state = AirportLoading();
      expect(state, isA<AirportState>());
    });

    group('AirportSuccess', () {
      test('should create with airports list', () {
        const airports = [
          AirportEntity(id: '1', name: 'JFK Airport', status: 'active'),
          AirportEntity(id: '2', name: 'LAX Airport', status: 'inactive'),
        ];

        const state = AirportSuccess(airports);

        expect(state.airports.length, equals(2));
        expect(state.airports.first.name, equals('JFK Airport'));
      });

      test('props should contain airports', () {
        const state = AirportSuccess([]);

        expect(state.props.length, equals(1));
      });
    });

    group('AirportDetailSuccess', () {
      test('should create with airport entity', () {
        const airport = AirportEntity(
          id: '1',
          name: 'Bogotá El Dorado',
          status: 'active',
        );

        const state = AirportDetailSuccess(airport);

        expect(state.airport.id, equals('1'));
        expect(state.airport.name, equals('Bogotá El Dorado'));
      });

      test('props should contain airport', () {
        const airport = AirportEntity(id: '1', name: 'Test', status: 'active');
        const state = AirportDetailSuccess(airport);

        expect(state.props.length, equals(1));
      });
    });

    group('AirportStatusUpdateSuccess', () {
      test('should create with response and isActivation flag', () {
        final response = AirportStatusResponseModel(
          success: true,
          code: 'OK',
          message: 'Airport activated',
        );

        final state = AirportStatusUpdateSuccess(response, isActivation: true);

        expect(state.response.success, isTrue);
        expect(state.isActivation, isTrue);
      });

      test('props should contain response and isActivation', () {
        final response = AirportStatusResponseModel(
          success: true,
          code: 'OK',
          message: 'msg',
        );
        final state = AirportStatusUpdateSuccess(response, isActivation: false);

        expect(state.props.length, equals(2));
      });
    });

    group('AirportError', () {
      test('should create with message', () {
        const state = AirportError('Network error');

        expect(state.message, equals('Network error'));
      });

      test('props should contain message', () {
        const state = AirportError('Error');

        expect(state.props.length, equals(1));
      });
    });
  });

  // Tests for AirportBloc logic using bloc_test
  group('AirportBloc', () {
    late MockListAirportUseCase mockListUseCase;
    late MockGetAirportByIdUseCase mockGetByIdUseCase;
    late MockActivateAirportUseCase mockActivateUseCase;
    late MockDeactivateAirportUseCase mockDeactivateUseCase;

    setUp(() {
      mockListUseCase = MockListAirportUseCase();
      mockGetByIdUseCase = MockGetAirportByIdUseCase();
      mockActivateUseCase = MockActivateAirportUseCase();
      mockDeactivateUseCase = MockDeactivateAirportUseCase();
    });

    test('initial state should be AirportInitial', () {
      final bloc = AirportBloc(
        listAirportUseCase: mockListUseCase,
        getAirportByIdUseCase: mockGetByIdUseCase,
        activateAirportUseCase: mockActivateUseCase,
        deactivateAirportUseCase: mockDeactivateUseCase,
      );
      expect(bloc.state, isA<AirportInitial>());
    });

    blocTest<AirportBloc, AirportState>(
      'emits [Loading, Success] when FetchAirports succeeds',
      setUp: () {
        when(() => mockListUseCase.call()).thenAnswer(
          (_) async => [
            const AirportModel(id: 'ap1', name: 'El Dorado', iataCode: 'BOG'),
          ],
        );
      },
      build:
          () => AirportBloc(
            listAirportUseCase: mockListUseCase,
            getAirportByIdUseCase: mockGetByIdUseCase,
            activateAirportUseCase: mockActivateUseCase,
            deactivateAirportUseCase: mockDeactivateUseCase,
          ),
      act: (bloc) => bloc.add(FetchAirports()),
      expect: () => [isA<AirportLoading>(), isA<AirportSuccess>()],
    );

    blocTest<AirportBloc, AirportState>(
      'emits [Loading, Error] when FetchAirports fails',
      setUp: () {
        when(
          () => mockListUseCase.call(),
        ).thenThrow(Exception('Failed to load airports'));
      },
      build:
          () => AirportBloc(
            listAirportUseCase: mockListUseCase,
            getAirportByIdUseCase: mockGetByIdUseCase,
            activateAirportUseCase: mockActivateUseCase,
            deactivateAirportUseCase: mockDeactivateUseCase,
          ),
      act: (bloc) => bloc.add(FetchAirports()),
      expect: () => [isA<AirportLoading>(), isA<AirportError>()],
    );

    blocTest<AirportBloc, AirportState>(
      'emits [DetailSuccess] when FetchAirportById succeeds',
      setUp: () {
        when(() => mockGetByIdUseCase.call(any())).thenAnswer(
          (_) async =>
              const AirportModel(id: 'ap1', name: 'El Dorado', iataCode: 'BOG'),
        );
      },
      build:
          () => AirportBloc(
            listAirportUseCase: mockListUseCase,
            getAirportByIdUseCase: mockGetByIdUseCase,
            activateAirportUseCase: mockActivateUseCase,
            deactivateAirportUseCase: mockDeactivateUseCase,
          ),
      act: (bloc) => bloc.add(const FetchAirportById(airportId: 'ap1')),
      expect: () => [isA<AirportDetailSuccess>()],
    );

    blocTest<AirportBloc, AirportState>(
      'emits [Loading, StatusUpdateSuccess] when ActivateAirport succeeds',
      setUp: () {
        when(() => mockActivateUseCase.call(any())).thenAnswer(
          (_) async => AirportStatusResponseModel(
            success: true,
            code: 'ACTIVATED',
            message: 'Airport activated',
          ),
        );
      },
      build:
          () => AirportBloc(
            listAirportUseCase: mockListUseCase,
            getAirportByIdUseCase: mockGetByIdUseCase,
            activateAirportUseCase: mockActivateUseCase,
            deactivateAirportUseCase: mockDeactivateUseCase,
          ),
      act: (bloc) => bloc.add(const ActivateAirport(airportId: 'ap1')),
      expect: () => [isA<AirportLoading>(), isA<AirportStatusUpdateSuccess>()],
    );

    blocTest<AirportBloc, AirportState>(
      'emits [Loading, Error] when DeactivateAirport fails',
      setUp: () {
        when(() => mockDeactivateUseCase.call(any())).thenAnswer(
          (_) async => AirportStatusResponseModel(
            success: false,
            code: 'ALREADY_INACTIVE',
            message: 'Already inactive',
          ),
        );
      },
      build:
          () => AirportBloc(
            listAirportUseCase: mockListUseCase,
            getAirportByIdUseCase: mockGetByIdUseCase,
            activateAirportUseCase: mockActivateUseCase,
            deactivateAirportUseCase: mockDeactivateUseCase,
          ),
      act: (bloc) => bloc.add(const DeactivateAirport(airportId: 'ap1')),
      expect: () => [isA<AirportLoading>(), isA<AirportError>()],
    );
  });
}
