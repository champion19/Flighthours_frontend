import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/reset_password/data/datasources/reset_password_datasource.dart';
import 'package:flight_hours_app/features/reset_password/data/repositories/reset_password_repository_impl.dart';
import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';

class MockResetPasswordDatasource extends Mock
    implements ResetPasswordDatasource {}

void main() {
  late MockResetPasswordDatasource mockDatasource;
  late ResetPasswordRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockResetPasswordDatasource();
    repository = ResetPasswordRepositoryImpl(mockDatasource);
  });

  group('ResetPasswordRepositoryImpl', () {
    group('requestPasswordReset', () {
      test('should return ResetPasswordEntity from datasource', () async {
        // Arrange
        const email = 'test@example.com';
        final entity = ResetPasswordEntity(
          success: true,
          code: 'PASSWORD_RESET_SENT',
          message: 'Password reset email sent',
        );
        when(
          () => mockDatasource.requestPasswordReset(any()),
        ).thenAnswer((_) async => entity);

        // Act
        final result = await repository.requestPasswordReset(email);

        // Assert
        expect(result, isA<ResetPasswordEntity>());
        expect(result.success, isTrue);
        verify(() => mockDatasource.requestPasswordReset(email)).called(1);
      });

      test('should propagate exception from datasource', () async {
        // Arrange
        const email = 'test@example.com';
        when(
          () => mockDatasource.requestPasswordReset(any()),
        ).thenThrow(Exception('Failed to send reset email'));

        // Act & Assert
        expect(
          () => repository.requestPasswordReset(email),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
