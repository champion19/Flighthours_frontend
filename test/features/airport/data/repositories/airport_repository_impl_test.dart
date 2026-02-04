import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airport/data/datasources/airport_remote_data_source.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_model.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';
import 'package:flight_hours_app/features/airport/data/repositories/airport_repository_impl.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';

class MockAirportRemoteDataSource extends Mock
    implements AirportRemoteDataSource {}

void main() {
  late MockAirportRemoteDataSource mockDataSource;
  late AirportRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockAirportRemoteDataSource();
    repository = AirportRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('AirportRepositoryImpl', () {
    group('getAirports', () {
      test('should return list from datasource', () async {
        // Arrange
        final airports = <AirportModel>[
          const AirportModel(
            id: 'ap1',
            name: 'El Dorado',
            iataCode: 'BOG',
            city: 'Bogota',
            country: 'Colombia',
          ),
          const AirportModel(
            id: 'ap2',
            name: 'Jose Maria Cordova',
            iataCode: 'MDE',
            city: 'Medellin',
            country: 'Colombia',
          ),
        ];
        when(
          () => mockDataSource.getAirports(),
        ).thenAnswer((_) async => airports);

        // Act
        final result = await repository.getAirports();

        // Assert
        expect(result, isA<List<AirportEntity>>());
        expect(result.length, equals(2));
        verify(() => mockDataSource.getAirports()).called(1);
      });
    });

    group('getAirportById', () {
      test('should return entity from datasource', () async {
        // Arrange
        const airport = AirportModel(
          id: 'ap1',
          name: 'El Dorado',
          iataCode: 'BOG',
          city: 'Bogota',
          country: 'Colombia',
        );
        when(
          () => mockDataSource.getAirportById(any()),
        ).thenAnswer((_) async => airport);

        // Act
        final result = await repository.getAirportById('ap1');

        // Assert
        expect(result, isA<AirportEntity>());
        expect(result?.name, equals('El Dorado'));
        verify(() => mockDataSource.getAirportById('ap1')).called(1);
      });

      test('should return null when not found', () async {
        // Arrange
        when(
          () => mockDataSource.getAirportById(any()),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.getAirportById('notfound');

        // Assert
        expect(result, isNull);
      });
    });

    group('activateAirport', () {
      test('should return status response from datasource', () async {
        // Arrange
        final response = AirportStatusResponseModel(
          success: true,
          code: 'ACTIVATED',
          message: 'Airport activated',
        );
        when(
          () => mockDataSource.activateAirport(any()),
        ).thenAnswer((_) async => response);

        // Act
        final result = await repository.activateAirport('ap1');

        // Assert
        expect(result, isA<AirportStatusResponseModel>());
        expect(result.success, isTrue);
        verify(() => mockDataSource.activateAirport('ap1')).called(1);
      });
    });

    group('deactivateAirport', () {
      test('should return status response from datasource', () async {
        // Arrange
        final response = AirportStatusResponseModel(
          success: true,
          code: 'DEACTIVATED',
          message: 'Airport deactivated',
        );
        when(
          () => mockDataSource.deactivateAirport(any()),
        ).thenAnswer((_) async => response);

        // Act
        final result = await repository.deactivateAirport('ap1');

        // Assert
        expect(result, isA<AirportStatusResponseModel>());
        expect(result.success, isTrue);
        verify(() => mockDataSource.deactivateAirport('ap1')).called(1);
      });
    });
  });
}
