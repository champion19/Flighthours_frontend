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
        ).thenAnswer((_) async => successEntity);

        // Act
        final result = await useCase.call(testEmail);

        // Assert
        verify(() => mockRepository.requestPasswordReset(testEmail)).called(1);
        expect(result.success, isTrue);
      },
    );

    test(
      'should return success entity on successful password reset request',
      () async {
        // Arrange
        when(
          () => mockRepository.requestPasswordReset(testEmail),
        ).thenAnswer((_) async => successEntity);

        // Act
        final result = await useCase.call(testEmail);

        // Assert
        expect(result.success, isTrue);
        expect(result.code, equals('RESET_EMAIL_SENT'));
        expect(
          result.message,
          equals('Password reset email sent successfully'),
        );
      },
    );

    test('should return error entity when email is not registered', () async {
      // Arrange
      final errorEntity = ResetPasswordEntity(
        success: false,
        code: 'USER_NOT_FOUND',
        message: 'No account found with this email',
      );

      when(
        () => mockRepository.requestPasswordReset(testEmail),
      ).thenAnswer((_) async => errorEntity);

      // Act
      final result = await useCase.call(testEmail);

      // Assert
      expect(result.success, isFalse);
      expect(result.code, equals('USER_NOT_FOUND'));
    });

    test('should propagate exception when repository throws', () async {
      // Arrange
      when(
        () => mockRepository.requestPasswordReset(testEmail),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => useCase.call(testEmail), throwsA(isA<Exception>()));
      verify(() => mockRepository.requestPasswordReset(testEmail)).called(1);
    });
  });
}
