import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_event.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_state.dart';
import 'package:flight_hours_app/features/employee/data/models/change_password_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_model.dart';

void main() {
  group('EmployeeEvent', () {
    test('LoadCurrentEmployee should be a valid event', () {
      final event = LoadCurrentEmployee();
      expect(event, isA<EmployeeEvent>());
      expect(event.props, isEmpty);
    });

    test('LoadEmployeeAirline should be a valid event', () {
      final event = LoadEmployeeAirline();
      expect(event, isA<EmployeeEvent>());
    });

    test('DeleteEmployee should be a valid event', () {
      final event = DeleteEmployee();
      expect(event, isA<EmployeeEvent>());
    });

    test('LoadEmployeeAirlineRoutes should be a valid event', () {
      final event = LoadEmployeeAirlineRoutes();
      expect(event, isA<EmployeeEvent>());
    });

    test('ResetEmployeeState should be a valid event', () {
      final event = ResetEmployeeState();
      expect(event, isA<EmployeeEvent>());
    });

    group('UpdateEmployee', () {
      test('should create with request', () {
        final request = EmployeeUpdateRequest(
          name: 'John Doe',
          identificationNumber: '12345678',
        );
        final event = UpdateEmployee(request: request);

        expect(event.request, equals(request));
      });

      test('props should contain request', () {
        final request = EmployeeUpdateRequest(
          name: 'Test',
          identificationNumber: '12345',
        );
        final event = UpdateEmployee(request: request);

        expect(event.props, contains(request));
      });
    });

    group('UpdateEmployeeAirline', () {
      test('should create with request', () {
        final request = EmployeeAirlineUpdateRequest(
          airlineId: 'a1',
          bp: '12345',
          startDate: '2024-01-01',
          endDate: '2025-01-01',
        );
        final event = UpdateEmployeeAirline(request: request);

        expect(event.request.airlineId, equals('a1'));
      });
    });

    group('ChangePassword', () {
      test('should create with request', () {
        final request = ChangePasswordRequest(
          email: 'test@example.com',
          currentPassword: 'old123',
          newPassword: 'new123',
          confirmPassword: 'new123',
        );
        final event = ChangePassword(request: request);

        expect(event.request.currentPassword, equals('old123'));
      });
    });
  });

  group('EmployeeState', () {
    test('EmployeeInitial should be a valid state', () {
      final state = EmployeeInitial();
      expect(state, isA<EmployeeState>());
      expect(state.props, isEmpty);
    });

    test('EmployeeLoading should be a valid state', () {
      final state = EmployeeLoading();
      expect(state, isA<EmployeeState>());
    });

    test('EmployeeUpdating should be a valid state', () {
      final state = EmployeeUpdating();
      expect(state, isA<EmployeeState>());
    });

    test('PasswordChanging should be a valid state', () {
      final state = PasswordChanging();
      expect(state, isA<EmployeeState>());
    });

    test('EmployeeDeleting should be a valid state', () {
      final state = EmployeeDeleting();
      expect(state, isA<EmployeeState>());
    });

    test('EmployeeAirlineLoading should be a valid state', () {
      final state = EmployeeAirlineLoading();
      expect(state, isA<EmployeeState>());
    });

    test('EmployeeAirlineRoutesLoading should be a valid state', () {
      final state = EmployeeAirlineRoutesLoading();
      expect(state, isA<EmployeeState>());
    });

    group('EmployeeError', () {
      test('should create with message', () {
        const state = EmployeeError(message: 'Error occurred');

        expect(state.message, equals('Error occurred'));
        expect(state.success, isFalse);
      });

      test('should create with code and success', () {
        const state = EmployeeError(
          message: 'Error',
          code: 'EMP_ERROR',
          success: false,
        );

        expect(state.code, equals('EMP_ERROR'));
        expect(state.success, isFalse);
      });

      test('props should contain all fields', () {
        const state = EmployeeError(
          message: 'Error',
          code: 'CODE',
          success: false,
        );

        expect(state.props.length, equals(3));
        expect(state.props, contains('Error'));
        expect(state.props, contains('CODE'));
      });

      test('two states with same values should be equal', () {
        const state1 = EmployeeError(message: 'error', code: 'CODE');
        const state2 = EmployeeError(message: 'error', code: 'CODE');

        expect(state1, equals(state2));
      });
    });
  });
}
