import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';

void main() {
  group('EmployeeEntityRegister', () {
    test('should create entity with all required fields', () {
      final entity = EmployeeEntityRegister(
        id: 'emp123',
        name: 'John Doe',
        idNumber: '123456789',
        email: 'john@example.com',
        password: 'Password123!',
        fechaInicio: '2024-01-01',
        fechaFin: '2025-12-31',
      );

      expect(entity.id, equals('emp123'));
      expect(entity.name, equals('John Doe'));
      expect(entity.idNumber, equals('123456789'));
      expect(entity.email, equals('john@example.com'));
      expect(entity.password, equals('Password123!'));
      expect(entity.fechaInicio, equals('2024-01-01'));
      expect(entity.fechaFin, equals('2025-12-31'));
    });

    test('should create entity with optional fields', () {
      final entity = EmployeeEntityRegister(
        id: 'emp123',
        name: 'John Doe',
        idNumber: '123456789',
        email: 'john@example.com',
        password: 'Password123!',
        fechaInicio: '2024-01-01',
        fechaFin: '2025-12-31',
        emailConfirmed: true,
        bp: 'BP123',
        vigente: true,
        airline: 'Avianca',
        role: 'admin',
      );

      expect(entity.emailConfirmed, isTrue);
      expect(entity.bp, equals('BP123'));
      expect(entity.vigente, isTrue);
      expect(entity.airline, equals('Avianca'));
      expect(entity.role, equals('admin'));
    });

    group('empty factory', () {
      test('should create empty entity with default values', () {
        final entity = EmployeeEntityRegister.empty();

        expect(entity.id, isEmpty);
        expect(entity.name, isEmpty);
        expect(entity.idNumber, isEmpty);
        expect(entity.email, isEmpty);
        expect(entity.password, isEmpty);
        expect(entity.emailConfirmed, isFalse);
        expect(entity.bp, isNull);
        expect(entity.fechaInicio, isEmpty);
        expect(entity.fechaFin, isEmpty);
        expect(entity.vigente, isNull);
        expect(entity.airline, isNull);
        expect(entity.role, equals('pilot'));
      });
    });

    group('copyWith', () {
      test('should copy entity with new name', () {
        final original = EmployeeEntityRegister(
          id: 'emp123',
          name: 'John Doe',
          idNumber: '123456789',
          email: 'john@example.com',
          password: 'Password123!',
          fechaInicio: '2024-01-01',
          fechaFin: '2025-12-31',
        );

        final copied = original.copyWith(name: 'Jane Doe');

        expect(copied.name, equals('Jane Doe'));
        expect(copied.id, equals('emp123'));
        expect(copied.email, equals('john@example.com'));
      });

      test('should copy entity with multiple new fields', () {
        final original = EmployeeEntityRegister.empty();

        final copied = original.copyWith(
          id: 'new123',
          name: 'New User',
          email: 'new@example.com',
          role: 'admin',
        );

        expect(copied.id, equals('new123'));
        expect(copied.name, equals('New User'));
        expect(copied.email, equals('new@example.com'));
        expect(copied.role, equals('admin'));
      });

      test('should preserve original values when not copying', () {
        final original = EmployeeEntityRegister(
          id: 'emp123',
          name: 'John Doe',
          idNumber: '123456789',
          email: 'john@example.com',
          password: 'Password123!',
          fechaInicio: '2024-01-01',
          fechaFin: '2025-12-31',
          emailConfirmed: true,
          bp: 'BP001',
          vigente: true,
          airline: 'Avianca',
          role: 'pilot',
        );

        final copied = original.copyWith();

        expect(copied.id, equals(original.id));
        expect(copied.name, equals(original.name));
        expect(copied.idNumber, equals(original.idNumber));
        expect(copied.email, equals(original.email));
        expect(copied.password, equals(original.password));
        expect(copied.fechaInicio, equals(original.fechaInicio));
        expect(copied.fechaFin, equals(original.fechaFin));
        expect(copied.emailConfirmed, equals(original.emailConfirmed));
        expect(copied.bp, equals(original.bp));
        expect(copied.vigente, equals(original.vigente));
        expect(copied.airline, equals(original.airline));
        expect(copied.role, equals(original.role));
      });
    });
  });
}
