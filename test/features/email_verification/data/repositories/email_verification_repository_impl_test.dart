import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/email_verification/data/datasource/email_verifcation_datasource.dart';
import 'package:flight_hours_app/features/email_verification/data/models/email_verification_model.dart';
import 'package:flight_hours_app/features/email_verification/data/repositories/email_verification_repository_impl.dart';
import 'package:flight_hours_app/features/email_verification/domain/entities/EmailEntity.dart';

class MockEmailVerificationDatasource extends Mock
    implements EmailVerificationDatasource {}

void main() {
  late MockEmailVerificationDatasource mockDatasource;
  late EmailVerificationRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockEmailVerificationDatasource();
    repository = EmailVerificationRepositoryImpl(mockDatasource);
  });

  group('EmailVerificationRepositoryImpl', () {
    group('verifyEmail', () {
      test('should return EmailEntity from datasource', () async {
        // Arrange
        const email = 'test@example.com';
        final model = EmailVerificationModel(emailconfirmed: true);
        when(
          () => mockDatasource.verifyEmail(any()),
        ).thenAnswer((_) async => model);

        // Act
        final result = await repository.verifyEmail(email);

        // Assert
        expect(result, isA<EmailEntity>());
        verify(() => mockDatasource.verifyEmail(email)).called(1);
      });

      test('should propagate exception from datasource', () async {
        // Arrange
        const email = 'test@example.com';
        when(
          () => mockDatasource.verifyEmail(any()),
        ).thenThrow(Exception('Verification failed'));

        // Act & Assert
        expect(() => repository.verifyEmail(email), throwsA(isA<Exception>()));
      });
    });
  });
}
