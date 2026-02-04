import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/reset_password/presentation/bloc/reset_password_bloc.dart';
import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';

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
}
