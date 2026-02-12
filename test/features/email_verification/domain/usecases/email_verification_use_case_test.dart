import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
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
      final verifiedEntity = EmailEntity(emailconfirmed: true);
      when(
        () => mockRepository.verifyEmail(testEmail),
      ).thenAnswer((_) async => Right(verifiedEntity));

      final result = await useCase.call(testEmail);

      verify(() => mockRepository.verifyEmail(testEmail)).called(1);
      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.emailconfirmed, isTrue),
      );
    });

    test(
      'should return Right with email confirmed true on successful verification',
      () async {
        final verifiedEntity = EmailEntity(emailconfirmed: true);
        when(
          () => mockRepository.verifyEmail(testEmail),
        ).thenAnswer((_) async => Right(verifiedEntity));

        final result = await useCase.call(testEmail);

        result.fold(
          (failure) => fail('Expected Right'),
          (data) => expect(data.emailconfirmed, isTrue),
        );
      },
    );

    test(
      'should return Right with email confirmed false when not verified',
      () async {
        final unverifiedEntity = EmailEntity(emailconfirmed: false);
        when(
          () => mockRepository.verifyEmail(testEmail),
        ).thenAnswer((_) async => Right(unverifiedEntity));

        final result = await useCase.call(testEmail);

        result.fold(
          (failure) => fail('Expected Right'),
          (data) => expect(data.emailconfirmed, isFalse),
        );
      },
    );

    test('should return Left when repository fails', () async {
      when(() => mockRepository.verifyEmail(testEmail)).thenAnswer(
        (_) async => const Left(Failure(message: 'Verification failed')),
      );

      final result = await useCase.call(testEmail);

      expect(result, isA<Left>());
    });
  });
}
