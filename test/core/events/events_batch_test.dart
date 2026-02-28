import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:flight_hours_app/features/reset_password/presentation/bloc/reset_password_bloc.dart';
import 'package:flight_hours_app/features/email_verification/presentation/bloc/email_verification_bloc.dart';

void main() {
  group('LoginEvent', () {
    test('LoginSubmitted should store email and password', () {
      const event = LoginSubmitted(email: 'test@test.com', password: '123');
      expect(event.email, 'test@test.com');
      expect(event.password, '123');
      expect(event.props, ['test@test.com', '123']);
    });
  });

  group('ResetPasswordEvent', () {
    test('ResetPasswordSubmitted should store email', () {
      const event = ResetPasswordSubmitted(email: 'test@test.com');
      expect(event.email, 'test@test.com');
      expect(event.props, ['test@test.com']);
    });
  });

  group('EmailVerificationEvent', () {
    test('VerifyEmailEvent should store email', () {
      const event = VerifyEmailEvent(email: 'test@test.com');
      expect(event.email, 'test@test.com');
      expect(event.props, ['test@test.com']);
    });
  });
}
