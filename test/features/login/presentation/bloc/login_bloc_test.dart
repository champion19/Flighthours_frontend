import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';

void main() {
  group('LoginEvent', () {
    group('LoginSubmitted', () {
      test('should create with required fields', () {
        const event = LoginSubmitted(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(event.email, equals('test@example.com'));
        expect(event.password, equals('password123'));
      });

      test('props should contain email and password', () {
        const event = LoginSubmitted(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(event.props, contains('test@example.com'));
        expect(event.props, contains('password123'));
      });

      test('two events with same values should be equal', () {
        const event1 = LoginSubmitted(
          email: 'test@example.com',
          password: 'password123',
        );
        const event2 = LoginSubmitted(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(event1, equals(event2));
      });
    });
  });

  group('LoginState', () {
    test('LoginInitial should be a valid state', () {
      final state = LoginInitial();
      expect(state, isA<LoginState>());
      expect(state.props, isEmpty);
    });

    test('LoginLoading should be a valid state', () {
      final state = LoginLoading();
      expect(state, isA<LoginState>());
    });

    test('LoginSyncingPilotData should be a valid state', () {
      final state = LoginSyncingPilotData();
      expect(state, isA<LoginState>());
    });

    group('LoginSuccess', () {
      test('should create with required fields', () {
        final loginResult = LoginEntity(
          accessToken: 'token',
          refreshToken: 'refresh',
          expiresIn: 3600,
          tokenType: 'Bearer',
          email: 'test@test.com',
          name: 'Test User',
        );

        final state = LoginSuccess(loginResult, role: 'admin');

        expect(state.loginResult, equals(loginResult));
        expect(state.role, equals('admin'));
      });

      test('should have default role as pilot', () {
        final loginResult = LoginEntity(
          accessToken: 'token',
          refreshToken: 'refresh',
          expiresIn: 3600,
          tokenType: 'Bearer',
          email: 'test@test.com',
          name: 'Test User',
        );

        final state = LoginSuccess(loginResult);

        expect(state.role, equals('pilot'));
      });

      test('props should contain loginResult and role', () {
        final loginResult = LoginEntity(
          accessToken: 'token',
          refreshToken: 'refresh',
          expiresIn: 3600,
          tokenType: 'Bearer',
          email: 'test@test.com',
          name: 'Test User',
        );

        final state = LoginSuccess(loginResult, role: 'admin');

        expect(state.props.length, equals(2));
      });
    });

    group('LoginEmailNotVerified', () {
      test('should create with required fields', () {
        const state = LoginEmailNotVerified(
          message: 'Please verify your email',
          code: 'EMAIL_NOT_VERIFIED',
        );

        expect(state.message, equals('Please verify your email'));
        expect(state.code, equals('EMAIL_NOT_VERIFIED'));
      });

      test('props should contain message and code', () {
        const state = LoginEmailNotVerified(message: 'msg', code: 'code');

        expect(state.props.length, equals(2));
      });
    });

    group('LoginError', () {
      test('should create with required fields', () {
        const state = LoginError(
          message: 'Invalid credentials',
          code: 'INVALID_CREDENTIALS',
        );

        expect(state.message, equals('Invalid credentials'));
        expect(state.code, equals('INVALID_CREDENTIALS'));
      });

      test('props should contain message and code', () {
        const state = LoginError(message: 'msg', code: 'code');

        expect(state.props.length, equals(2));
      });
    });
  });
}
