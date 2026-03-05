import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/register/data/models/register_response_model.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';
import 'package:flight_hours_app/features/register/domain/usecases/register_use_case.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_bloc.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_event.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_state.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late MockRegisterUseCase mockRegisterUseCase;

  final testEmployee = EmployeeEntityRegister(
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
    password: 'Password123!',
    idNumber: '12345678',
    fechaInicio: '2024-01-01',
    fechaFin: '2025-01-01',
  );

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    registerFallbackValue(testEmployee);
  });

  RegisterBloc buildBloc() =>
      RegisterBloc(registerUseCase: mockRegisterUseCase);

  group('RegisterSubmitted', () {
    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading, RegisterSuccess] on success',
      build: () {
        when(() => mockRegisterUseCase.call(any())).thenAnswer(
          (_) async => Right(
            RegisterResponseModel(
              success: true,
              code: 'REGISTER_SUCCESS',
              message: 'Registered',
            ),
          ),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(RegisterSubmitted(employment: testEmployee)),
      expect:
          () => [
            isA<RegisterLoading>(),
            isA<RegisterSuccess>().having(
              (s) => s.code,
              'code',
              'REGISTER_SUCCESS',
            ),
          ],
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading, RegisterError] on failure',
      build: () {
        when(
          () => mockRegisterUseCase.call(any()),
        ).thenAnswer((_) async => const Left(Failure(message: 'Email exists')));
        return buildBloc();
      },
      act: (bloc) => bloc.add(RegisterSubmitted(employment: testEmployee)),
      expect:
          () => [
            isA<RegisterLoading>(),
            isA<RegisterError>().having(
              (s) => s.message,
              'message',
              'Email exists',
            ),
          ],
    );
  });

  group('EnterPersonalInformation', () {
    blocTest<RegisterBloc, RegisterState>(
      'emits [PersonalInfoCompleted] with employee data',
      build: buildBloc,
      act:
          (bloc) =>
              bloc.add(EnterPersonalInformation(employment: testEmployee)),
      expect:
          () => [
            isA<PersonalInfoCompleted>().having(
              (s) => s.employee,
              'employee',
              testEmployee,
            ),
          ],
    );
  });

  group('EnterPilotInformation', () {
    final pilotEmployee = EmployeeEntityRegister(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      password: 'Password123!',
      idNumber: '12345678',
      bp: 'BP001',
      fechaInicio: '2024-06-01',
      fechaFin: '2025-06-01',
      vigente: true,
      airline: 'airline-id-1',
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [PilotInfoCompleted] with merged employee data',
      build: buildBloc,
      act: (bloc) => bloc.add(EnterPilotInformation(employment: pilotEmployee)),
      expect:
          () => [
            isA<PilotInfoCompleted>().having(
              (s) => s.employee?.bp,
              'bp',
              'BP001',
            ),
          ],
    );
  });

  group('StartVerification', () {
    blocTest<RegisterBloc, RegisterState>(
      'emits nothing (empty handler)',
      build: buildBloc,
      act: (bloc) => bloc.add(const StartVerification('test@example.com')),
      expect: () => <RegisterState>[],
    );
  });

  group('ForgotPasswordRequested', () {
    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading, RecoveryCodeSent]',
      build: buildBloc,
      act:
          (bloc) => bloc.add(
            const ForgotPasswordRequested(email: 'test@example.com'),
          ),
      wait: const Duration(seconds: 2),
      expect: () => [isA<RegisterLoading>(), isA<RecoveryCodeSent>()],
    );
  });

  group('VerificationCodeSubmitted', () {
    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading, RecoveryCodeVerified] for correct code',
      build: buildBloc,
      act: (bloc) => bloc.add(const VerificationCodeSubmitted(code: '1234')),
      wait: const Duration(seconds: 2),
      expect: () => [isA<RegisterLoading>(), isA<RecoveryCodeVerified>()],
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading, RecoveryError] for wrong code',
      build: buildBloc,
      act: (bloc) => bloc.add(const VerificationCodeSubmitted(code: '0000')),
      wait: const Duration(seconds: 2),
      expect:
          () => [
            isA<RegisterLoading>(),
            isA<RecoveryError>().having(
              (s) => s.message,
              'message',
              'Incorrect verification code',
            ),
          ],
    );
  });

  group('PasswordResetSubmitted', () {
    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading, PasswordResetSuccess]',
      build: buildBloc,
      act:
          (bloc) => bloc.add(
            const PasswordResetSubmitted(newPassword: 'NewPass123!'),
          ),
      wait: const Duration(seconds: 2),
      expect: () => [isA<RegisterLoading>(), isA<PasswordResetSuccess>()],
    );
  });
}
