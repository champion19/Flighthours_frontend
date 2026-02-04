import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/email_verification/domain/entities/EmailEntity.dart';
import 'package:flight_hours_app/features/email_verification/domain/repositories/email_verification_repository.dart';
import 'package:flight_hours_app/features/email_verification/domain/usecases/email_verification_use_case.dart';

// Mock class for EmailVerificationRepository
class MockEmailVerificationRepository extends Mock
    implements EmailVerificationRepository {}

void main() {
  late EmailVerificationUseCase useCase;
  late MockEmailVerificationRepository mockRepository;

  setUp(() {
    mockRepository = MockEmailVerificationRepository();
    useCase = EmailVerificationUseCase(mockRepository);
  });

  group('EmailVerificationUseCase', () {
    const testEmail = 'user@example.com';

    test('should call verifyEmail on repository with correct email', () async {
      // Arrange
      final verifiedEntity = EmailEntity(emailconfirmed: true);
      when(
        () => mockRepository.verifyEmail(testEmail),
      ).thenAnswer((_) async => verifiedEntity);

      // Act
      final result = await useCase.call(testEmail);

      // Assert
      verify(() => mockRepository.verifyEmail(testEmail)).called(1);
      expect(result.emailconfirmed, isTrue);
    });

    test(
      'should return email confirmed true on successful verification',
      () async {
        // Arrange
        final verifiedEntity = EmailEntity(emailconfirmed: true);
        when(
          () => mockRepository.verifyEmail(testEmail),
        ).thenAnswer((_) async => verifiedEntity);

        // Act
        final result = await useCase.call(testEmail);

        // Assert
        expect(result.emailconfirmed, isTrue);
      },
    );

    test('should return email confirmed false when not verified', () async {
      // Arrange
      final unverifiedEntity = EmailEntity(emailconfirmed: false);
      when(
        () => mockRepository.verifyEmail(testEmail),
      ).thenAnswer((_) async => unverifiedEntity);

      // Act
      final result = await useCase.call(testEmail);

      // Assert
      expect(result.emailconfirmed, isFalse);
    });

    test('should propagate exception when repository throws', () async {
      // Arrange
      when(
        () => mockRepository.verifyEmail(testEmail),
      ).thenThrow(Exception('Verification failed'));

      // Act & Assert
      expect(() => useCase.call(testEmail), throwsA(isA<Exception>()));
      verify(() => mockRepository.verifyEmail(testEmail)).called(1);
    });
  });
}
