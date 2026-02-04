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
      // Arrange
      when(
        () => mockRepository.getRoutes(),
      ).thenAnswer((_) async => testRoutes);

      // Act
      final result = await useCase.call();

      // Assert
      verify(() => mockRepository.getRoutes()).called(1);
      expect(result, equals(testRoutes));
    });

    test('should return list of routes on success', () async {
      // Arrange
      when(
        () => mockRepository.getRoutes(),
      ).thenAnswer((_) async => testRoutes);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result.length, equals(2));
      expect(result[0].originAirportCode, equals('BOG'));
      expect(result[1].routeType, equals('Internacional'));
    });

    test('should return empty list when no routes', () async {
      // Arrange
      when(() => mockRepository.getRoutes()).thenAnswer((_) async => []);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isEmpty);
    });

    test('should propagate exception when repository throws', () async {
      // Arrange
      when(
        () => mockRepository.getRoutes(),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => useCase.call(), throwsA(isA<Exception>()));
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
      originCountry: 'Colombia',
      destinationCountry: 'Colombia',
      routeType: 'Nacional',
      estimatedFlightTime: '00:45:00',
    );

    test('should call getRouteById on repository with correct ID', () async {
      // Arrange
      when(
        () => mockRepository.getRouteById('route123'),
      ).thenAnswer((_) async => testRoute);

      // Act
      final result = await useCase.call('route123');

      // Assert
      verify(() => mockRepository.getRouteById('route123')).called(1);
      expect(result, equals(testRoute));
    });

    test('should return route entity on success', () async {
      // Arrange
      when(
        () => mockRepository.getRouteById('route123'),
      ).thenAnswer((_) async => testRoute);

      // Act
      final result = await useCase.call('route123');

      // Assert
      expect(result, isNotNull);
      expect(result!.id, equals('route123'));
      expect(result.originAirportCode, equals('BOG'));
    });

    test('should return null when route not found', () async {
      // Arrange
      when(
        () => mockRepository.getRouteById('nonexistent'),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase.call('nonexistent');

      // Assert
      expect(result, isNull);
    });

    test('should propagate exception when repository throws', () async {
      // Arrange
      when(
        () => mockRepository.getRouteById(any()),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => useCase.call('route123'), throwsA(isA<Exception>()));
    });
  });
}
