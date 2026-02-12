import 'package:dartz/dartz.dart';
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

    test('should return Right with list of airline routes', () async {
      final routes = [
        const AirlineRouteEntity(id: '1', routeId: 'r1', airlineId: 'a1'),
        const AirlineRouteEntity(id: '2', routeId: 'r2', airlineId: 'a1'),
      ];
      when(
        () => mockRepository.getAirlineRoutes(),
      ).thenAnswer((_) async => Right(routes));

      final result = await useCase.call();

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, equals(routes)),
      );
      verify(() => mockRepository.getAirlineRoutes()).called(1);
    });

    test(
      'should return Right with empty list when no airline routes',
      () async {
        when(
          () => mockRepository.getAirlineRoutes(),
        ).thenAnswer((_) async => const Right([]));

        final result = await useCase.call();

        result.fold(
          (failure) => fail('Expected Right'),
          (data) => expect(data, isEmpty),
        );
      },
    );
  });

  group('GetAirlineRouteByIdUseCase', () {
    late GetAirlineRouteByIdUseCase useCase;

    setUp(() {
      useCase = GetAirlineRouteByIdUseCase(repository: mockRepository);
    });

    test('should return Right with airline route by id', () async {
      const route = AirlineRouteEntity(
        id: 'ar123',
        routeId: 'r1',
        airlineId: 'a1',
        routeName: 'BOG → MDE',
      );
      when(
        () => mockRepository.getAirlineRouteById('ar123'),
      ).thenAnswer((_) async => const Right(route));

      final result = await useCase.call('ar123');

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, equals(route)),
      );
      verify(() => mockRepository.getAirlineRouteById('ar123')).called(1);
    });
  });
}
