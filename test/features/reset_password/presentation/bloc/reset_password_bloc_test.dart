import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/reset_password/data/datasources/reset_password_datasource.dart';
import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';
import 'package:flight_hours_app/features/reset_password/domain/usecases/reset_password_use_case.dart';
import 'package:flight_hours_app/features/reset_password/presentation/bloc/reset_password_bloc.dart';

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

void main() {
  group('ResetPasswordEvent', () {
    group('ResetPasswordSubmitted', () {
      test('should create with required email', () {
        const event = ResetPasswordSubmitted(email: 'test@example.com');

        expect(event.email, equals('test@example.com'));
      });

      test('props should contain email', () {
        const event = ResetPasswordSubmitted(email: 'test@example.com');

        expect(event.props, contains('test@example.com'));
      });

      test('two events with same email should be equal', () {
        const event1 = ResetPasswordSubmitted(email: 'test@example.com');
        const event2 = ResetPasswordSubmitted(email: 'test@example.com');

        expect(event1, equals(event2));
      });

      test('two events with different emails should not be equal', () {
        const event1 = ResetPasswordSubmitted(email: 'test1@example.com');
        const event2 = ResetPasswordSubmitted(email: 'test2@example.com');

        expect(event1, isNot(equals(event2)));
      });
    });
  });

  group('ResetPasswordState', () {
    test('ResetPasswordInitial should be a valid state', () {
      final state = ResetPasswordInitial();
      expect(state, isA<ResetPasswordState>());
      expect(state.props, isEmpty);
    });

    test('ResetPasswordLoading should be a valid state', () {
      final state = ResetPasswordLoading();
      expect(state, isA<ResetPasswordState>());
      expect(state.props, isEmpty);
    });

    group('ResetPasswordSuccess', () {
      test('should create with result', () {
        final entity = ResetPasswordEntity(
          success: true,
          code: 'PASSWORD_RESET_SENT',
          message: 'Email sent',
        );
        final state = ResetPasswordSuccess(entity);

        expect(state.result, equals(entity));
      });

      test('props should contain result', () {
        final entity = ResetPasswordEntity(
          success: true,
          code: 'PASSWORD_RESET_SENT',
          message: 'Email sent',
        );
        final state = ResetPasswordSuccess(entity);

        expect(state.props, contains(entity));
      });
    });

    group('ResetPasswordError', () {
      test('should create with message and code', () {
        const state = ResetPasswordError(
          message: 'User not found',
          code: 'USER_NOT_FOUND',
        );

        expect(state.message, equals('User not found'));
        expect(state.code, equals('USER_NOT_FOUND'));
      });

      test('props should contain message and code', () {
        const state = ResetPasswordError(
          message: 'User not found',
          code: 'USER_NOT_FOUND',
        );

        expect(state.props, contains('User not found'));
        expect(state.props, contains('USER_NOT_FOUND'));
      });

      test('two states with same values should be equal', () {
        const state1 = ResetPasswordError(message: 'error', code: 'CODE');
        const state2 = ResetPasswordError(message: 'error', code: 'CODE');

        expect(state1, equals(state2));
      });
    });
  });

  // Tests for ResetPasswordBloc logic using bloc_test
  group('ResetPasswordBloc', () {
    late MockResetPasswordUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockResetPasswordUseCase();
    });

    ResetPasswordBloc buildBloc() {
      return ResetPasswordBloc(resetPasswordUseCase: mockUseCase);
    }

    test('initial state should be ResetPasswordInitial', () {
      final bloc = buildBloc();
      expect(bloc.state, isA<ResetPasswordInitial>());
    });

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'emits [Loading, Success] when ResetPasswordSubmitted succeeds',
      setUp: () {
        when(() => mockUseCase.call(any())).thenAnswer(
          (_) async => ResetPasswordEntity(
            success: true,
            code: 'PASSWORD_RESET_SENT',
            message: 'Email sent',
          ),
        );
      },
      build: () => buildBloc(),
      act:
          (bloc) =>
              bloc.add(const ResetPasswordSubmitted(email: 'test@example.com')),
      expect: () => [isA<ResetPasswordLoading>(), isA<ResetPasswordSuccess>()],
    );

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'emits [Loading, Error] when ResetPasswordSubmitted fails',
      setUp: () {
        when(() => mockUseCase.call(any())).thenThrow(
          ResetPasswordException(
            message: 'User not found',
            code: 'USER_NOT_FOUND',
            statusCode: 404,
          ),
        );
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            const ResetPasswordSubmitted(email: 'notfound@example.com'),
          ),
      expect: () => [isA<ResetPasswordLoading>(), isA<ResetPasswordError>()],
    );
  });
}
