import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/email_verification/presentation/bloc/email_verification_bloc.dart';
import 'package:flight_hours_app/features/email_verification/domain/entities/EmailEntity.dart';

void main() {
  group('EmailVerificationEvent', () {
    group('VerifyEmailEvent', () {
      test('should create with required email', () {
        const event = VerifyEmailEvent(email: 'test@example.com');

        expect(event.email, equals('test@example.com'));
      });

      test('props should contain email', () {
        const event = VerifyEmailEvent(email: 'test@example.com');

        expect(event.props, contains('test@example.com'));
      });

      test('two events with same email should be equal', () {
        const event1 = VerifyEmailEvent(email: 'test@example.com');
        const event2 = VerifyEmailEvent(email: 'test@example.com');

        expect(event1, equals(event2));
      });

      test('two events with different emails should not be equal', () {
        const event1 = VerifyEmailEvent(email: 'test1@example.com');
        const event2 = VerifyEmailEvent(email: 'test2@example.com');

        expect(event1, isNot(equals(event2)));
      });
    });
  });

  group('EmailVerificationState', () {
    test('EmailVerificationInitial should be a valid state', () {
      final state = EmailVerificationInitial();
      expect(state, isA<EmailVerificationState>());
      expect(state.props, isEmpty);
    });

    test('EmailVerificationLoading should be a valid state', () {
      final state = EmailVerificationLoading();
      expect(state, isA<EmailVerificationState>());
      expect(state.props, isEmpty);
    });

    group('EmailVerificationSuccess', () {
      test('should create with result', () {
        final entity = EmailEntity(emailconfirmed: true);
        final state = EmailVerificationSuccess(result: entity);

        expect(state.result, equals(entity));
      });

      test('props should contain result', () {
        final entity = EmailEntity(emailconfirmed: true);
        final state = EmailVerificationSuccess(result: entity);

        expect(state.props, contains(entity));
      });

      test('two states with same result should be equal', () {
        final entity = EmailEntity(emailconfirmed: true);
        final state1 = EmailVerificationSuccess(result: entity);
        final state2 = EmailVerificationSuccess(result: entity);

        expect(state1, equals(state2));
      });
    });

    group('EmailVerificationError', () {
      test('should create with message', () {
        const state = EmailVerificationError(message: 'Verification failed');

        expect(state.message, equals('Verification failed'));
      });

      test('props should contain message', () {
        const state = EmailVerificationError(message: 'Verification failed');

        expect(state.props, contains('Verification failed'));
      });

      test('two states with same message should be equal', () {
        const state1 = EmailVerificationError(message: 'error');
        const state2 = EmailVerificationError(message: 'error');

        expect(state1, equals(state2));
      });

      test('two states with different messages should not be equal', () {
        const state1 = EmailVerificationError(message: 'error1');
        const state2 = EmailVerificationError(message: 'error2');

        expect(state1, isNot(equals(state2)));
      });
    });
  });
}
