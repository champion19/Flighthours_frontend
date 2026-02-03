import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/register/data/models/register_model.dart';

void main() {
  group('RegisterModel', () {
    test('fromMap should parse valid JSON', () {
      final json = {
        'id': 'emp123',
        'name': 'John Doe',
        'email': 'john@example.com',
        'password': 'Password123!',
        'emailConfirmed': true,
        'identification_number': '123456789',
        'bp': 'BP001',
        'start_date': '2024-01-01',
        'end_date': '2025-12-31',
        'active': true,
        'airline': 'Avianca',
      };

      final result = RegisterModel.fromMap(json);

      expect(result.id, equals('emp123'));
      expect(result.name, equals('John Doe'));
      expect(result.email, equals('john@example.com'));
      expect(result.password, equals('Password123!'));
      expect(result.emailConfirmed, isTrue);
      expect(result.idNumber, equals('123456789'));
      expect(result.bp, equals('BP001'));
      expect(result.fechaInicio, equals('2024-01-01'));
      expect(result.fechaFin, equals('2025-12-31'));
      expect(result.vigente, isTrue);
      expect(result.airline, equals('Avianca'));
    });

    test('fromMap should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final result = RegisterModel.fromMap(json);

      expect(result.id, isEmpty);
      expect(result.name, isEmpty);
      expect(result.email, isEmpty);
      expect(result.idNumber, isEmpty);
      expect(result.emailConfirmed, isFalse);
      expect(result.vigente, isFalse);
    });

    test('fromMap should set airline to null when empty', () {
      final json = {
        'id': 'emp123',
        'name': 'John',
        'email': 'john@test.com',
        'identification_number': '123',
        'start_date': '2024-01-01',
        'end_date': '2025-12-31',
        'airline': '',
      };

      final result = RegisterModel.fromMap(json);

      expect(result.airline, isNull);
    });

    test('fromMap should set bp to null when empty', () {
      final json = {
        'id': 'emp123',
        'name': 'John',
        'email': 'john@test.com',
        'identification_number': '123',
        'start_date': '2024-01-01',
        'end_date': '2025-12-31',
        'bp': '',
      };

      final result = RegisterModel.fromMap(json);

      expect(result.bp, isNull);
    });

    test('fromJson should parse JSON string', () {
      const jsonStr =
          '{"id":"123","name":"Test","email":"test@test.com","identification_number":"456","start_date":"2024-01-01","end_date":"2025-12-31"}';

      final result = RegisterModel.fromJson(jsonStr);

      expect(result.id, equals('123'));
      expect(result.name, equals('Test'));
    });

    group('toMap', () {
      test('should include required fields', () {
        final model = RegisterModel(
          id: 'emp123',
          name: 'John Doe',
          email: 'john@example.com',
          idNumber: '123456789',
          fechaInicio: '2024-01-01',
          fechaFin: '2025-12-31',
        );

        final map = model.toMap();

        expect(map['id'], equals('emp123'));
        expect(map['name'], equals('John Doe'));
        expect(map['email'], equals('john@example.com'));
        expect(map['idNumber'], equals('123456789'));
        expect(map['fechaInicio'], equals('2024-01-01'));
        expect(map['fechaFin'], equals('2025-12-31'));
      });

      test('should include password when not empty', () {
        final model = RegisterModel(
          id: 'emp123',
          name: 'John',
          email: 'john@test.com',
          idNumber: '123',
          fechaInicio: '2024-01-01',
          fechaFin: '2025-12-31',
          password: 'SecretPass123!',
        );

        final map = model.toMap();

        expect(map['password'], equals('SecretPass123!'));
      });

      test('should NOT include password when empty', () {
        final model = RegisterModel(
          id: 'emp123',
          name: 'John',
          email: 'john@test.com',
          idNumber: '123',
          fechaInicio: '2024-01-01',
          fechaFin: '2025-12-31',
          password: '',
        );

        final map = model.toMap();

        expect(map.containsKey('password'), isFalse);
      });

      test('should include emailConfirmed when not null', () {
        final model = RegisterModel(
          id: 'emp123',
          name: 'John',
          email: 'john@test.com',
          idNumber: '123',
          fechaInicio: '2024-01-01',
          fechaFin: '2025-12-31',
          emailConfirmed: true,
        );

        final map = model.toMap();

        expect(map['emailConfirmed'], isTrue);
      });

      test('should include bp when not empty', () {
        final model = RegisterModel(
          id: 'emp123',
          name: 'John',
          email: 'john@test.com',
          idNumber: '123',
          fechaInicio: '2024-01-01',
          fechaFin: '2025-12-31',
          bp: 'BP001',
        );

        final map = model.toMap();

        expect(map['bp'], equals('BP001'));
      });

      test('should NOT include bp when empty', () {
        final model = RegisterModel(
          id: 'emp123',
          name: 'John',
          email: 'john@test.com',
          idNumber: '123',
          fechaInicio: '2024-01-01',
          fechaFin: '2025-12-31',
          bp: '',
        );

        final map = model.toMap();

        expect(map.containsKey('bp'), isFalse);
      });

      test('should include airline when not empty', () {
        final model = RegisterModel(
          id: 'emp123',
          name: 'John',
          email: 'john@test.com',
          idNumber: '123',
          fechaInicio: '2024-01-01',
          fechaFin: '2025-12-31',
          airline: 'Avianca',
        );

        final map = model.toMap();

        expect(map['airline'], equals('Avianca'));
      });

      test('should NOT include airline when empty', () {
        final model = RegisterModel(
          id: 'emp123',
          name: 'John',
          email: 'john@test.com',
          idNumber: '123',
          fechaInicio: '2024-01-01',
          fechaFin: '2025-12-31',
          airline: '',
        );

        final map = model.toMap();

        expect(map.containsKey('airline'), isFalse);
      });

      test('should include vigente when not null', () {
        final model = RegisterModel(
          id: 'emp123',
          name: 'John',
          email: 'john@test.com',
          idNumber: '123',
          fechaInicio: '2024-01-01',
          fechaFin: '2025-12-31',
          vigente: true,
        );

        final map = model.toMap();

        expect(map['vigente'], isTrue);
      });
    });

    test('toJson should return valid JSON string', () {
      final model = RegisterModel(
        id: 'emp123',
        name: 'John',
        email: 'john@test.com',
        idNumber: '123',
        fechaInicio: '2024-01-01',
        fechaFin: '2025-12-31',
      );

      final jsonStr = model.toJson();

      expect(jsonStr, contains('"id":"emp123"'));
      expect(jsonStr, contains('"name":"John"'));
    });
  });
}
