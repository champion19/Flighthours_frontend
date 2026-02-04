import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/reset_password/presentation/bloc/reset_password_bloc.dart';
import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';

void main() {
  group('ResetPasswordState', () {
    test('ResetPasswordInitial should be a valid state', () {
      final state = ResetPasswordInitial();
      expect(state, isA<ResetPasswordState>());
      expect(state.props, isEmpty);
    });

    test('ResetPasswordLoading should be a valid state', () {
      final state = ResetPasswordLoading();
      expect(state, isA<ResetPasswordState>());
    });

    group('ResetPasswordSuccess', () {
      test('should create with required result', () {
        final entity = ResetPasswordEntity(
          success: true,
          code: 'OK',
          message: 'Success',
        );
        final state = ResetPasswordSuccess(entity);

        expect(state.result, equals(entity));
        expect(state.result.success, isTrue);
      });

      test('props should contain result', () {
        final entity = ResetPasswordEntity(
          success: true,
          code: 'OK',
          message: 'Success',
        );
        final state = ResetPasswordSuccess(entity);

        expect(state.props.length, equals(1));
      });
    });

    group('ResetPasswordError', () {
      test('should create with message and code', () {
        const state = ResetPasswordError(
          message: 'Invalid token',
          code: 'INVALID_TOKEN',
        );

        expect(state.message, equals('Invalid token'));
        expect(state.code, equals('INVALID_TOKEN'));
      });

      test('props should contain message and code', () {
        const state = ResetPasswordError(message: 'msg', code: 'code');

        expect(state.props.length, equals(2));
      });

      test('two errors with same values should be equal', () {
        const state1 = ResetPasswordError(message: 'Error', code: 'ERR');
        const state2 = ResetPasswordError(message: 'Error', code: 'ERR');

        expect(state1, equals(state2));
      });
    });
  });
}
