import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/employee/data/models/change_password_model.dart';
import 'package:flight_hours_app/features/employee/data/models/delete_employee_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_routes_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_response_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/change_password_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/delete_employee_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/get_employee_airline_routes_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/get_employee_airline_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/get_employee_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/update_employee_airline_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/update_employee_use_case.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_event.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_state.dart';

class MockGetEmployeeUseCase extends Mock implements GetEmployeeUseCase {}

class MockUpdateEmployeeUseCase extends Mock implements UpdateEmployeeUseCase {}

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

class MockDeleteEmployeeUseCase extends Mock implements DeleteEmployeeUseCase {}

class MockGetEmployeeAirlineUseCase extends Mock
    implements GetEmployeeAirlineUseCase {}

class MockUpdateEmployeeAirlineUseCase extends Mock
    implements UpdateEmployeeAirlineUseCase {}

class MockGetEmployeeAirlineRoutesUseCase extends Mock
    implements GetEmployeeAirlineRoutesUseCase {}

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

  // Tests for EmployeeBloc logic using bloc_test
  group('EmployeeBloc', () {
    late MockGetEmployeeUseCase mockGetUseCase;
    late MockUpdateEmployeeUseCase mockUpdateUseCase;
    late MockChangePasswordUseCase mockChangePasswordUseCase;
    late MockDeleteEmployeeUseCase mockDeleteUseCase;
    late MockGetEmployeeAirlineUseCase mockGetAirlineUseCase;
    late MockUpdateEmployeeAirlineUseCase mockUpdateAirlineUseCase;
    late MockGetEmployeeAirlineRoutesUseCase mockGetRoutesUseCase;

    setUpAll(() {
      registerFallbackValue(
        EmployeeUpdateRequest(name: '', identificationNumber: ''),
      );
      registerFallbackValue(
        EmployeeAirlineUpdateRequest(
          airlineId: '',
          bp: '',
          startDate: '',
          endDate: '',
        ),
      );
      registerFallbackValue(
        ChangePasswordRequest(
          email: '',
          currentPassword: '',
          newPassword: '',
          confirmPassword: '',
        ),
      );
    });

    setUp(() {
      mockGetUseCase = MockGetEmployeeUseCase();
      mockUpdateUseCase = MockUpdateEmployeeUseCase();
      mockChangePasswordUseCase = MockChangePasswordUseCase();
      mockDeleteUseCase = MockDeleteEmployeeUseCase();
      mockGetAirlineUseCase = MockGetEmployeeAirlineUseCase();
      mockUpdateAirlineUseCase = MockUpdateEmployeeAirlineUseCase();
      mockGetRoutesUseCase = MockGetEmployeeAirlineRoutesUseCase();
    });

    EmployeeBloc buildBloc() {
      return EmployeeBloc(
        getEmployeeUseCase: mockGetUseCase,
        updateEmployeeUseCase: mockUpdateUseCase,
        changePasswordUseCase: mockChangePasswordUseCase,
        deleteEmployeeUseCase: mockDeleteUseCase,
        getEmployeeAirlineUseCase: mockGetAirlineUseCase,
        updateEmployeeAirlineUseCase: mockUpdateAirlineUseCase,
        getEmployeeAirlineRoutesUseCase: mockGetRoutesUseCase,
      );
    }

    test('initial state should be EmployeeInitial', () {
      final bloc = buildBloc();
      expect(bloc.state, isA<EmployeeInitial>());
    });

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [Loading, DetailSuccess] when LoadCurrentEmployee succeeds',
      setUp: () {
        when(() => mockGetUseCase.call()).thenAnswer(
          (_) async => Right(
            EmployeeResponseModel(
              success: true,
              code: 'OK',
              message: 'Employee fetched',
            ),
          ),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(LoadCurrentEmployee()),
      expect: () => [isA<EmployeeLoading>(), isA<EmployeeDetailSuccess>()],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [Loading, Error] when LoadCurrentEmployee fails',
      setUp: () {
        when(() => mockGetUseCase.call()).thenAnswer(
          (_) async => Right(
            EmployeeResponseModel(
              success: false,
              code: 'NOT_FOUND',
              message: 'Employee not found',
            ),
          ),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(LoadCurrentEmployee()),
      expect: () => [isA<EmployeeLoading>(), isA<EmployeeError>()],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits EmployeeInitial when ResetEmployeeState is called',
      build: () => buildBloc(),
      act: (bloc) => bloc.add(ResetEmployeeState()),
      expect: () => [isA<EmployeeInitial>()],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [Loading, Error] when LoadCurrentEmployee returns Left',
      setUp: () {
        when(
          () => mockGetUseCase.call(),
        ).thenAnswer((_) async => const Left(Failure(message: 'Server error')));
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(LoadCurrentEmployee()),
      expect: () => [isA<EmployeeLoading>(), isA<EmployeeError>()],
    );

    // --- LoadEmployeeAirline ---
    blocTest<EmployeeBloc, EmployeeState>(
      'emits [AirlineLoading, AirlineSuccess] when LoadEmployeeAirline succeeds',
      setUp: () {
        when(() => mockGetAirlineUseCase.call()).thenAnswer(
          (_) async => Right(
            EmployeeAirlineResponseModel(
              success: true,
              code: 'OK',
              message: 'Airline loaded',
            ),
          ),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(LoadEmployeeAirline()),
      expect:
          () => [isA<EmployeeAirlineLoading>(), isA<EmployeeAirlineSuccess>()],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [AirlineLoading, Error] when LoadEmployeeAirline returns Left',
      setUp: () {
        when(() => mockGetAirlineUseCase.call()).thenAnswer(
          (_) async => const Left(Failure(message: 'Airline not found')),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(LoadEmployeeAirline()),
      expect: () => [isA<EmployeeAirlineLoading>(), isA<EmployeeError>()],
    );

    // --- LoadEmployeeAirlineRoutes ---
    blocTest<EmployeeBloc, EmployeeState>(
      'emits [RoutesLoading, RoutesSuccess] when LoadEmployeeAirlineRoutes succeeds',
      setUp: () {
        when(() => mockGetRoutesUseCase.call()).thenAnswer(
          (_) async => Right(
            EmployeeAirlineRoutesResponseModel(
              success: true,
              code: 'OK',
              message: 'Routes loaded',
              data: const [],
            ),
          ),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(LoadEmployeeAirlineRoutes()),
      expect:
          () => [
            isA<EmployeeAirlineRoutesLoading>(),
            isA<EmployeeAirlineRoutesSuccess>(),
          ],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [RoutesLoading, Error] when LoadEmployeeAirlineRoutes fails with success=false',
      setUp: () {
        when(() => mockGetRoutesUseCase.call()).thenAnswer(
          (_) async => Right(
            EmployeeAirlineRoutesResponseModel(
              success: false,
              code: 'ERROR',
              message: 'Routes error',
              data: const [],
            ),
          ),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(LoadEmployeeAirlineRoutes()),
      expect: () => [isA<EmployeeAirlineRoutesLoading>(), isA<EmployeeError>()],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [RoutesLoading, Error] when LoadEmployeeAirlineRoutes returns Left',
      setUp: () {
        when(() => mockGetRoutesUseCase.call()).thenAnswer(
          (_) async => const Left(Failure(message: 'Network error')),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(LoadEmployeeAirlineRoutes()),
      expect: () => [isA<EmployeeAirlineRoutesLoading>(), isA<EmployeeError>()],
    );

    // --- UpdateEmployee ---
    blocTest<EmployeeBloc, EmployeeState>(
      'emits [Updating, UpdateSuccess] when UpdateEmployee succeeds',
      setUp: () {
        when(() => mockUpdateUseCase.call(any())).thenAnswer(
          (_) async => Right(
            EmployeeUpdateResponseModel(
              success: true,
              code: 'OK',
              message: 'Employee updated',
            ),
          ),
        );
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            UpdateEmployee(
              request: EmployeeUpdateRequest(
                name: 'Test',
                identificationNumber: '123',
              ),
            ),
          ),
      expect: () => [isA<EmployeeUpdating>(), isA<EmployeeUpdateSuccess>()],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [Updating, Error] when UpdateEmployee fails with success=false',
      setUp: () {
        when(() => mockUpdateUseCase.call(any())).thenAnswer(
          (_) async => Right(
            EmployeeUpdateResponseModel(
              success: false,
              code: 'FAIL',
              message: 'Update failed',
            ),
          ),
        );
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            UpdateEmployee(
              request: EmployeeUpdateRequest(
                name: 'Test',
                identificationNumber: '123',
              ),
            ),
          ),
      expect: () => [isA<EmployeeUpdating>(), isA<EmployeeError>()],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [Updating, Error] when UpdateEmployee returns Left',
      setUp: () {
        when(
          () => mockUpdateUseCase.call(any()),
        ).thenAnswer((_) async => const Left(Failure(message: 'Server error')));
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            UpdateEmployee(
              request: EmployeeUpdateRequest(
                name: 'Test',
                identificationNumber: '123',
              ),
            ),
          ),
      expect: () => [isA<EmployeeUpdating>(), isA<EmployeeError>()],
    );

    // --- UpdateEmployeeAirline ---
    blocTest<EmployeeBloc, EmployeeState>(
      'emits [Updating, AirlineUpdateSuccess] when UpdateEmployeeAirline succeeds',
      setUp: () {
        when(() => mockUpdateAirlineUseCase.call(any())).thenAnswer(
          (_) async => Right(
            EmployeeAirlineResponseModel(
              success: true,
              code: 'OK',
              message: 'Airline updated',
            ),
          ),
        );
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            UpdateEmployeeAirline(
              request: EmployeeAirlineUpdateRequest(
                airlineId: 'a1',
                bp: 'BP1',
                startDate: '2024-01-01',
                endDate: '2025-01-01',
              ),
            ),
          ),
      expect:
          () => [isA<EmployeeUpdating>(), isA<EmployeeAirlineUpdateSuccess>()],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [Updating, Error] when UpdateEmployeeAirline fails with success=false',
      setUp: () {
        when(() => mockUpdateAirlineUseCase.call(any())).thenAnswer(
          (_) async => Right(
            EmployeeAirlineResponseModel(
              success: false,
              code: 'FAIL',
              message: 'Airline update failed',
            ),
          ),
        );
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            UpdateEmployeeAirline(
              request: EmployeeAirlineUpdateRequest(
                airlineId: 'a1',
                bp: 'BP1',
                startDate: '2024-01-01',
                endDate: '2025-01-01',
              ),
            ),
          ),
      expect: () => [isA<EmployeeUpdating>(), isA<EmployeeError>()],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [Updating, Error] when UpdateEmployeeAirline returns Left',
      setUp: () {
        when(
          () => mockUpdateAirlineUseCase.call(any()),
        ).thenAnswer((_) async => const Left(Failure(message: 'Server error')));
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            UpdateEmployeeAirline(
              request: EmployeeAirlineUpdateRequest(
                airlineId: 'a1',
                bp: 'BP1',
                startDate: '2024-01-01',
                endDate: '2025-01-01',
              ),
            ),
          ),
      expect: () => [isA<EmployeeUpdating>(), isA<EmployeeError>()],
    );

    // --- ChangePassword ---
    blocTest<EmployeeBloc, EmployeeState>(
      'emits [PasswordChanging, PasswordChangeSuccess] when ChangePassword succeeds',
      setUp: () {
        when(() => mockChangePasswordUseCase.call(any())).thenAnswer(
          (_) async => Right(
            ChangePasswordResponseModel(
              success: true,
              code: 'OK',
              message: 'Password changed',
            ),
          ),
        );
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            ChangePassword(
              request: ChangePasswordRequest(
                email: 'test@test.com',
                currentPassword: 'old',
                newPassword: 'new',
                confirmPassword: 'new',
              ),
            ),
          ),
      expect: () => [isA<PasswordChanging>(), isA<PasswordChangeSuccess>()],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [PasswordChanging, Error] when ChangePassword fails with success=false',
      setUp: () {
        when(() => mockChangePasswordUseCase.call(any())).thenAnswer(
          (_) async => Right(
            ChangePasswordResponseModel(
              success: false,
              code: 'WRONG_PASSWORD',
              message: 'Wrong password',
            ),
          ),
        );
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            ChangePassword(
              request: ChangePasswordRequest(
                email: 'test@test.com',
                currentPassword: 'wrong',
                newPassword: 'new',
                confirmPassword: 'new',
              ),
            ),
          ),
      expect: () => [isA<PasswordChanging>(), isA<EmployeeError>()],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [PasswordChanging, Error] when ChangePassword returns Left',
      setUp: () {
        when(
          () => mockChangePasswordUseCase.call(any()),
        ).thenAnswer((_) async => const Left(Failure(message: 'Auth error')));
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            ChangePassword(
              request: ChangePasswordRequest(
                email: 'test@test.com',
                currentPassword: 'old',
                newPassword: 'new',
                confirmPassword: 'new',
              ),
            ),
          ),
      expect: () => [isA<PasswordChanging>(), isA<EmployeeError>()],
    );

    // --- DeleteEmployee ---
    blocTest<EmployeeBloc, EmployeeState>(
      'emits [Deleting, DeleteSuccess] when DeleteEmployee succeeds',
      setUp: () {
        when(() => mockDeleteUseCase.call()).thenAnswer(
          (_) async => Right(
            DeleteEmployeeResponseModel(
              success: true,
              code: 'OK',
              message: 'Employee deleted',
            ),
          ),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(DeleteEmployee()),
      expect: () => [isA<EmployeeDeleting>(), isA<EmployeeDeleteSuccess>()],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [Deleting, Error] when DeleteEmployee fails with success=false',
      setUp: () {
        when(() => mockDeleteUseCase.call()).thenAnswer(
          (_) async => Right(
            DeleteEmployeeResponseModel(
              success: false,
              code: 'FAIL',
              message: 'Cannot delete',
            ),
          ),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(DeleteEmployee()),
      expect: () => [isA<EmployeeDeleting>(), isA<EmployeeError>()],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [Deleting, Error] when DeleteEmployee returns Left',
      setUp: () {
        when(
          () => mockDeleteUseCase.call(),
        ).thenAnswer((_) async => const Left(Failure(message: 'Server error')));
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(DeleteEmployee()),
      expect: () => [isA<EmployeeDeleting>(), isA<EmployeeError>()],
    );
  });
}
