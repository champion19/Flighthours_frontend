import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/airline_route/data/datasources/airline_route_remote_data_source.dart';

void main() {
  group('AirlineRouteStatusResponse', () {
    group('fromJson', () {
      test('should create from valid json', () {
        // Arrange
        final json = {
          'success': true,
          'message': 'Route activated successfully',
        };

        // Act
        final result = AirlineRouteStatusResponse.fromJson(json);

        // Assert
        expect(result.success, isTrue);
        expect(result.message, equals('Route activated successfully'));
      });

      test('should use defaults when fields are missing', () {
        // Arrange
        final json = <String, dynamic>{};

        // Act
        final result = AirlineRouteStatusResponse.fromJson(json);

        // Assert
        expect(result.success, isTrue);
        expect(result.message, equals('Operation completed'));
      });
    });

    group('fromError', () {
      test('should create error response from map with message', () {
        // Arrange
        final data = {'message': 'Route not found'};

        // Act
        final result = AirlineRouteStatusResponse.fromError(data);

        // Assert
        expect(result.success, isFalse);
        expect(result.message, equals('Route not found'));
      });

      test('should create error response from map with error field', () {
        // Arrange
        final data = {'error': 'Something went wrong'};

        // Act
        final result = AirlineRouteStatusResponse.fromError(data);

        // Assert
        expect(result.success, isFalse);
        expect(result.message, equals('Something went wrong'));
      });

      test('should use default message for non-map data', () {
        // Arrange
        const data = 'Some string error';

        // Act
        final result = AirlineRouteStatusResponse.fromError(data);

        // Assert
        expect(result.success, isFalse);
        expect(result.message, equals('An error occurred'));
      });

      test('should use default message for empty map', () {
        // Arrange
        final data = <String, dynamic>{};

        // Act
        final result = AirlineRouteStatusResponse.fromError(data);

        // Assert
        expect(result.success, isFalse);
        expect(result.message, equals('An error occurred'));
      });
    });
  });
}
