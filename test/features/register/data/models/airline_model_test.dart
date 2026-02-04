import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/register/data/models/airline_model.dart';

void main() {
  group('AirlineModel (register)', () {
    group('fromMap', () {
      test('should parse valid JSON', () {
        final json = {'id': 'airline001', 'name': 'Avianca'};

        final result = AirlineModel.fromMap(json);

        expect(result.id, equals('airline001'));
        expect(result.name, equals('Avianca'));
      });
    });

    group('toMap', () {
      test('should serialize correctly', () {
        final model = AirlineModel(id: 'air123', name: 'LATAM');

        final map = model.toMap();

        expect(map['id'], equals('air123'));
        expect(map['name'], equals('LATAM'));
      });
    });
  });

  group('airlineModelFromMap', () {
    test('should parse array of airlines from JSON string', () {
      const jsonStr = '[{"id":"1","name":"Avianca"},{"id":"2","name":"LATAM"}]';

      final result = airlineModelFromMap(jsonStr);

      expect(result.length, equals(2));
      expect(result[0].id, equals('1'));
      expect(result[0].name, equals('Avianca'));
      expect(result[1].id, equals('2'));
      expect(result[1].name, equals('LATAM'));
    });

    test('should handle empty array', () {
      const jsonStr = '[]';

      final result = airlineModelFromMap(jsonStr);

      expect(result, isEmpty);
    });
  });

  group('airlineModelToMap', () {
    test('should serialize list to JSON string', () {
      final airlines = [
        AirlineModel(id: '1', name: 'Avianca'),
        AirlineModel(id: '2', name: 'Copa'),
      ];

      final result = airlineModelToMap(airlines);

      expect(result, contains('"id":"1"'));
      expect(result, contains('"name":"Avianca"'));
      expect(result, contains('"id":"2"'));
      expect(result, contains('"name":"Copa"'));
    });
  });
}
