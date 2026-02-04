import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/email_verification/data/models/email_verification_model.dart';

void main() {
  group('EmailVerificationModel', () {
    test('fromMap should parse emailconfirmed true', () {
      final json = {'emailconfirmed': true};

      final result = EmailVerificationModel.fromMap(json);

      expect(result.emailconfirmed, isTrue);
    });

    test('fromMap should parse emailconfirmed false', () {
      final json = {'emailconfirmed': false};

      final result = EmailVerificationModel.fromMap(json);

      expect(result.emailconfirmed, isFalse);
    });

    test('should create model with constructor', () {
      final model = EmailVerificationModel(emailconfirmed: true);

      expect(model.emailconfirmed, isTrue);
    });
  });
}
