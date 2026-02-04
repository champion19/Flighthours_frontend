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

    test('should return list from repository', () async {
      // Arrange
      final routes = <AirlineRouteEntity>[
        const AirlineRouteEntity(id: 'ar1', routeId: 'r1', airlineId: 'a1'),
        const AirlineRouteEntity(id: 'ar2', routeId: 'r2', airlineId: 'a1'),
      ];
      when(
        () => mockRepository.getAirlineRoutes(),
      ).thenAnswer((_) async => routes);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result.length, equals(2));
      verify(() => mockRepository.getAirlineRoutes()).called(1);
    });

    test('should return empty list when no routes exist', () async {
      // Arrange
      when(() => mockRepository.getAirlineRoutes()).thenAnswer((_) async => []);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getAirlineRoutes()).called(1);
    });
  });

  group('GetAirlineRouteByIdUseCase', () {
    late GetAirlineRouteByIdUseCase useCase;

    setUp(() {
      useCase = GetAirlineRouteByIdUseCase(repository: mockRepository);
    });

    test('should return route from repository', () async {
      // Arrange
      const route = AirlineRouteEntity(
        id: 'ar1',
        routeId: 'r1',
        airlineId: 'a1',
      );
      when(
        () => mockRepository.getAirlineRouteById(any()),
      ).thenAnswer((_) async => route);

      // Act
      final result = await useCase.call('ar1');

      // Assert
      expect(result?.id, equals('ar1'));
      verify(() => mockRepository.getAirlineRouteById('ar1')).called(1);
    });

    test('should return null when not found', () async {
      // Arrange
      when(
        () => mockRepository.getAirlineRouteById(any()),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase.call('notfound');

      // Assert
      expect(result, isNull);
      verify(() => mockRepository.getAirlineRouteById('notfound')).called(1);
    });
  });
}
