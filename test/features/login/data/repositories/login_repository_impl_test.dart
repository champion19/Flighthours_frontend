import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/login/data/datasources/login_datasource.dart';
import 'package:flight_hours_app/features/login/data/repositories/login_repository_impl.dart';
import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';

class MockLoginDatasource extends Mock implements LoginDatasource {}

void main() {
  late MockLoginDatasource mockDatasource;
  late LoginRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockLoginDatasource();
    repository = LoginRepositoryImpl(mockDatasource);
  });

  group('LoginRepositoryImpl', () {
    group('loginEmployee', () {
      test('should return LoginEntity from datasource', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const loginEntity = LoginEntity(
          accessToken: 'access_token_123',
          refreshToken: 'refresh_token_123',
          expiresIn: 3600,
          tokenType: 'Bearer',
          employeeId: 'emp123',
        );
        when(
          () => mockDatasource.loginEmployee(any(), any()),
        ).thenAnswer((_) async => loginEntity);

        // Act
        final result = await repository.loginEmployee(email, password);

        // Assert
        expect(result, isA<LoginEntity>());
        expect(result.accessToken, equals('access_token_123'));
        verify(() => mockDatasource.loginEmployee(email, password)).called(1);
      });

      test('should propagate exception from datasource', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'wrong_password';
        when(
          () => mockDatasource.loginEmployee(any(), any()),
        ).thenThrow(Exception('Invalid credentials'));

        // Act & Assert
        expect(
          () => repository.loginEmployee(email, password),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('logoutEmployee', () {
      test('should throw UnimplementedError', () {
        // Act & Assert
        expect(
          () => repository.logoutEmployee(),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });
  });
}
