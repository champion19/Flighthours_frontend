import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_model.dart';

void main() {
  group('AirportModel', () {
    test('fromJson should parse valid JSON correctly', () {
      // Arrange
      final json = {
        'id': 'airport123',
        'uuid': 'uuid-1234',
        'name': 'El Dorado International',
        'iata_code': 'BOG',
        'city': 'Bogota',
        'country': 'Colombia',
        'status': 'active',
        'airport_type': 'international',
      };

      // Act
      final result = AirportModel.fromJson(json);

      // Assert
      expect(result.id, equals('airport123'));
      expect(result.uuid, equals('uuid-1234'));
      expect(result.name, equals('El Dorado International'));
      expect(result.iataCode, equals('BOG'));
      expect(result.city, equals('Bogota'));
      expect(result.country, equals('Colombia'));
      expect(result.status, equals('active'));
      expect(result.airportType, equals('international'));
    });

    test('fromJson should handle airport_name field', () {
      // Arrange
      final json = {
        'id': 'airport123',
        'airport_name': 'Jose Maria Cordova',
        'airport_code': 'MDE',
      };

      // Act
      final result = AirportModel.fromJson(json);

      // Assert
      expect(result.name, equals('Jose Maria Cordova'));
      expect(result.iataCode, equals('MDE'));
      expect(result.code, equals('MDE'));
    });

    test('fromJson should handle code field fallback', () {
      // Arrange
      final json = {'id': 'airport123', 'name': 'Test Airport', 'code': 'TST'};

      // Act
      final result = AirportModel.fromJson(json);

      // Assert
      expect(result.code, equals('TST'));
      expect(result.iataCode, equals('TST'));
    });

    test('fromJson should use defaults for missing fields', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final result = AirportModel.fromJson(json);

      // Assert
      expect(result.id, equals(''));
      expect(result.name, equals(''));
      expect(result.uuid, isNull);
      expect(result.city, isNull);
      expect(result.country, isNull);
    });

    test('toJson should serialize correctly', () {
      // Arrange
      const model = AirportModel(
        id: 'airport123',
        uuid: 'uuid-1234',
        name: 'El Dorado',
        code: 'BOG',
        iataCode: 'BOG',
        city: 'Bogota',
        country: 'Colombia',
        status: 'active',
        airportType: 'international',
      );

      // Act
      final result = model.toJson();

      // Assert
      expect(result['id'], equals('airport123'));
      expect(result['name'], equals('El Dorado'));
      expect(result['iata_code'], equals('BOG'));
      expect(result['city'], equals('Bogota'));
      expect(result['airport_type'], equals('international'));
    });
  });

  group('airportModelFromMap', () {
    test('should parse standard backend response', () {
      // Arrange
      const jsonString = '''
      {
        "success": true,
        "data": {
          "airports": [
            {"id": "1", "name": "El Dorado", "iata_code": "BOG", "city": "Bogota"},
            {"id": "2", "name": "Jose Maria Cordova", "iata_code": "MDE", "city": "Medellin"}
          ],
          "total": 2
        }
      }
      ''';

      // Act
      final result = airportModelFromMap(jsonString);

      // Assert
      expect(result.length, equals(2));
      expect(result[0].name, equals('El Dorado'));
      expect(result[0].iataCode, equals('BOG'));
      expect(result[1].name, equals('Jose Maria Cordova'));
    });

    test('should handle direct array response', () {
      // Arrange
      const jsonString = '''
      [
        {"id": "1", "name": "El Dorado", "iata_code": "BOG"},
        {"id": "2", "name": "Jose Maria Cordova", "iata_code": "MDE"}
      ]
      ''';

      // Act
      final result = airportModelFromMap(jsonString);

      // Assert
      expect(result.length, equals(2));
    });

    test('should return empty list for invalid structure', () {
      // Arrange
      const jsonString = '{"success": false}';

      // Act
      final result = airportModelFromMap(jsonString);

      // Assert
      expect(result, isEmpty);
    });

    test('should handle data as direct array', () {
      const jsonString = '''
      {
        "success": true,
        "data": [
          {"id": "1", "name": "El Dorado", "iata_code": "BOG"}
        ]
      }
      ''';

      final result = airportModelFromMap(jsonString);
      expect(result.length, equals(1));
      expect(result[0].name, equals('El Dorado'));
    });
  });

  group('airportModelToMap', () {
    test('should serialize list of models to JSON string', () {
      final models = [
        const AirportModel(id: '1', name: 'El Dorado', iataCode: 'BOG'),
        const AirportModel(id: '2', name: 'JMC', iataCode: 'MDE'),
      ];

      final result = airportModelToMap(models);
      expect(result, contains('"name":"El Dorado"'));
      expect(result, contains('"name":"JMC"'));
    });
  });
}
