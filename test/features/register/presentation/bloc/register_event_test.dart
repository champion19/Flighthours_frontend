import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_event.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';

void main() {
  group('RegisterEvent', () {
    test('base RegisterEvent should have empty props', () {
      const event = RegisterEvent();
      expect(event.props, isEmpty);
    });

    group('StartVerification', () {
      test('should create with email', () {
        const event = StartVerification('test@example.com');

        expect(event.email, equals('test@example.com'));
      });

      test('props should contain email', () {
        const event = StartVerification('email@test.com');

        expect(event.props.length, equals(1));
        expect(event.props, contains('email@test.com'));
      });
    });

    group('RegisterSubmitted', () {
      test('should create with employment', () {
        final employee = EmployeeEntityRegister.empty();
        final event = RegisterSubmitted(employment: employee);

        expect(event.employment, isNotNull);
      });

      test('props should contain employment', () {
        final employee = EmployeeEntityRegister.empty();
        final event = RegisterSubmitted(employment: employee);

        expect(event.props.length, equals(1));
      });
    });

    group('EnterPersonalInformation', () {
      test('should create with employment', () {
        final employee = EmployeeEntityRegister.empty();
        final event = EnterPersonalInformation(employment: employee);

        expect(event.employment, isNotNull);
      });

      test('props should contain employment', () {
        final employee = EmployeeEntityRegister.empty();
        final event = EnterPersonalInformation(employment: employee);

        expect(event.props.length, equals(1));
      });
    });

    group('EnterPilotInformation', () {
      test('should create with employment', () {
        final employee = EmployeeEntityRegister.empty();
        final event = EnterPilotInformation(employment: employee);

        expect(event.employment, isNotNull);
      });

      test('props should contain employment', () {
        final employee = EmployeeEntityRegister.empty();
        final event = EnterPilotInformation(employment: employee);

        expect(event.props.length, equals(1));
      });
    });

    group('ForgotPasswordRequested', () {
      test('should create with email', () {
        const event = ForgotPasswordRequested(email: 'user@test.com');

        expect(event.email, equals('user@test.com'));
      });

      test('props should contain email', () {
        const event = ForgotPasswordRequested(email: 'test@test.com');

        expect(event.props.length, equals(1));
      });
    });

    group('VerificationCodeSubmitted', () {
      test('should create with code', () {
        const event = VerificationCodeSubmitted(code: '123456');

        expect(event.code, equals('123456'));
      });

      test('props should contain code', () {
        const event = VerificationCodeSubmitted(code: 'abc123');

        expect(event.props.length, equals(1));
      });
    });

    group('PasswordResetSubmitted', () {
      test('should create with newPassword', () {
        const event = PasswordResetSubmitted(newPassword: 'newpass123');

        expect(event.newPassword, equals('newpass123'));
      });

      test('props should contain newPassword', () {
        const event = PasswordResetSubmitted(newPassword: 'pass');

        expect(event.props.length, equals(1));
      });
    });

    group('CompleteRegistrationFlow', () {
      test('should create with employee', () {
        final employee = EmployeeEntityRegister.empty();
        final event = CompleteRegistrationFlow(employee: employee);

        expect(event.employee, isNotNull);
      });

      test('props should contain employee', () {
        final employee = EmployeeEntityRegister.empty();
        final event = CompleteRegistrationFlow(employee: employee);

        expect(event.props.length, equals(1));
      });
    });
  });
}
