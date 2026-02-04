import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/route/data/datasources/route_remote_data_source.dart';
import 'package:flight_hours_app/features/route/data/models/route_model.dart';
import 'package:flight_hours_app/features/route/data/repositories/route_repository_impl.dart';
import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';

class MockRouteRemoteDataSource extends Mock implements RouteRemoteDataSource {}

void main() {
  late MockRouteRemoteDataSource mockDataSource;
  late RouteRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockRouteRemoteDataSource();
    repository = RouteRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('RouteRepositoryImpl', () {
    group('getRoutes', () {
      test('should return list from datasource', () async {
        // Arrange
        final routes = <RouteModel>[
          const RouteModel(
            id: 'r1',
            originAirportId: 'ap1',
            destinationAirportId: 'ap2',
          ),
          const RouteModel(
            id: 'r2',
            originAirportId: 'ap2',
            destinationAirportId: 'ap1',
          ),
        ];
        when(() => mockDataSource.getRoutes()).thenAnswer((_) async => routes);

        // Act
        final result = await repository.getRoutes();

        // Assert
        expect(result, isA<List<RouteEntity>>());
        expect(result.length, equals(2));
        verify(() => mockDataSource.getRoutes()).called(1);
      });

      test('should return empty list when no routes', () async {
        // Arrange
        when(
          () => mockDataSource.getRoutes(),
        ).thenAnswer((_) async => <RouteModel>[]);

        // Act
        final result = await repository.getRoutes();

        // Assert
        expect(result, isEmpty);
      });
    });

    group('getRouteById', () {
      test('should return entity from datasource', () async {
        // Arrange
        const route = RouteModel(
          id: 'r1',
          originAirportId: 'ap1',
          destinationAirportId: 'ap2',
        );
        when(
          () => mockDataSource.getRouteById(any()),
        ).thenAnswer((_) async => route);

        // Act
        final result = await repository.getRouteById('r1');

        // Assert
        expect(result, isA<RouteEntity>());
        expect(result?.originAirportId, equals('ap1'));
        verify(() => mockDataSource.getRouteById('r1')).called(1);
      });

      test('should return null when not found', () async {
        // Arrange
        when(
          () => mockDataSource.getRouteById(any()),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.getRouteById('notfound');

        // Assert
        expect(result, isNull);
      });
    });
  });
}
