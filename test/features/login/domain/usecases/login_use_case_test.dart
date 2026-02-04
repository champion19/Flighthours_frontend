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
        ).thenAnswer((_) async => testLoginEntity);

        // Act
        final result = await useCase.call(testEmail, testPassword);

        // Assert
        verify(
          () => mockRepository.loginEmployee(testEmail, testPassword),
        ).called(1);
        expect(result, equals(testLoginEntity));
      },
    );

    test('should return LoginEntity with valid tokens on success', () async {
      // Arrange
      when(
        () => mockRepository.loginEmployee(testEmail, testPassword),
      ).thenAnswer((_) async => testLoginEntity);

      // Act
      final result = await useCase.call(testEmail, testPassword);

      // Assert
      expect(result.isValid, isTrue);
      expect(result.accessToken, equals('access_token_123'));
      expect(result.refreshToken, equals('refresh_token_456'));
      expect(result.employeeId, equals('emp123'));
    });

    test('should propagate exception when repository throws', () async {
      // Arrange
      when(
        () => mockRepository.loginEmployee(testEmail, testPassword),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => useCase.call(testEmail, testPassword),
        throwsA(isA<Exception>()),
      );
      verify(
        () => mockRepository.loginEmployee(testEmail, testPassword),
      ).called(1);
    });

    test('should return LoginEntity with roles', () async {
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
      ).thenAnswer((_) async => entityWithRoles);

      // Act
      final result = await useCase.call(testEmail, testPassword);

      // Assert
      expect(result.roles, contains('admin'));
      expect(result.roles, contains('pilot'));
    });
  });
}
