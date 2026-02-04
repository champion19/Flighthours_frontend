import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_event.dart';
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
      expect(event.props, isEmpty);
    });

    group('UpdateEmployee', () {
      test('should create with required request', () {
        final request = EmployeeUpdateRequest(
          name: 'John Doe',
          identificationNumber: '12345678',
        );

        final event = UpdateEmployee(request: request);

        expect(event.request.name, equals('John Doe'));
      });

      test('props should contain request', () {
        final request = EmployeeUpdateRequest(
          name: 'Test',
          identificationNumber: '12345',
        );
        final event = UpdateEmployee(request: request);

        expect(event.props.length, equals(1));
      });
    });

    group('UpdateEmployeeAirline', () {
      test('should create with required request', () {
        final request = EmployeeAirlineUpdateRequest(
          airlineId: 'airline1',
          bp: 'BP123',
          startDate: '2026-01-01',
          endDate: '2027-01-01',
        );

        final event = UpdateEmployeeAirline(request: request);

        expect(event.request.bp, equals('BP123'));
      });

      test('props should contain request', () {
        final request = EmployeeAirlineUpdateRequest(
          airlineId: 'a1',
          bp: 'bp1',
          startDate: '2026-01-01',
          endDate: '2027-01-01',
        );
        final event = UpdateEmployeeAirline(request: request);

        expect(event.props.length, equals(1));
      });
    });

    group('ChangePassword', () {
      test('should create with required request', () {
        final request = ChangePasswordRequest(
          email: 'test@example.com',
          currentPassword: 'old123',
          newPassword: 'new456',
          confirmPassword: 'new456',
        );

        final event = ChangePassword(request: request);

        expect(event.request.currentPassword, equals('old123'));
        expect(event.request.newPassword, equals('new456'));
      });

      test('props should contain request', () {
        final request = ChangePasswordRequest(
          email: 'a@a.com',
          currentPassword: 'a',
          newPassword: 'b',
          confirmPassword: 'b',
        );
        final event = ChangePassword(request: request);

        expect(event.props.length, equals(1));
      });
    });

    test('DeleteEmployee should be a valid event', () {
      final event = DeleteEmployee();
      expect(event, isA<EmployeeEvent>());
      expect(event.props, isEmpty);
    });

    test('LoadEmployeeAirlineRoutes should be a valid event', () {
      final event = LoadEmployeeAirlineRoutes();
      expect(event, isA<EmployeeEvent>());
      expect(event.props, isEmpty);
    });

    test('ResetEmployeeState should be a valid event', () {
      final event = ResetEmployeeState();
      expect(event, isA<EmployeeEvent>());
      expect(event.props, isEmpty);
    });
  });
}
