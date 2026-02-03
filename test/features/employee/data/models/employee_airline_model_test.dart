import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_model.dart';

void main() {
  group('EmployeeAirlineResponseModel', () {
    test('fromMap should parse valid JSON correctly', () {
      // Arrange
      final json = {
        'success': true,
        'code': 'EMP_AIR_SUCCESS',
        'message': 'Airline info retrieved',
        'data': {
          'airline_id': 'AIR123',
          'airline_name': 'Avianca',
          'airline_code': 'AV',
          'bp': 'BP001',
          'start_date': '2024-01-01',
          'end_date': '2025-12-31',
        },
      };

      // Act
      final result = EmployeeAirlineResponseModel.fromMap(json);

      // Assert
      expect(result.success, isTrue);
      expect(result.code, equals('EMP_AIR_SUCCESS'));
      expect(result.data, isNotNull);
      expect(result.data!.airlineId, equals('AIR123'));
      expect(result.data!.airlineName, equals('Avianca'));
      expect(result.data!.airlineCode, equals('AV'));
      expect(result.data!.bp, equals('BP001'));
    });

    test('fromMap should handle null data', () {
      // Arrange
      final json = {
        'success': false,
        'code': 'NO_AIRLINE',
        'message': 'No airline association',
        'data': null,
      };

      // Act
      final result = EmployeeAirlineResponseModel.fromMap(json);

      // Assert
      expect(result.success, isFalse);
      expect(result.data, isNull);
    });
  });

  group('EmployeeAirlineData', () {
    test('hasAirline should return true when airlineId exists', () {
      // Arrange
      final data = EmployeeAirlineData(
        airlineId: 'AIR123',
        airlineName: 'Avianca',
      );

      // Assert
      expect(data.hasAirline, isTrue);
    });

    test('hasAirline should return false when airlineId is null', () {
      // Arrange
      final data = EmployeeAirlineData();

      // Assert
      expect(data.hasAirline, isFalse);
    });

    test('hasAirline should return false when airlineId is empty', () {
      // Arrange
      final data = EmployeeAirlineData(airlineId: '');

      // Assert
      expect(data.hasAirline, isFalse);
    });

    test('toMap should serialize correctly', () {
      // Arrange
      final data = EmployeeAirlineData(
        airlineId: 'AIR123',
        airlineName: 'Avianca',
        airlineCode: 'AV',
        bp: 'BP001',
      );

      // Act
      final result = data.toMap();

      // Assert
      expect(result['airline_id'], equals('AIR123'));
      expect(result['airline_name'], equals('Avianca'));
      expect(result['airline_code'], equals('AV'));
      expect(result['bp'], equals('BP001'));
    });

    test('fromMap should parse dates correctly', () {
      // Arrange
      final json = {
        'airline_id': 'AIR123',
        'start_date': '2024-06-15',
        'end_date': '2025-06-15',
      };

      // Act
      final result = EmployeeAirlineData.fromMap(json);

      // Assert
      expect(result.startDate, isNotNull);
      expect(result.startDate!.year, equals(2024));
      expect(result.endDate, isNotNull);
      expect(result.endDate!.year, equals(2025));
    });
  });

  group('EmployeeAirlineUpdateRequest', () {
    test('toMap should serialize correctly', () {
      // Arrange
      final request = EmployeeAirlineUpdateRequest(
        airlineId: 'AIR123',
        bp: 'BP001',
        startDate: '2024-01-01',
        endDate: '2025-12-31',
      );

      // Act
      final result = request.toMap();

      // Assert
      expect(result['airline_id'], equals('AIR123'));
      expect(result['bp'], equals('BP001'));
      expect(result['start_date'], equals('2024-01-01'));
      expect(result['end_date'], equals('2025-12-31'));
    });

    test('toJson should produce valid JSON string', () {
      // Arrange
      final request = EmployeeAirlineUpdateRequest(
        airlineId: 'AIR123',
        bp: 'BP001',
        startDate: '2024-01-01',
        endDate: '2025-12-31',
      );

      // Act
      final result = request.toJson();

      // Assert
      expect(result, contains('"airline_id":"AIR123"'));
      expect(result, contains('"bp":"BP001"'));
    });
  });
}
