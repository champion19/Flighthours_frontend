import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airline_route/data/datasources/airline_route_remote_data_source.dart';
import 'package:flight_hours_app/features/airline_route/data/models/airline_route_model.dart';
import 'package:flight_hours_app/features/airline_route/data/repositories/airline_route_repository_impl.dart';
import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';

class MockAirlineRouteRemoteDataSource extends Mock
    implements AirlineRouteRemoteDataSource {}

void main() {
  late MockAirlineRouteRemoteDataSource mockDataSource;
  late AirlineRouteRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockAirlineRouteRemoteDataSource();
    repository = AirlineRouteRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('AirlineRouteRepositoryImpl', () {
    group('getAirlineRoutes', () {
      test('should return list from datasource', () async {
        // Arrange
        final routes = <AirlineRouteModel>[
          const AirlineRouteModel(id: 'ar1', airlineId: 'a1', routeId: 'r1'),
          const AirlineRouteModel(id: 'ar2', airlineId: 'a1', routeId: 'r2'),
        ];
        when(
          () => mockDataSource.getAirlineRoutes(),
        ).thenAnswer((_) async => routes);

        // Act
        final result = await repository.getAirlineRoutes();

        // Assert
        expect(result, isA<List<AirlineRouteEntity>>());
        expect(result.length, equals(2));
        verify(() => mockDataSource.getAirlineRoutes()).called(1);
      });

      test('should return empty list when no routes', () async {
        // Arrange
        when(
          () => mockDataSource.getAirlineRoutes(),
        ).thenAnswer((_) async => <AirlineRouteModel>[]);

        // Act
        final result = await repository.getAirlineRoutes();

        // Assert
        expect(result, isEmpty);
      });
    });

    group('getAirlineRouteById', () {
      test('should return entity from datasource', () async {
        // Arrange
        const route = AirlineRouteModel(
          id: 'ar1',
          airlineId: 'a1',
          routeId: 'r1',
        );
        when(
          () => mockDataSource.getAirlineRouteById(any()),
        ).thenAnswer((_) async => route);

        // Act
        final result = await repository.getAirlineRouteById('ar1');

        // Assert
        expect(result, isA<AirlineRouteEntity>());
        expect(result?.id, equals('ar1'));
        verify(() => mockDataSource.getAirlineRouteById('ar1')).called(1);
      });

      test('should return null when not found', () async {
        // Arrange
        when(
          () => mockDataSource.getAirlineRouteById(any()),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.getAirlineRouteById('notfound');

        // Assert
        expect(result, isNull);
      });
    });
  });
}
