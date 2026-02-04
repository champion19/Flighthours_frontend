import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/login/data/models/login_model.dart';

void main() {
  group('EmployeeModel', () {
    test('fromMap should parse valid JSON', () {
      final json = {
        'id': 'emp123',
        'name': 'John Doe',
        'age': 35,
        'email': 'john@example.com',
        'token': 'jwt_token_123',
      };

      final result = EmployeeModel.fromMap(json);

      expect(result.id, equals('emp123'));
      expect(result.name, equals('John Doe'));
      expect(result.age, equals(35));
      expect(result.email, equals('john@example.com'));
      expect(result.token, equals('jwt_token_123'));
    });

    test('fromJson should parse JSON string', () {
      const jsonStr =
          '{"id":"123","name":"Jane","age":28,"email":"jane@test.com","token":"token456"}';

      final result = EmployeeModel.fromJson(jsonStr);

      expect(result.id, equals('123'));
      expect(result.name, equals('Jane'));
      expect(result.age, equals(28));
    });

    test('toMap should serialize correctly', () {
      final model = EmployeeModel(
        id: 'emp789',
        name: 'Test User',
        age: 40,
        email: 'test@example.com',
        token: 'token_abc',
      );

      final map = model.toMap();

      expect(map['id'], equals('emp789'));
      expect(map['name'], equals('Test User'));
      expect(map['age'], equals(40));
      expect(map['email'], equals('test@example.com'));
      expect(map['token'], equals('token_abc'));
    });

    test('toJson should return valid JSON string', () {
      final model = EmployeeModel(
        id: 'emp001',
        name: 'User',
        age: 25,
        email: 'user@test.com',
        token: 'token',
      );

      final jsonStr = model.toJson();

      expect(jsonStr, contains('"id":"emp001"'));
      expect(jsonStr, contains('"name":"User"'));
      expect(jsonStr, contains('"age":25'));
    });
  });
}
