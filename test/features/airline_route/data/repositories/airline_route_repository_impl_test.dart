import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
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
      test('should return Right with list from datasource', () async {
        final routes = <AirlineRouteModel>[
          const AirlineRouteModel(id: 'ar1', airlineId: 'a1', routeId: 'r1'),
          const AirlineRouteModel(id: 'ar2', airlineId: 'a1', routeId: 'r2'),
        ];
        when(
          () => mockDataSource.getAirlineRoutes(),
        ).thenAnswer((_) async => routes);

        final result = await repository.getAirlineRoutes();

        expect(result, isA<Right>());
        result.fold((failure) => fail('Expected Right'), (data) {
          expect(data, isA<List<AirlineRouteEntity>>());
          expect(data.length, equals(2));
        });
        verify(() => mockDataSource.getAirlineRoutes()).called(1);
      });

      test('should return Right with empty list when no routes', () async {
        when(
          () => mockDataSource.getAirlineRoutes(),
        ).thenAnswer((_) async => <AirlineRouteModel>[]);

        final result = await repository.getAirlineRoutes();

        result.fold(
          (failure) => fail('Expected Right'),
          (data) => expect(data, isEmpty),
        );
      });

      test('should return Left on exception', () async {
        when(
          () => mockDataSource.getAirlineRoutes(),
        ).thenThrow(Exception('Network error'));

        final result = await repository.getAirlineRoutes();

        expect(result, isA<Left>());
      });
    });

    group('getAirlineRouteById', () {
      test('should return Right with entity from datasource', () async {
        const route = AirlineRouteModel(
          id: 'ar1',
          airlineId: 'a1',
          routeId: 'r1',
        );
        when(
          () => mockDataSource.getAirlineRouteById(any()),
        ).thenAnswer((_) async => route);

        final result = await repository.getAirlineRouteById('ar1');

        expect(result, isA<Right>());
        result.fold((failure) => fail('Expected Right'), (data) {
          expect(data, isA<AirlineRouteEntity>());
          expect(data.id, equals('ar1'));
        });
        verify(() => mockDataSource.getAirlineRouteById('ar1')).called(1);
      });

      test('should return Left when not found', () async {
        when(
          () => mockDataSource.getAirlineRouteById(any()),
        ).thenAnswer((_) async => null);

        final result = await repository.getAirlineRouteById('notfound');

        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure.statusCode, 404),
          (data) => fail('Expected Left'),
        );
      });
    });
  });
}
