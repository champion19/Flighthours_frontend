import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';

void main() {
  group('LoginEntity', () {
    test('should create entity with all fields', () {
      const entity = LoginEntity(
        accessToken: 'access123',
        refreshToken: 'refresh456',
        expiresIn: 3600,
        tokenType: 'Bearer',
        employeeId: 'emp123',
        email: 'test@example.com',
        name: 'Test User',
        roles: ['pilot', 'admin'],
      );

      expect(entity.accessToken, equals('access123'));
      expect(entity.refreshToken, equals('refresh456'));
      expect(entity.expiresIn, equals(3600));
      expect(entity.tokenType, equals('Bearer'));
      expect(entity.employeeId, equals('emp123'));
      expect(entity.email, equals('test@example.com'));
      expect(entity.name, equals('Test User'));
      expect(entity.roles, containsAll(['pilot', 'admin']));
    });

    test('should create empty entity with factory', () {
      final entity = LoginEntity.empty();

      expect(entity.accessToken, isEmpty);
      expect(entity.refreshToken, isEmpty);
      expect(entity.expiresIn, equals(0));
      expect(entity.tokenType, equals('Bearer'));
      expect(entity.roles, isEmpty);
    });

    test('isValid should return true when tokens are present', () {
      const entity = LoginEntity(
        accessToken: 'token',
        refreshToken: 'refresh',
        expiresIn: 3600,
        tokenType: 'Bearer',
      );

      expect(entity.isValid, isTrue);
    });

    test('isValid should return false when accessToken is empty', () {
      const entity = LoginEntity(
        accessToken: '',
        refreshToken: 'refresh',
        expiresIn: 3600,
        tokenType: 'Bearer',
      );

      expect(entity.isValid, isFalse);
    });

    test('isValid should return false when refreshToken is empty', () {
      const entity = LoginEntity(
        accessToken: 'token',
        refreshToken: '',
        expiresIn: 3600,
        tokenType: 'Bearer',
      );

      expect(entity.isValid, isFalse);
    });

    test('hasEmployeeId should return true when employeeId is present', () {
      const entity = LoginEntity(
        accessToken: 'token',
        refreshToken: 'refresh',
        expiresIn: 3600,
        tokenType: 'Bearer',
        employeeId: 'emp123',
      );

      expect(entity.hasEmployeeId, isTrue);
    });

    test('hasEmployeeId should return false when employeeId is null', () {
      const entity = LoginEntity(
        accessToken: 'token',
        refreshToken: 'refresh',
        expiresIn: 3600,
        tokenType: 'Bearer',
      );

      expect(entity.hasEmployeeId, isFalse);
    });

    test('hasEmployeeId should return false when employeeId is empty', () {
      const entity = LoginEntity(
        accessToken: 'token',
        refreshToken: 'refresh',
        expiresIn: 3600,
        tokenType: 'Bearer',
        employeeId: '',
      );

      expect(entity.hasEmployeeId, isFalse);
    });

    test('props should contain all fields for Equatable', () {
      const entity = LoginEntity(
        accessToken: 'token',
        refreshToken: 'refresh',
        expiresIn: 3600,
        tokenType: 'Bearer',
        employeeId: 'emp123',
        email: 'test@example.com',
        name: 'Test',
        roles: ['pilot'],
      );

      expect(entity.props.length, equals(8));
    });

    test('should be equal when all props are the same', () {
      const entity1 = LoginEntity(
        accessToken: 'token',
        refreshToken: 'refresh',
        expiresIn: 3600,
        tokenType: 'Bearer',
      );
      const entity2 = LoginEntity(
        accessToken: 'token',
        refreshToken: 'refresh',
        expiresIn: 3600,
        tokenType: 'Bearer',
      );

      expect(entity1, equals(entity2));
    });

    test('default roles should be empty list', () {
      const entity = LoginEntity(
        accessToken: 'token',
        refreshToken: 'refresh',
        expiresIn: 3600,
        tokenType: 'Bearer',
      );

      expect(entity.roles, isEmpty);
    });
  });
}
