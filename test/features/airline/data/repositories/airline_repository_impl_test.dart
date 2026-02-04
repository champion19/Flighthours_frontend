import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airline/data/datasources/airline_remote_data_source.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_model.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';
import 'package:flight_hours_app/features/airline/data/repositories/airline_repository_impl.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';

class MockAirlineRemoteDataSource extends Mock
    implements AirlineRemoteDataSource {}

void main() {
  late MockAirlineRemoteDataSource mockDataSource;
  late AirlineRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockAirlineRemoteDataSource();
    repository = AirlineRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('AirlineRepositoryImpl', () {
    group('getAirlines', () {
      test('should return list from datasource', () async {
        // Arrange
        final airlines = <AirlineModel>[
          const AirlineModel(id: 'a1', name: 'Avianca', code: 'AV'),
          const AirlineModel(id: 'a2', name: 'Latam', code: 'LA'),
        ];
        when(
          () => mockDataSource.getAirlines(),
        ).thenAnswer((_) async => airlines);

        // Act
        final result = await repository.getAirlines();

        // Assert
        expect(result, isA<List<AirlineEntity>>());
        expect(result.length, equals(2));
        verify(() => mockDataSource.getAirlines()).called(1);
      });
    });

    group('getAirlineById', () {
      test('should return entity from datasource', () async {
        // Arrange
        const airline = AirlineModel(id: 'a1', name: 'Avianca', code: 'AV');
        when(
          () => mockDataSource.getAirlineById(any()),
        ).thenAnswer((_) async => airline);

        // Act
        final result = await repository.getAirlineById('a1');

        // Assert
        expect(result, isA<AirlineEntity>());
        expect(result?.name, equals('Avianca'));
        verify(() => mockDataSource.getAirlineById('a1')).called(1);
      });

      test('should return null when not found', () async {
        // Arrange
        when(
          () => mockDataSource.getAirlineById(any()),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.getAirlineById('notfound');

        // Assert
        expect(result, isNull);
      });
    });

    group('activateAirline', () {
      test('should return status response from datasource', () async {
        // Arrange
        final response = AirlineStatusResponseModel(
          success: true,
          code: 'ACTIVATED',
          message: 'Airline activated',
        );
        when(
          () => mockDataSource.activateAirline(any()),
        ).thenAnswer((_) async => response);

        // Act
        final result = await repository.activateAirline('a1');

        // Assert
        expect(result, isA<AirlineStatusResponseModel>());
        expect(result.success, isTrue);
        verify(() => mockDataSource.activateAirline('a1')).called(1);
      });
    });

    group('deactivateAirline', () {
      test('should return status response from datasource', () async {
        // Arrange
        final response = AirlineStatusResponseModel(
          success: true,
          code: 'DEACTIVATED',
          message: 'Airline deactivated',
        );
        when(
          () => mockDataSource.deactivateAirline(any()),
        ).thenAnswer((_) async => response);

        // Act
        final result = await repository.deactivateAirline('a1');

        // Assert
        expect(result, isA<AirlineStatusResponseModel>());
        expect(result.success, isTrue);
        verify(() => mockDataSource.deactivateAirline('a1')).called(1);
      });
    });
  });
}
