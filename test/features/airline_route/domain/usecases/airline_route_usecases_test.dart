import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';
import 'package:flight_hours_app/features/airline_route/domain/repositories/airline_route_repository.dart';
import 'package:flight_hours_app/features/airline_route/domain/usecases/list_airline_routes_use_case.dart';
import 'package:flight_hours_app/features/airline_route/domain/usecases/get_airline_route_by_id_use_case.dart';

class MockAirlineRouteRepository extends Mock
    implements AirlineRouteRepository {}

void main() {
  late MockAirlineRouteRepository mockRepository;

  setUp(() {
    mockRepository = MockAirlineRouteRepository();
  });

  group('ListAirlineRoutesUseCase', () {
    late ListAirlineRoutesUseCase useCase;

    setUp(() {
      useCase = ListAirlineRoutesUseCase(repository: mockRepository);
    });

    test('should return Right with list from repository', () async {
      final routes = <AirlineRouteEntity>[
        const AirlineRouteEntity(id: 'ar1', routeId: 'r1', airlineId: 'a1'),
        const AirlineRouteEntity(id: 'ar2', routeId: 'r2', airlineId: 'a1'),
      ];
      when(
        () => mockRepository.getAirlineRoutes(),
      ).thenAnswer((_) async => Right(routes));

      final result = await useCase.call();

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.length, equals(2)),
      );
      verify(() => mockRepository.getAirlineRoutes()).called(1);
    });

    test('should return Right with empty list when no routes exist', () async {
      when(
        () => mockRepository.getAirlineRoutes(),
      ).thenAnswer((_) async => const Right([]));

      final result = await useCase.call();

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, isEmpty),
      );
      verify(() => mockRepository.getAirlineRoutes()).called(1);
    });
  });

  group('GetAirlineRouteByIdUseCase', () {
    late GetAirlineRouteByIdUseCase useCase;

    setUp(() {
      useCase = GetAirlineRouteByIdUseCase(repository: mockRepository);
    });

    test('should return Right with route from repository', () async {
      const route = AirlineRouteEntity(
        id: 'ar1',
        routeId: 'r1',
        airlineId: 'a1',
      );
      when(
        () => mockRepository.getAirlineRouteById(any()),
      ).thenAnswer((_) async => const Right(route));

      final result = await useCase.call('ar1');

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.id, equals('ar1')),
      );
      verify(() => mockRepository.getAirlineRouteById('ar1')).called(1);
    });

    test('should return Left when not found', () async {
      when(() => mockRepository.getAirlineRouteById(any())).thenAnswer(
        (_) async =>
            const Left(Failure(message: 'Route not found', statusCode: 404)),
      );

      final result = await useCase.call('notfound');

      expect(result, isA<Left>());
      verify(() => mockRepository.getAirlineRouteById('notfound')).called(1);
    });
  });
}
