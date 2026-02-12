import 'package:dartz/dartz.dart';
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
      test('should return Right with list from datasource', () async {
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

        final result = await repository.getRoutes();

        expect(result, isA<Right>());
        result.fold((failure) => fail('Expected Right'), (data) {
          expect(data, isA<List<RouteEntity>>());
          expect(data.length, equals(2));
        });
        verify(() => mockDataSource.getRoutes()).called(1);
      });

      test('should return Right with empty list when no routes', () async {
        when(
          () => mockDataSource.getRoutes(),
        ).thenAnswer((_) async => <RouteModel>[]);

        final result = await repository.getRoutes();

        result.fold(
          (failure) => fail('Expected Right'),
          (data) => expect(data, isEmpty),
        );
      });

      test('should return Left on exception', () async {
        when(
          () => mockDataSource.getRoutes(),
        ).thenThrow(Exception('Network error'));

        final result = await repository.getRoutes();

        expect(result, isA<Left>());
      });
    });

    group('getRouteById', () {
      test('should return Right with entity from datasource', () async {
        const route = RouteModel(
          id: 'r1',
          originAirportId: 'ap1',
          destinationAirportId: 'ap2',
        );
        when(
          () => mockDataSource.getRouteById(any()),
        ).thenAnswer((_) async => route);

        final result = await repository.getRouteById('r1');

        expect(result, isA<Right>());
        result.fold(
          (failure) => fail('Expected Right'),
          (entity) => expect(entity.originAirportId, equals('ap1')),
        );
        verify(() => mockDataSource.getRouteById('r1')).called(1);
      });

      test('should return Left when not found', () async {
        when(
          () => mockDataSource.getRouteById(any()),
        ).thenAnswer((_) async => null);

        final result = await repository.getRouteById('notfound');

        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure.statusCode, 404),
          (data) => fail('Expected Left'),
        );
      });

      test('should return Left on exception', () async {
        when(
          () => mockDataSource.getRouteById(any()),
        ).thenThrow(Exception('Error'));

        final result = await repository.getRouteById('r1');

        expect(result, isA<Left>());
      });
    });
  });
}
