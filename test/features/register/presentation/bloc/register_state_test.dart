import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_state.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';

void main() {
  group('RegisterState', () {
    test('RegisterInitial should create with empty employee', () {
      final state = RegisterInitial();

      expect(state, isA<RegisterState>());
      expect(state.employee, isNotNull);
      expect(state.employee!.id, isEmpty);
    });

    test('RegisterLoading should hold employee', () {
      final employee = EmployeeEntityRegister.empty().copyWith(name: 'Test');

      final state = RegisterLoading(employee: employee);

      expect(state.employee!.name, equals('Test'));
    });

    group('RegisterSuccess', () {
      test('should create with required fields', () {
        final employee = EmployeeEntityRegister.empty().copyWith(name: 'User');

        final state = RegisterSuccess(
          employee: employee,
          message: 'Registration successful',
          code: 'REG_SUCCESS',
        );

        expect(state.employee!.name, equals('User'));
        expect(state.message, equals('Registration successful'));
        expect(state.code, equals('REG_SUCCESS'));
      });

      test('props should contain employee, message and code', () {
        final employee = EmployeeEntityRegister.empty();

        final state = RegisterSuccess(
          employee: employee,
          message: 'msg',
          code: 'code',
        );

        expect(state.props.length, equals(3));
      });
    });

    group('RegisterError', () {
      test('should create with message', () {
        final employee = EmployeeEntityRegister.empty();

        final state = RegisterError(
          message: 'Error occurred',
          employee: employee,
        );

        expect(state.message, equals('Error occurred'));
      });
    });

    test('PersonalInfoCompleted should hold employee', () {
      final employee = EmployeeEntityRegister.empty().copyWith(
        name: 'John',
        email: 'john@test.com',
      );

      final state = PersonalInfoCompleted(employee: employee);

      expect(state.employee!.name, equals('John'));
      expect(state.employee!.email, equals('john@test.com'));
    });

    test('PilotInfoCompleted should hold employee', () {
      final employee = EmployeeEntityRegister.empty().copyWith(
        bp: 'BP001',
        airline: 'Avianca',
      );

      final state = PilotInfoCompleted(employee: employee);

      expect(state.employee!.bp, equals('BP001'));
      expect(state.employee!.airline, equals('Avianca'));
    });

    test('RecoveryCodeSent should have empty employee', () {
      final state = RecoveryCodeSent();

      expect(state.employee, isNotNull);
    });

    test('RecoveryCodeVerified should have empty employee', () {
      final state = RecoveryCodeVerified();

      expect(state.employee, isNotNull);
    });

    test('PasswordResetSuccess should have empty employee', () {
      final state = PasswordResetSuccess();

      expect(state.employee, isNotNull);
    });

    test('RecoveryError should hold message', () {
      const state = RecoveryError(message: 'Recovery failed');

      expect(state.message, equals('Recovery failed'));
    });

    group('RegistrationFlowInProgress', () {
      test('should create with required fields', () {
        final employee = EmployeeEntityRegister.empty();

        final state = RegistrationFlowInProgress(
          employee: employee,
          currentStep: '2',
          stepDescription: 'Logging in...',
        );

        expect(state.currentStep, equals('2'));
        expect(state.stepDescription, equals('Logging in...'));
      });

      test(
        'props should contain employee, currentStep, and stepDescription',
        () {
          final employee = EmployeeEntityRegister.empty();

          final state = RegistrationFlowInProgress(
            employee: employee,
            currentStep: '1',
            stepDescription: 'Step 1',
          );

          expect(state.props, [employee, '1', 'Step 1']);
        },
      );
    });

    group('RegistrationFlowComplete', () {
      test('should create with required fields', () {
        final employee = EmployeeEntityRegister.empty();

        final state = RegistrationFlowComplete(
          employee: employee,
          message: 'Registration complete!',
        );

        expect(state.message, equals('Registration complete!'));
      });

      test('props should contain employee and message', () {
        final employee = EmployeeEntityRegister.empty();

        final state = RegistrationFlowComplete(
          employee: employee,
          message: 'Done',
        );

        expect(state.props, [employee, 'Done']);
      });
    });

    test('RegisterState base props contains employee', () {
      final state = RegisterInitial();
      expect(state.props, [state.employee]);
    });
  });
}
