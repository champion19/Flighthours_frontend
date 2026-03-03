import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_model.dart';
import 'package:flight_hours_app/core/constants/schema_constants.dart';

void main() {
  group('airlineModelToMap', () {
    test('should serialize list of AirlineModel to JSON string', () {
      const models = [
        AirlineModel(id: '1', name: 'Avianca', code: 'AV', active: true),
        AirlineModel(id: '2', name: 'LATAM', code: 'LA', active: false),
      ];
      final jsonStr = airlineModelToMap(models);
      expect(jsonStr, contains('"id":"1"'));
      expect(jsonStr, contains('"name":"LATAM"'));
    });

    test('should return empty array for empty list', () {
      final jsonStr = airlineModelToMap([]);
      expect(jsonStr, '[]');
    });
  });

  group('SchemaConstants', () {
    test('tailNumberPattern should match valid patterns', () {
      expect(SchemaConstants.tailNumberPattern.hasMatch('HK-5432'), isTrue);
      expect(SchemaConstants.tailNumberPattern.hasMatch('CC-BFA'), isTrue);
      expect(SchemaConstants.tailNumberPattern.hasMatch('A320'), isTrue);
    });

    test('timePattern should match HH:MM format', () {
      expect(SchemaConstants.timePattern.hasMatch('21:17'), isTrue);
      expect(SchemaConstants.timePattern.hasMatch('00:00'), isTrue);
      expect(SchemaConstants.timePattern.hasMatch('abc'), isFalse);
    });

    test('datePattern should match YYYY-MM-DD format', () {
      expect(SchemaConstants.datePattern.hasMatch('2024-01-15'), isTrue);
      expect(SchemaConstants.datePattern.hasMatch('invalid'), isFalse);
    });

    test('digitsOnlyPattern should match only digits', () {
      expect(SchemaConstants.digitsOnlyPattern.hasMatch('1234567'), isTrue);
      expect(SchemaConstants.digitsOnlyPattern.hasMatch('abc'), isFalse);
    });

    test('constants should have expected values', () {
      expect(SchemaConstants.emailMinLength, 5);
      expect(SchemaConstants.passwordMinLength, 8);
      expect(SchemaConstants.bookPageMinimum, 1);
    });
  });
}
