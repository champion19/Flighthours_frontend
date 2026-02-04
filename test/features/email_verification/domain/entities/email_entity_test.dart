import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/email_verification/domain/entities/EmailEntity.dart';

void main() {
  group('EmailEntity', () {
    test('should create entity with emailconfirmed true', () {
      final entity = EmailEntity(emailconfirmed: true);

      expect(entity.emailconfirmed, isTrue);
    });

    test('should create entity with emailconfirmed false', () {
      final entity = EmailEntity(emailconfirmed: false);

      expect(entity.emailconfirmed, isFalse);
    });
  });
}
