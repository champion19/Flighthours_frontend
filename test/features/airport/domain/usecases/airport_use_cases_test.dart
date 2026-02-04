import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';
import 'package:flight_hours_app/features/airport/domain/repositories/airport_repository.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/list_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/get_airport_by_id_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/activate_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/deactivate_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';

class MockAirportRepository extends Mock implements AirportRepository {}

void main() {
  late MockAirportRepository mockRepository;

  setUp(() {
    mockRepository = MockAirportRepository();
  });

  group('ListAirportUseCase', () {
    late ListAirportUseCase useCase;

    setUp(() {
      useCase = ListAirportUseCase(repository: mockRepository);
    });

    test('should return list of airports from repository', () async {
      // Arrange
      final airports = [
        const AirportEntity(id: '1', name: 'El Dorado'),
        const AirportEntity(id: '2', name: 'JFK'),
      ];
      when(
        () => mockRepository.getAirports(),
      ).thenAnswer((_) async => airports);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(airports));
      verify(() => mockRepository.getAirports()).called(1);
    });

    test('should return empty list when no airports', () async {
      // Arrange
      when(() => mockRepository.getAirports()).thenAnswer((_) async => []);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isEmpty);
    });
  });

  group('GetAirportByIdUseCase', () {
    late GetAirportByIdUseCase useCase;

    setUp(() {
      useCase = GetAirportByIdUseCase(repository: mockRepository);
    });

    test('should return airport by id from repository', () async {
      // Arrange
      const airport = AirportEntity(id: 'air123', name: 'LAX');
      when(
        () => mockRepository.getAirportById('air123'),
      ).thenAnswer((_) async => airport);

      // Act
      final result = await useCase.call('air123');

      // Assert
      expect(result, equals(airport));
      verify(() => mockRepository.getAirportById('air123')).called(1);
    });
  });

  group('ActivateAirportUseCase', () {
    late ActivateAirportUseCase useCase;

    setUp(() {
      useCase = ActivateAirportUseCase(repository: mockRepository);
    });

    test('should call repository activate and return response', () async {
      // Arrange
      final response = AirportStatusResponseModel(
        success: true,
        code: 'OK',
        message: 'Airport activated',
      );
      when(
        () => mockRepository.activateAirport('air123'),
      ).thenAnswer((_) async => response);

      // Act
      final result = await useCase.call('air123');

      // Assert
      expect(result.success, isTrue);
      verify(() => mockRepository.activateAirport('air123')).called(1);
    });
  });

  group('DeactivateAirportUseCase', () {
    late DeactivateAirportUseCase useCase;

    setUp(() {
      useCase = DeactivateAirportUseCase(repository: mockRepository);
    });

    test('should call repository deactivate and return response', () async {
      // Arrange
      final response = AirportStatusResponseModel(
        success: true,
        code: 'OK',
        message: 'Airport deactivated',
      );
      when(
        () => mockRepository.deactivateAirport('air123'),
      ).thenAnswer((_) async => response);

      // Act
      final result = await useCase.call('air123');

      // Assert
      expect(result.success, isTrue);
      verify(() => mockRepository.deactivateAirport('air123')).called(1);
    });
  });
}
