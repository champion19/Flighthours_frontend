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

    test('should return list from repository', () async {
      // Arrange
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
      when(() => mockRepository.getRoutes()).thenAnswer((_) async => routes);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result.length, equals(2));
      verify(() => mockRepository.getRoutes()).called(1);
    });

    test('should return empty list when no routes', () async {
      // Arrange
      when(
        () => mockRepository.getRoutes(),
      ).thenAnswer((_) async => <RouteEntity>[]);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isEmpty);
    });
  });

  group('GetRouteByIdUseCase', () {
    late GetRouteByIdUseCase useCase;

    setUp(() {
      useCase = GetRouteByIdUseCase(repository: mockRepository);
    });

    test('should return route from repository', () async {
      // Arrange
      const route = RouteModel(
        id: 'r1',
        originAirportId: 'ap1',
        destinationAirportId: 'ap2',
      );
      when(
        () => mockRepository.getRouteById(any()),
      ).thenAnswer((_) async => route);

      // Act
      final result = await useCase.call('r1');

      // Assert
      expect(result?.originAirportId, equals('ap1'));
      verify(() => mockRepository.getRouteById('r1')).called(1);
    });

    test('should return null when not found', () async {
      // Arrange
      when(
        () => mockRepository.getRouteById(any()),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase.call('notfound');

      // Assert
      expect(result, isNull);
    });
  });
}
