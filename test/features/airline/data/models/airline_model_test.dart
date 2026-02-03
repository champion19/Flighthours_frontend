import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_model.dart';

void main() {
  group('AirlineModel', () {
    test('fromJson should parse valid JSON correctly', () {
      // Arrange
      final json = {
        'id': 'airline123',
        'uuid': 'uuid-1234',
        'airline_name': 'Avianca',
        'airline_code': 'AV',
      };

      // Act
      final result = AirlineModel.fromJson(json);

      // Assert
      expect(result.id, equals('airline123'));
      expect(result.uuid, equals('uuid-1234'));
      expect(result.name, equals('Avianca'));
      expect(result.code, equals('AV'));
    });

    test('fromJson should handle name and code field names', () {
      // Arrange - using 'name' and 'code' instead of 'airline_name' and 'airline_code'
      final json = {'id': 'airline123', 'name': 'LATAM', 'code': 'LA'};

      // Act
      final result = AirlineModel.fromJson(json);

      // Assert
      expect(result.name, equals('LATAM'));
      expect(result.code, equals('LA'));
    });

    test('fromJson should use defaults for missing fields', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final result = AirlineModel.fromJson(json);

      // Assert
      expect(result.id, equals(''));
      expect(result.name, equals(''));
      expect(result.uuid, isNull);
      expect(result.code, isNull);
    });

    test('toJson should serialize correctly', () {
      // Arrange
      const model = AirlineModel(
        id: 'airline123',
        uuid: 'uuid-1234',
        name: 'Avianca',
        code: 'AV',
      );

      // Act
      final result = model.toJson();

      // Assert
      expect(result['id'], equals('airline123'));
      expect(result['uuid'], equals('uuid-1234'));
      expect(result['name'], equals('Avianca'));
      expect(result['code'], equals('AV'));
    });
  });

  group('airlineModelFromMap', () {
    test('should parse standard backend response', () {
      // Arrange
      const jsonString = '''
      {
        "success": true,
        "data": {
          "airlines": [
            {"id": "1", "airline_name": "Avianca", "airline_code": "AV"},
            {"id": "2", "airline_name": "LATAM", "airline_code": "LA"}
          ],
          "total": 2
        }
      }
      ''';

      // Act
      final result = airlineModelFromMap(jsonString);

      // Assert
      expect(result.length, equals(2));
      expect(result[0].name, equals('Avianca'));
      expect(result[0].code, equals('AV'));
      expect(result[1].name, equals('LATAM'));
    });

    test('should handle direct array response', () {
      // Arrange
      const jsonString = '''
      [
        {"id": "1", "name": "Avianca", "code": "AV"},
        {"id": "2", "name": "LATAM", "code": "LA"}
      ]
      ''';

      // Act
      final result = airlineModelFromMap(jsonString);

      // Assert
      expect(result.length, equals(2));
      expect(result[0].name, equals('Avianca'));
    });

    test('should handle data as direct array', () {
      // Arrange
      const jsonString = '''
      {
        "success": true,
        "data": [
          {"id": "1", "airline_name": "Avianca", "airline_code": "AV"}
        ]
      }
      ''';

      // Act
      final result = airlineModelFromMap(jsonString);

      // Assert
      expect(result.length, equals(1));
    });

    test('should return empty list for invalid structure', () {
      // Arrange
      const jsonString = '{"success": false}';

      // Act
      final result = airlineModelFromMap(jsonString);

      // Assert
      expect(result, isEmpty);
    });
  });
}
