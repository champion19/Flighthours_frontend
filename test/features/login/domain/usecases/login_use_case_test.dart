import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';
import 'package:flight_hours_app/features/login/domain/repositories/login_repository.dart';
import 'package:flight_hours_app/features/login/domain/usecases/login_use_case.dart';

// Mock class for LoginRepository
class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late LoginUseCase useCase;
  late MockLoginRepository mockRepository;

  setUp(() {
    mockRepository = MockLoginRepository();
    useCase = LoginUseCase(mockRepository);
  });

  group('LoginUseCase', () {
    const testEmail = 'test@example.com';
    const testPassword = 'Password123!';

    const testLoginEntity = LoginEntity(
      accessToken: 'access_token_123',
      refreshToken: 'refresh_token_456',
      expiresIn: 3600,
      tokenType: 'Bearer',
      employeeId: 'emp123',
      email: testEmail,
      name: 'Test User',
      roles: ['pilot'],
    );

    test(
      'should call loginEmployee on repository with correct parameters',
      () async {
        // Arrange
        when(
          () => mockRepository.loginEmployee(testEmail, testPassword),
        ).thenAnswer((_) async => const Right(testLoginEntity));

        // Act
        final result = await useCase.call(testEmail, testPassword);

        // Assert
        verify(
          () => mockRepository.loginEmployee(testEmail, testPassword),
        ).called(1);
        expect(result, isA<Right>());
      },
    );

    test(
      'should return Right with LoginEntity with valid tokens on success',
      () async {
        // Arrange
        when(
          () => mockRepository.loginEmployee(testEmail, testPassword),
        ).thenAnswer((_) async => const Right(testLoginEntity));

        // Act
        final result = await useCase.call(testEmail, testPassword);

        // Assert
        result.fold((failure) => fail('Expected Right'), (entity) {
          expect(entity.isValid, isTrue);
          expect(entity.accessToken, equals('access_token_123'));
          expect(entity.refreshToken, equals('refresh_token_456'));
          expect(entity.employeeId, equals('emp123'));
        });
      },
    );

    test('should return Left when repository returns Left', () async {
      // Arrange
      when(
        () => mockRepository.loginEmployee(testEmail, testPassword),
      ).thenAnswer((_) async => const Left(Failure(message: 'Network error')));

      // Act
      final result = await useCase.call(testEmail, testPassword);

      // Assert
      expect(result, isA<Left>());
      verify(
        () => mockRepository.loginEmployee(testEmail, testPassword),
      ).called(1);
    });

    test('should return Right with LoginEntity with roles', () async {
      // Arrange
      const entityWithRoles = LoginEntity(
        accessToken: 'token',
        refreshToken: 'refresh',
        expiresIn: 3600,
        tokenType: 'Bearer',
        roles: ['admin', 'pilot'],
      );

      when(
        () => mockRepository.loginEmployee(testEmail, testPassword),
      ).thenAnswer((_) async => const Right(entityWithRoles));

      // Act
      final result = await useCase.call(testEmail, testPassword);

      // Assert
      result.fold((failure) => fail('Expected Right'), (entity) {
        expect(entity.roles, contains('admin'));
        expect(entity.roles, contains('pilot'));
      });
    });
  });
}
