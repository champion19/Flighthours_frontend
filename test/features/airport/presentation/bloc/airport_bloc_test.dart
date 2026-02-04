import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_event.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_state.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';

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
}
