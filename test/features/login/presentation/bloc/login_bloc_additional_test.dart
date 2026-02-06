import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/login/presentation/bloc/login_bloc.dart';

void main() {
  group('LoginBloc State Tests', () {
    group('LoginInitial', () {
      test('should be initial state', () {
        final state = LoginInitial();
        expect(state, isA<LoginState>());
        expect(state.props, isEmpty);
      });

      test('two LoginInitial states should be equal', () {
        final state1 = LoginInitial();
        final state2 = LoginInitial();
        expect(state1, equals(state2));
      });
    });

    group('LoginLoading', () {
      test('should be a valid state', () {
        final state = LoginLoading();
        expect(state, isA<LoginState>());
      });

      test('two LoginLoading states should be equal', () {
        final state1 = LoginLoading();
        final state2 = LoginLoading();
        expect(state1, equals(state2));
      });
    });

    group('LoginSyncingPilotData', () {
      test('should be a valid state', () {
        final state = LoginSyncingPilotData();
        expect(state, isA<LoginState>());
      });

      test('two LoginSyncingPilotData states should be equal', () {
        final state1 = LoginSyncingPilotData();
        final state2 = LoginSyncingPilotData();
        expect(state1, equals(state2));
      });
    });

    group('LoginError', () {
      test('should have message and code', () {
        const state = LoginError(message: 'Error', code: 'ERROR_CODE');
        expect(state.message, equals('Error'));
        expect(state.code, equals('ERROR_CODE'));
      });

      test('two LoginError states with same values should be equal', () {
        const state1 = LoginError(message: 'Error', code: 'CODE');
        const state2 = LoginError(message: 'Error', code: 'CODE');
        expect(state1, equals(state2));
      });

      test(
        'two LoginError states with different values should not be equal',
        () {
          const state1 = LoginError(message: 'Error1', code: 'CODE1');
          const state2 = LoginError(message: 'Error2', code: 'CODE2');
          expect(state1, isNot(equals(state2)));
        },
      );
    });

    group('LoginEmailNotVerified', () {
      test('should have message and code', () {
        const state = LoginEmailNotVerified(message: 'Verify', code: 'VERIFY');
        expect(state.message, equals('Verify'));
        expect(state.code, equals('VERIFY'));
      });

      test('two states with same values should be equal', () {
        const state1 = LoginEmailNotVerified(message: 'Verify', code: 'CODE');
        const state2 = LoginEmailNotVerified(message: 'Verify', code: 'CODE');
        expect(state1, equals(state2));
      });
    });
  });

  group('LoginEvent Tests', () {
    group('LoginSubmitted', () {
      test('should have email and password', () {
        const event = LoginSubmitted(email: 'test@test.com', password: 'pass');
        expect(event.email, equals('test@test.com'));
        expect(event.password, equals('pass'));
      });

      test('two events with same values should be equal', () {
        const event1 = LoginSubmitted(email: 'test@test.com', password: 'pass');
        const event2 = LoginSubmitted(email: 'test@test.com', password: 'pass');
        expect(event1, equals(event2));
      });

      test('two events with different emails should not be equal', () {
        const event1 = LoginSubmitted(
          email: 'test1@test.com',
          password: 'pass',
        );
        const event2 = LoginSubmitted(
          email: 'test2@test.com',
          password: 'pass',
        );
        expect(event1, isNot(equals(event2)));
      });

      test('two events with different passwords should not be equal', () {
        const event1 = LoginSubmitted(
          email: 'test@test.com',
          password: 'pass1',
        );
        const event2 = LoginSubmitted(
          email: 'test@test.com',
          password: 'pass2',
        );
        expect(event1, isNot(equals(event2)));
      });

      test('props should contain email and password', () {
        const event = LoginSubmitted(email: 'email', password: 'pass');
        expect(event.props, containsAll(['email', 'pass']));
      });
    });
  });
}
