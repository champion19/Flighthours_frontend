import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/login/domain/entities/EmployeeEntity.dart';

void main() {
  group('EmployeeEntity Tests', () {
    test('should create entity with all required fields', () {
      final entity = EmployeeEntity(
        id: '1',
        name: 'John Doe',
        age: 30,
        email: 'john@example.com',
        token: 'token-123',
      );

      expect(entity.id, equals('1'));
      expect(entity.name, equals('John Doe'));
      expect(entity.age, equals(30));
      expect(entity.email, equals('john@example.com'));
      expect(entity.token, equals('token-123'));
    });

    test('should store different employee data correctly', () {
      final entity = EmployeeEntity(
        id: '2',
        name: 'Jane Smith',
        age: 25,
        email: 'jane@company.com',
        token: 'jwt-token-xyz',
      );

      expect(entity.id, equals('2'));
      expect(entity.name, equals('Jane Smith'));
      expect(entity.age, equals(25));
      expect(entity.email, equals('jane@company.com'));
      expect(entity.token, equals('jwt-token-xyz'));
    });

    test('should handle edge case with empty strings', () {
      final entity = EmployeeEntity(
        id: '',
        name: '',
        age: 0,
        email: '',
        token: '',
      );

      expect(entity.id, isEmpty);
      expect(entity.name, isEmpty);
      expect(entity.age, equals(0));
      expect(entity.email, isEmpty);
      expect(entity.token, isEmpty);
    });

    test('should handle entity with special characters in name', () {
      final entity = EmployeeEntity(
        id: '3',
        name: "O'Connor-Smith",
        age: 45,
        email: 'oconnor@test.com',
        token: 'special-token',
      );

      expect(entity.name, equals("O'Connor-Smith"));
    });
  });
}
