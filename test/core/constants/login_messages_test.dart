import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/core/constants/login_messages.dart';

void main() {
  group('LoginMessages', () {
    group('login form constants', () {
      test('should have email label and hint', () {
        expect(LoginMessages.emailLabel, equals('Email'));
        expect(LoginMessages.emailHint, isNotEmpty);
      });

      test('should have password label and hint', () {
        expect(LoginMessages.passwordLabel, equals('Password'));
        expect(LoginMessages.passwordHint, isNotEmpty);
      });

      test('should have login button text', () {
        expect(LoginMessages.loginButton, equals('Log In'));
      });

      test('should have forgot password text', () {
        expect(LoginMessages.forgotPassword, equals('Forgot Password?'));
      });
    });

    group('registration link constants', () {
      test('should have no account text', () {
        expect(LoginMessages.noAccountText, contains("account"));
      });

      test('should have register link text', () {
        expect(LoginMessages.registerLink, equals('Register'));
      });
    });

    group('loading states constants', () {
      test('should have logging in message', () {
        expect(LoginMessages.loggingIn, isNotEmpty);
      });

      test('should have syncing data message', () {
        expect(LoginMessages.syncingData, isNotEmpty);
      });
    });

    group('success/error constants', () {
      test('should have login success message', () {
        expect(LoginMessages.loginSuccess, equals('Login successful'));
      });

      test('should have login failed message', () {
        expect(LoginMessages.loginFailed, equals('Login failed'));
      });
    });
  });
}
