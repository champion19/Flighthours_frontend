import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_state.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';

void main() {
  final testEmployee = EmployeeEntityRegister.empty();

  group('RegisterState Tests', () {
    group('RegisterInitial', () {
      test('should create with empty employee', () {
        final state = RegisterInitial();
        expect(state, isA<RegisterState>());
        expect(state.employee, isNotNull);
      });
    });

    group('RegisterLoading', () {
      test('should create with employee', () {
        final state = RegisterLoading(employee: testEmployee);
        expect(state.employee, equals(testEmployee));
      });
    });

    group('RegisterSuccess', () {
      test('should create with employee, message and code', () {
        final state = RegisterSuccess(
          employee: testEmployee,
          message: 'Success',
          code: 'OK',
        );
        expect(state.employee, equals(testEmployee));
        expect(state.message, equals('Success'));
        expect(state.code, equals('OK'));
      });

      test('props should contain employee, message and code', () {
        final state = RegisterSuccess(
          employee: testEmployee,
          message: 'Success',
          code: 'OK',
        );
        expect(state.props.length, equals(3));
      });
    });

    group('RegisterError', () {
      test('should create with message and employee', () {
        final state = RegisterError(
          message: 'Error occurred',
          employee: testEmployee,
        );
        expect(state.message, equals('Error occurred'));
        expect(state.employee, equals(testEmployee));
      });

      test('props should contain message and employee', () {
        final state = RegisterError(message: 'Error', employee: testEmployee);
        expect(state.props.length, equals(2));
      });
    });

    group('PersonalInfoCompleted', () {
      test('should create with employee', () {
        final state = PersonalInfoCompleted(employee: testEmployee);
        expect(state.employee, equals(testEmployee));
      });
    });

    group('PilotInfoCompleted', () {
      test('should create with employee', () {
        final state = PilotInfoCompleted(employee: testEmployee);
        expect(state.employee, equals(testEmployee));
      });
    });

    group('RecoveryCodeSent', () {
      test('should create with empty employee', () {
        final state = RecoveryCodeSent();
        expect(state, isA<RegisterState>());
        expect(state.employee, isNotNull);
      });
    });

    group('RecoveryCodeVerified', () {
      test('should create with empty employee', () {
        final state = RecoveryCodeVerified();
        expect(state, isA<RegisterState>());
      });
    });

    group('PasswordResetSuccess', () {
      test('should create with empty employee', () {
        final state = PasswordResetSuccess();
        expect(state, isA<RegisterState>());
      });
    });

    group('RecoveryError', () {
      test('should create with message', () {
        const state = RecoveryError(message: 'Recovery failed');
        expect(state.message, equals('Recovery failed'));
      });

      test('props should contain message', () {
        const state = RecoveryError(message: 'Error');
        expect(state.props, contains('Error'));
      });
    });

    group('RegistrationFlowInProgress', () {
      test('should create with all fields', () {
        final state = RegistrationFlowInProgress(
          employee: testEmployee,
          currentStep: 'step1',
          stepDescription: 'First step',
        );
        expect(state.currentStep, equals('step1'));
        expect(state.stepDescription, equals('First step'));
      });
    });

    group('RegistrationFlowComplete', () {
      test('should create with employee and message', () {
        final state = RegistrationFlowComplete(
          employee: testEmployee,
          message: 'Registration complete',
        );
        expect(state.message, equals('Registration complete'));
        expect(state.employee, equals(testEmployee));
      });
    });
  });
}
