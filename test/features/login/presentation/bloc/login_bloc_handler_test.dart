import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/update_employee_use_case.dart';
import 'package:flight_hours_app/features/login/domain/usecases/login_use_case.dart';
import 'package:flight_hours_app/features/login/presentation/bloc/login_bloc.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockUpdateEmployeeUseCase extends Mock implements UpdateEmployeeUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockUpdateEmployeeUseCase mockUpdateEmployeeUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockUpdateEmployeeUseCase = MockUpdateEmployeeUseCase();
  });

  LoginBloc buildBloc() => LoginBloc(
    loginUseCase: mockLoginUseCase,
    updateEmployeeUseCase: mockUpdateEmployeeUseCase,
  );

  group('LoginSubmitted', () {
    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginError] on failure',
      build: () {
        when(() => mockLoginUseCase.call(any(), any())).thenAnswer(
          (_) async => const Left(
            Failure(message: 'Invalid credentials', code: 'AUTH_ERROR'),
          ),
        );
        return buildBloc();
      },
      act:
          (bloc) => bloc.add(
            const LoginSubmitted(email: 'test@test.com', password: 'wrongpass'),
          ),
      expect:
          () => [
            isA<LoginLoading>(),
            isA<LoginError>()
                .having((s) => s.message, 'message', 'Invalid credentials')
                .having((s) => s.code, 'code', 'AUTH_ERROR'),
          ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginEmailNotVerified] on email not verified',
      build: () {
        when(() => mockLoginUseCase.call(any(), any())).thenAnswer(
          (_) async => const Left(
            Failure(
              message: 'Email not verified',
              code: 'MOD_KC_LOGIN_EMAIL_NOT_VERIFIED_ERR_00001',
            ),
          ),
        );
        return buildBloc();
      },
      act:
          (bloc) => bloc.add(
            const LoginSubmitted(email: 'test@test.com', password: 'pass123'),
          ),
      expect:
          () => [
            isA<LoginLoading>(),
            isA<LoginEmailNotVerified>().having(
              (s) => s.message,
              'message',
              'Email not verified',
            ),
          ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginError] with UNKNOWN_ERROR code when code is null',
      build: () {
        when(() => mockLoginUseCase.call(any(), any())).thenAnswer(
          (_) async => const Left(Failure(message: 'Something went wrong')),
        );
        return buildBloc();
      },
      act:
          (bloc) => bloc.add(
            const LoginSubmitted(email: 'test@test.com', password: 'pass'),
          ),
      expect:
          () => [
            isA<LoginLoading>(),
            isA<LoginError>().having((s) => s.code, 'code', 'UNKNOWN_ERROR'),
          ],
    );
  });
}
