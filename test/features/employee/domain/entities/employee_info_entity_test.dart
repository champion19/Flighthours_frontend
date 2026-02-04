import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/employee/domain/entities/employee_info_entity.dart';

void main() {
  group('EmployeeInfoEntity', () {
    test('should create entity with required fields', () {
      const entity = EmployeeInfoEntity(
        id: 'emp123',
        name: 'John Doe',
        email: 'john@example.com',
      );

      expect(entity.id, equals('emp123'));
      expect(entity.name, equals('John Doe'));
      expect(entity.email, equals('john@example.com'));
      expect(entity.active, isTrue); // Default value
    });

    test('should create entity with all fields', () {
      final entity = EmployeeInfoEntity(
        id: 'emp456',
        name: 'Jane Doe',
        email: 'jane@example.com',
        airline: 'Avianca',
        identificationNumber: '12345678',
        bp: 'BP001',
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 12, 31),
        active: false,
        role: 'pilot',
      );

      expect(entity.airline, equals('Avianca'));
      expect(entity.identificationNumber, equals('12345678'));
      expect(entity.bp, equals('BP001'));
      expect(entity.active, isFalse);
      expect(entity.role, equals('pilot'));
    });

    group('isActive', () {
      test('should return true when active is true', () {
        const entity = EmployeeInfoEntity(
          id: 'test',
          name: 'Test',
          email: 'test@test.com',
          active: true,
        );

        expect(entity.isActive, isTrue);
      });

      test('should return false when active is false', () {
        const entity = EmployeeInfoEntity(
          id: 'test',
          name: 'Test',
          email: 'test@test.com',
          active: false,
        );

        expect(entity.isActive, isFalse);
      });
    });

    group('dateRangeDisplay', () {
      test('should show formatted date range when both dates present', () {
        final entity = EmployeeInfoEntity(
          id: 'test',
          name: 'Test',
          email: 'test@test.com',
          startDate: DateTime(2026, 1, 15),
          endDate: DateTime(2026, 12, 31),
        );

        expect(entity.dateRangeDisplay, equals('15/1/2026 - 31/12/2026'));
      });

      test('should show N/A for end date when only start date present', () {
        final entity = EmployeeInfoEntity(
          id: 'test',
          name: 'Test',
          email: 'test@test.com',
          startDate: DateTime(2026, 3, 10),
        );

        expect(entity.dateRangeDisplay, equals('10/3/2026 - N/A'));
      });

      test('should show N/A for start date when only end date present', () {
        final entity = EmployeeInfoEntity(
          id: 'test',
          name: 'Test',
          email: 'test@test.com',
          endDate: DateTime(2026, 6, 30),
        );

        expect(entity.dateRangeDisplay, equals('N/A - 30/6/2026'));
      });

      test('should return Not specified when both dates are null', () {
        const entity = EmployeeInfoEntity(
          id: 'test',
          name: 'Test',
          email: 'test@test.com',
        );

        expect(entity.dateRangeDisplay, equals('Not specified'));
      });
    });

    group('roleDisplay', () {
      test('should return uppercase role when present', () {
        const entity = EmployeeInfoEntity(
          id: 'test',
          name: 'Test',
          email: 'test@test.com',
          role: 'pilot',
        );

        expect(entity.roleDisplay, equals('PILOT'));
      });

      test('should return N/A when role is null', () {
        const entity = EmployeeInfoEntity(
          id: 'test',
          name: 'Test',
          email: 'test@test.com',
        );

        expect(entity.roleDisplay, equals('N/A'));
      });

      test('should handle mixed case role', () {
        const entity = EmployeeInfoEntity(
          id: 'test',
          name: 'Test',
          email: 'test@test.com',
          role: 'Admin',
        );

        expect(entity.roleDisplay, equals('ADMIN'));
      });
    });

    test('props should contain all fields for Equatable', () {
      final entity = EmployeeInfoEntity(
        id: 'test',
        name: 'Test',
        email: 'test@test.com',
        airline: 'Airline',
        identificationNumber: '123',
        bp: 'BP',
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 12, 31),
        active: true,
        role: 'pilot',
      );

      expect(entity.props.length, equals(10));
    });
  });
}
