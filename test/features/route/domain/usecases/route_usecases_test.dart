import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/route/data/models/route_model.dart';
import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';
import 'package:flight_hours_app/features/route/domain/repositories/route_repository.dart';
import 'package:flight_hours_app/features/route/domain/usecases/list_routes_use_case.dart';
import 'package:flight_hours_app/features/route/domain/usecases/get_route_by_id_use_case.dart';

class MockRouteRepository extends Mock implements RouteRepository {}

void main() {
  late MockRouteRepository mockRepository;

  setUp(() {
    mockRepository = MockRouteRepository();
  });

  group('ListRoutesUseCase', () {
    late ListRoutesUseCase useCase;

    setUp(() {
      useCase = ListRoutesUseCase(repository: mockRepository);
    });

    test('should return Right with list from repository', () async {
      final routes = <RouteEntity>[
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
      when(
        () => mockRepository.getRoutes(),
      ).thenAnswer((_) async => Right(routes));

      final result = await useCase.call();

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.length, equals(2)),
      );
      verify(() => mockRepository.getRoutes()).called(1);
    });

    test('should return Right with empty list when no routes', () async {
      when(
        () => mockRepository.getRoutes(),
      ).thenAnswer((_) async => const Right(<RouteEntity>[]));

      final result = await useCase.call();

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, isEmpty),
      );
    });
  });

  group('GetRouteByIdUseCase', () {
    late GetRouteByIdUseCase useCase;

    setUp(() {
      useCase = GetRouteByIdUseCase(repository: mockRepository);
    });

    test('should return Right with route from repository', () async {
      const route = RouteModel(
        id: 'r1',
        originAirportId: 'ap1',
        destinationAirportId: 'ap2',
      );
      when(
        () => mockRepository.getRouteById(any()),
      ).thenAnswer((_) async => const Right(route));

      final result = await useCase.call('r1');

      result.fold(
        (failure) => fail('Expected Right'),
        (entity) => expect(entity.originAirportId, equals('ap1')),
      );
      verify(() => mockRepository.getRouteById('r1')).called(1);
    });

    test('should return Left when not found', () async {
      when(() => mockRepository.getRouteById(any())).thenAnswer(
        (_) async =>
            const Left(Failure(message: 'Route not found', statusCode: 404)),
      );

      final result = await useCase.call('notfound');

      expect(result, isA<Left>());
    });
  });
}
