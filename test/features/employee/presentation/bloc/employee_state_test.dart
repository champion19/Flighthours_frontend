import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_state.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_response_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';
import 'package:flight_hours_app/features/employee/data/models/change_password_model.dart';
import 'package:flight_hours_app/features/employee/data/models/delete_employee_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_routes_model.dart';

void main() {
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

    group('EmployeeDetailSuccess', () {
      test('should create with response', () {
        final response = EmployeeResponseModel(
          success: true,
          code: 'OK',
          message: 'Success',
        );

        final state = EmployeeDetailSuccess(response);

        expect(state.response, equals(response));
        expect(state.props.length, equals(1));
      });
    });

    group('EmployeeUpdateSuccess', () {
      test('should create with response', () {
        final response = EmployeeUpdateResponseModel(
          success: true,
          code: 'OK',
          message: 'Updated',
        );

        final state = EmployeeUpdateSuccess(response);

        expect(state.response, equals(response));
        expect(state.props.length, equals(1));
      });
    });

    group('PasswordChangeSuccess', () {
      test('should create with response', () {
        final response = ChangePasswordResponseModel(
          success: true,
          code: 'OK',
          message: 'Password changed',
        );

        final state = PasswordChangeSuccess(response);

        expect(state.response, equals(response));
        expect(state.props.length, equals(1));
      });
    });

    group('EmployeeDeleteSuccess', () {
      test('should create with response', () {
        final response = DeleteEmployeeResponseModel(
          success: true,
          code: 'OK',
          message: 'Deleted',
        );

        final state = EmployeeDeleteSuccess(response);

        expect(state.response, equals(response));
        expect(state.props.length, equals(1));
      });
    });

    group('EmployeeAirlineSuccess', () {
      test('should create with response', () {
        final response = EmployeeAirlineResponseModel(
          success: true,
          code: 'OK',
          message: 'Airline loaded',
        );

        final state = EmployeeAirlineSuccess(response);

        expect(state.response, equals(response));
        expect(state.props.length, equals(1));
      });
    });

    group('EmployeeAirlineUpdateSuccess', () {
      test('should create with response', () {
        final response = EmployeeAirlineResponseModel(
          success: true,
          code: 'OK',
          message: 'Airline updated',
        );

        final state = EmployeeAirlineUpdateSuccess(response);

        expect(state.response, equals(response));
        expect(state.props.length, equals(1));
      });
    });

    group('EmployeeAirlineRoutesSuccess', () {
      test('should create with response', () {
        final response = EmployeeAirlineRoutesResponseModel(
          success: true,
          code: 'OK',
          message: 'Routes loaded',
          data: [],
        );

        final state = EmployeeAirlineRoutesSuccess(response);

        expect(state.response, equals(response));
        expect(state.props.length, equals(1));
      });
    });

    group('EmployeeError', () {
      test('should create with message and code', () {
        const state = EmployeeError(message: 'Error occurred', code: 'ERR001');

        expect(state.message, equals('Error occurred'));
        expect(state.code, equals('ERR001'));
        expect(state.success, isFalse);
      });

      test('should create with message only', () {
        const state = EmployeeError(message: 'Error');

        expect(state.message, equals('Error'));
        expect(state.code, isNull);
      });

      test('props should contain message, code and success', () {
        const state = EmployeeError(
          message: 'msg',
          code: 'code',
          success: true,
        );

        expect(state.props.length, equals(3));
      });
    });
  });
}
