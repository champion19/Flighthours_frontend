import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';
import 'package:flight_hours_app/features/reset_password/domain/repositories/reset_password_repository.dart';
import 'package:flight_hours_app/features/reset_password/domain/usecases/reset_password_use_case.dart';

// Mock class for ResetPasswordRepository
class MockResetPasswordRepository extends Mock
    implements ResetPasswordRepository {}

void main() {
  late ResetPasswordUseCase useCase;
  late MockResetPasswordRepository mockRepository;

  setUp(() {
    mockRepository = MockResetPasswordRepository();
    useCase = ResetPasswordUseCase(mockRepository);
  });

  group('ResetPasswordUseCase', () {
    const testEmail = 'user@example.com';

    final successEntity = ResetPasswordEntity(
      success: true,
      code: 'RESET_EMAIL_SENT',
      message: 'Password reset email sent successfully',
    );

    test(
      'should call requestPasswordReset on repository with correct email',
      () async {
        // Arrange
        when(
          () => mockRepository.requestPasswordReset(testEmail),
        ).thenAnswer((_) async => Right(successEntity));

        // Act
        final result = await useCase.call(testEmail);

        // Assert
        verify(() => mockRepository.requestPasswordReset(testEmail)).called(1);
        expect(result, isA<Right>());
      },
    );

    test(
      'should return Right with success entity on successful password reset',
      () async {
        // Arrange
        when(
          () => mockRepository.requestPasswordReset(testEmail),
        ).thenAnswer((_) async => Right(successEntity));

        // Act
        final result = await useCase.call(testEmail);

        // Assert
        result.fold((failure) => fail('Expected Right'), (entity) {
          expect(entity.success, isTrue);
          expect(entity.code, equals('RESET_EMAIL_SENT'));
          expect(
            entity.message,
            equals('Password reset email sent successfully'),
          );
        });
      },
    );

    test('should return Left when email is not registered', () async {
      // Arrange
      when(() => mockRepository.requestPasswordReset(testEmail)).thenAnswer(
        (_) async => const Left(
          Failure(
            message: 'No account found with this email',
            code: 'USER_NOT_FOUND',
          ),
        ),
      );

      // Act
      final result = await useCase.call(testEmail);

      // Assert
      result.fold((failure) {
        expect(failure.code, equals('USER_NOT_FOUND'));
      }, (data) => fail('Expected Left'));
    });

    test('should return Left when repository returns failure', () async {
      // Arrange
      when(
        () => mockRepository.requestPasswordReset(testEmail),
      ).thenAnswer((_) async => const Left(Failure(message: 'Network error')));

      // Act
      final result = await useCase.call(testEmail);

      // Assert
      expect(result, isA<Left>());
      verify(() => mockRepository.requestPasswordReset(testEmail)).called(1);
    });
  });
}
