import 'package:dartz/dartz.dart';
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
      test(
        'should return Right with ResetPasswordEntity from datasource',
        () async {
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
          expect(result, isA<Right>());
          result.fold((failure) => fail('Expected Right'), (data) {
            expect(data, isA<ResetPasswordEntity>());
            expect(data.success, isTrue);
          });
          verify(() => mockDatasource.requestPasswordReset(email)).called(1);
        },
      );

      test('should return Left on ResetPasswordException', () async {
        // Arrange
        const email = 'test@example.com';
        when(() => mockDatasource.requestPasswordReset(any())).thenThrow(
          ResetPasswordException(
            message: 'Failed to send reset email',
            code: 'RESET_FAILED',
            statusCode: 400,
          ),
        );

        // Act
        final result = await repository.requestPasswordReset(email);

        // Assert
        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure.message, 'Failed to send reset email'),
          (data) => fail('Expected Left'),
        );
      });

      test('should return Left on unexpected exception', () async {
        // Arrange
        when(
          () => mockDatasource.requestPasswordReset(any()),
        ).thenThrow(Exception('Unexpected'));

        // Act
        final result = await repository.requestPasswordReset('test@test.com');

        // Assert
        expect(result, isA<Left>());
      });
    });
  });
}
