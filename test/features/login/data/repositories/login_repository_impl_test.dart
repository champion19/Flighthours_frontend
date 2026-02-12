import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
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
      test('should return Right with LoginEntity from datasource', () async {
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
        expect(result, isA<Right>());
        result.fold((failure) => fail('Expected Right'), (entity) {
          expect(entity, isA<LoginEntity>());
          expect(entity.accessToken, equals('access_token_123'));
        });
        verify(() => mockDatasource.loginEmployee(email, password)).called(1);
      });

      test('should return Left with Failure on LoginException', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'wrong_password';
        when(() => mockDatasource.loginEmployee(any(), any())).thenThrow(
          LoginException(
            message: 'Invalid credentials',
            code: 'INVALID',
            statusCode: 401,
          ),
        );

        // Act
        final result = await repository.loginEmployee(email, password);

        // Assert
        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure.message, 'Invalid credentials'),
          (data) => fail('Expected Left'),
        );
      });

      test('should return Left with Failure on unexpected exception', () async {
        // Arrange
        when(
          () => mockDatasource.loginEmployee(any(), any()),
        ).thenThrow(Exception('Unexpected'));

        // Act
        final result = await repository.loginEmployee('a', 'b');

        // Assert
        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure.message, isNotEmpty),
          (data) => fail('Expected Left'),
        );
      });
    });

    group('logoutEmployee', () {
      test('should return Right with void', () async {
        final result = await repository.logoutEmployee();
        expect(result, isA<Right>());
      });
    });
  });
}
