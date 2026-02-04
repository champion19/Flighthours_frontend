import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_event.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_state.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';

void main() {
  group('RegisterEvent', () {
    final employee = EmployeeEntityRegister(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      password: 'password123',
      idNumber: '12345678',
      fechaInicio: '2024-01-01',
      fechaFin: '2025-01-01',
    );

    group('RegisterSubmitted', () {
      test('should create with required employment', () {
        final event = RegisterSubmitted(employment: employee);

        expect(event.employment, equals(employee));
      });

      test('props should contain employment', () {
        final event = RegisterSubmitted(employment: employee);

        expect(event.props, contains(employee));
      });
    });

    group('StartVerification', () {
      test('should create with email', () {
        const event = StartVerification('test@example.com');

        expect(event.email, equals('test@example.com'));
      });

      test('props should contain email', () {
        const event = StartVerification('test@example.com');

        expect(event.props, contains('test@example.com'));
      });
    });

    group('EnterPersonalInformation', () {
      test('should create with employment', () {
        final event = EnterPersonalInformation(employment: employee);

        expect(event.employment, equals(employee));
      });
    });

    group('EnterPilotInformation', () {
      test('should create with employment', () {
        final event = EnterPilotInformation(employment: employee);

        expect(event.employment, equals(employee));
      });
    });

    group('ForgotPasswordRequested', () {
      test('should create with email', () {
        const event = ForgotPasswordRequested(email: 'test@example.com');

        expect(event.email, equals('test@example.com'));
      });
    });

    group('VerificationCodeSubmitted', () {
      test('should create with code', () {
        const event = VerificationCodeSubmitted(code: '1234');

        expect(event.code, equals('1234'));
      });
    });

    group('PasswordResetSubmitted', () {
      test('should create with new password', () {
        const event = PasswordResetSubmitted(newPassword: 'newPassword123');

        expect(event.newPassword, equals('newPassword123'));
      });
    });

    group('CompleteRegistrationFlow', () {
      test('should create with employee', () {
        final event = CompleteRegistrationFlow(employee: employee);

        expect(event.employee, equals(employee));
      });
    });
  });

  group('RegisterState', () {
    final employee = EmployeeEntityRegister(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      password: 'password123',
      idNumber: '12345678',
      fechaInicio: '2024-01-01',
      fechaFin: '2025-01-01',
    );

    test('RegisterInitial should be a valid state', () {
      final state = RegisterInitial();
      expect(state, isA<RegisterState>());
    });

    test('RegisterLoading should contain employee', () {
      final state = RegisterLoading(employee: employee);
      expect(state.employee, equals(employee));
    });

    test('RegisterSuccess should contain message and code', () {
      final state = RegisterSuccess(
        employee: employee,
        message: 'Success',
        code: 'REGISTER_SUCCESS',
      );
      expect(state.message, equals('Success'));
      expect(state.code, equals('REGISTER_SUCCESS'));
    });

    test('RegisterError should contain message', () {
      final state = RegisterError(message: 'Error', employee: employee);
      expect(state.message, equals('Error'));
    });

    test('PersonalInfoCompleted should contain employee', () {
      final state = PersonalInfoCompleted(employee: employee);
      expect(state.employee, equals(employee));
    });

    test('PilotInfoCompleted should contain employee', () {
      final state = PilotInfoCompleted(employee: employee);
      expect(state.employee, equals(employee));
    });

    test('RecoveryCodeSent should be valid state', () {
      final state = RecoveryCodeSent();
      expect(state, isA<RegisterState>());
    });

    test('RecoveryCodeVerified should be valid state', () {
      final state = RecoveryCodeVerified();
      expect(state, isA<RegisterState>());
    });

    test('PasswordResetSuccess should be valid state', () {
      final state = PasswordResetSuccess();
      expect(state, isA<RegisterState>());
    });

    test('RecoveryError should contain message', () {
      const state = RecoveryError(message: 'Recovery failed');
      expect(state.message, equals('Recovery failed'));
    });

    test('RegistrationFlowComplete should contain message', () {
      final state = RegistrationFlowComplete(
        employee: employee,
        message: 'Registration complete',
      );
      expect(state.message, equals('Registration complete'));
    });

    test('RegistrationFlowInProgress should contain step info', () {
      final state = RegistrationFlowInProgress(
        employee: employee,
        currentStep: '1/2',
        stepDescription: 'Processing...',
      );
      expect(state.currentStep, equals('1/2'));
      expect(state.stepDescription, equals('Processing...'));
    });
  });
}
