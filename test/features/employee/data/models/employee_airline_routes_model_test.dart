import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_routes_model.dart';

void main() {
  group('EmployeeAirlineRoutesResponseModel', () {
    test('fromMap should parse valid response', () {
      // Arrange
      final json = {
        'success': true,
        'code': 'ROUTES_SUCCESS',
        'message': 'Routes retrieved successfully',
        'data': [
          {
            'id': 'route1',
            'uuid': 'uuid-1234',
            'airline_id': 'airline1',
            'route_id': 'route1',
            'origin_airport_code': 'BOG',
            'destination_airport_code': 'MDE',
            'status': 'active',
          },
          {
            'id': 'route2',
            'uuid': 'uuid-5678',
            'airline_id': 'airline1',
            'route_id': 'route2',
            'origin_airport_code': 'BOG',
            'destination_airport_code': 'CLO',
            'status': 'active',
          },
        ],
      };

      // Act
      final result = EmployeeAirlineRoutesResponseModel.fromMap(json);

      // Assert
      expect(result.success, isTrue);
      expect(result.code, equals('ROUTES_SUCCESS'));
      expect(result.message, equals('Routes retrieved successfully'));
      expect(result.data.length, equals(2));
    });

    test('fromMap should handle empty data list', () {
      // Arrange
      final json = {
        'success': true,
        'code': 'NO_ROUTES',
        'message': 'No routes found',
        'data': [],
      };

      // Act
      final result = EmployeeAirlineRoutesResponseModel.fromMap(json);

      // Assert
      expect(result.success, isTrue);
      expect(result.data, isEmpty);
    });

    test('fromMap should handle null data', () {
      // Arrange
      final json = {
        'success': false,
        'code': 'ERROR',
        'message': 'Error occurred',
      };

      // Act
      final result = EmployeeAirlineRoutesResponseModel.fromMap(json);

      // Assert
      expect(result.success, isFalse);
      expect(result.data, isEmpty);
    });

    test('fromMap should use defaults for missing fields', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final result = EmployeeAirlineRoutesResponseModel.fromMap(json);

      // Assert
      expect(result.success, isFalse);
      expect(result.code, isEmpty);
      expect(result.message, isEmpty);
      expect(result.data, isEmpty);
    });

    test('fromMap should parse route data correctly', () {
      // Arrange
      final json = {
        'success': true,
        'code': 'SUCCESS',
        'message': 'OK',
        'data': [
          {
            'id': 'route1',
            'airline_id': 'airline1',
            'route_id': 'r001',
            'origin_airport_code': 'JFK',
            'destination_airport_code': 'LAX',
            'route_type': 'Nacional',
            'estimated_flight_time': '05:30:00',
            'status': 'active',
          },
        ],
      };

      // Act
      final result = EmployeeAirlineRoutesResponseModel.fromMap(json);

      // Assert
      expect(result.data.first.originAirportCode, equals('JFK'));
      expect(result.data.first.destinationAirportCode, equals('LAX'));
    });
  });
}
