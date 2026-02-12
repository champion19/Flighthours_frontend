import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';
import 'package:flight_hours_app/features/route/domain/repositories/route_repository.dart';
import 'package:flight_hours_app/features/route/domain/usecases/list_routes_use_case.dart';
import 'package:flight_hours_app/features/route/domain/usecases/get_route_by_id_use_case.dart';

// Mock class for RouteRepository
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

    const testRoutes = [
      RouteEntity(
        id: 'route1',
        originAirportId: 'airport1',
        destinationAirportId: 'airport2',
        originAirportCode: 'BOG',
        destinationAirportCode: 'MDE',
        routeType: 'Nacional',
      ),
      RouteEntity(
        id: 'route2',
        originAirportId: 'airport1',
        destinationAirportId: 'airport3',
        originAirportCode: 'BOG',
        destinationAirportCode: 'MIA',
        routeType: 'Internacional',
      ),
    ];

    test('should call getRoutes on repository', () async {
      when(
        () => mockRepository.getRoutes(),
      ).thenAnswer((_) async => const Right(testRoutes));

      final result = await useCase.call();

      verify(() => mockRepository.getRoutes()).called(1);
      expect(result, isA<Right>());
    });

    test('should return Right with list of routes on success', () async {
      when(
        () => mockRepository.getRoutes(),
      ).thenAnswer((_) async => const Right(testRoutes));

      final result = await useCase.call();

      result.fold((failure) => fail('Expected Right'), (routes) {
        expect(routes.length, equals(2));
        expect(routes[0].originAirportCode, equals('BOG'));
        expect(routes[1].routeType, equals('Internacional'));
      });
    });

    test('should return Right with empty list when no routes', () async {
      when(
        () => mockRepository.getRoutes(),
      ).thenAnswer((_) async => const Right([]));

      final result = await useCase.call();

      result.fold(
        (failure) => fail('Expected Right'),
        (routes) => expect(routes, isEmpty),
      );
    });

    test('should return Left when repository fails', () async {
      when(
        () => mockRepository.getRoutes(),
      ).thenAnswer((_) async => const Left(Failure(message: 'Network error')));

      final result = await useCase.call();

      expect(result, isA<Left>());
    });
  });

  group('GetRouteByIdUseCase', () {
    late GetRouteByIdUseCase useCase;

    setUp(() {
      useCase = GetRouteByIdUseCase(repository: mockRepository);
    });

    const testRoute = RouteEntity(
      id: 'route123',
      uuid: 'uuid-1234',
      originAirportId: 'airport1',
      destinationAirportId: 'airport2',
      originAirportCode: 'BOG',
      destinationAirportCode: 'MDE',
      routeType: 'Nacional',
      estimatedFlightTime: '00:45:00',
    );

    test('should call getRouteById on repository with correct ID', () async {
      when(
        () => mockRepository.getRouteById('route123'),
      ).thenAnswer((_) async => const Right(testRoute));

      final result = await useCase.call('route123');

      verify(() => mockRepository.getRouteById('route123')).called(1);
      expect(result, isA<Right>());
    });

    test('should return Right with route entity on success', () async {
      when(
        () => mockRepository.getRouteById('route123'),
      ).thenAnswer((_) async => const Right(testRoute));

      final result = await useCase.call('route123');

      result.fold((failure) => fail('Expected Right'), (route) {
        expect(route.id, equals('route123'));
        expect(route.originAirportCode, equals('BOG'));
      });
    });

    test('should return Left when route not found', () async {
      when(() => mockRepository.getRouteById('nonexistent')).thenAnswer(
        (_) async =>
            const Left(Failure(message: 'Route not found', statusCode: 404)),
      );

      final result = await useCase.call('nonexistent');

      expect(result, isA<Left>());
    });

    test('should return Left when repository fails', () async {
      when(
        () => mockRepository.getRouteById(any()),
      ).thenAnswer((_) async => const Left(Failure(message: 'Network error')));

      final result = await useCase.call('route123');

      expect(result, isA<Left>());
    });
  });
}
