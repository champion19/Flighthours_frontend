import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';
import 'package:flight_hours_app/features/airline/domain/repositories/airline_repository.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/list_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/get_airline_by_id_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/activate_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/deactivate_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';

class MockAirlineRepository extends Mock implements AirlineRepository {}

void main() {
  late MockAirlineRepository mockRepository;

  setUp(() {
    mockRepository = MockAirlineRepository();
  });

  group('ListAirlineUseCase', () {
    late ListAirlineUseCase useCase;

    setUp(() {
      useCase = ListAirlineUseCase(repository: mockRepository);
    });

    test('should return list of airlines from repository', () async {
      // Arrange
      final airlines = [
        const AirlineEntity(id: '1', name: 'Avianca'),
        const AirlineEntity(id: '2', name: 'LATAM'),
      ];
      when(
        () => mockRepository.getAirlines(),
      ).thenAnswer((_) async => airlines);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(airlines));
      verify(() => mockRepository.getAirlines()).called(1);
    });

    test('should return empty list when no airlines', () async {
      // Arrange
      when(() => mockRepository.getAirlines()).thenAnswer((_) async => []);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isEmpty);
    });
  });

  group('GetAirlineByIdUseCase', () {
    late GetAirlineByIdUseCase useCase;

    setUp(() {
      useCase = GetAirlineByIdUseCase(repository: mockRepository);
    });

    test('should return airline by id from repository', () async {
      // Arrange
      const airline = AirlineEntity(id: 'air123', name: 'Copa');
      when(
        () => mockRepository.getAirlineById('air123'),
      ).thenAnswer((_) async => airline);

      // Act
      final result = await useCase.call('air123');

      // Assert
      expect(result, equals(airline));
      verify(() => mockRepository.getAirlineById('air123')).called(1);
    });
  });

  group('ActivateAirlineUseCase', () {
    late ActivateAirlineUseCase useCase;

    setUp(() {
      useCase = ActivateAirlineUseCase(repository: mockRepository);
    });

    test('should call repository activate and return response', () async {
      // Arrange
      final response = AirlineStatusResponseModel(
        success: true,
        code: 'OK',
        message: 'Airline activated',
      );
      when(
        () => mockRepository.activateAirline('air123'),
      ).thenAnswer((_) async => response);

      // Act
      final result = await useCase.call('air123');

      // Assert
      expect(result.success, isTrue);
      verify(() => mockRepository.activateAirline('air123')).called(1);
    });
  });

  group('DeactivateAirlineUseCase', () {
    late DeactivateAirlineUseCase useCase;

    setUp(() {
      useCase = DeactivateAirlineUseCase(repository: mockRepository);
    });

    test('should call repository deactivate and return response', () async {
      // Arrange
      final response = AirlineStatusResponseModel(
        success: true,
        code: 'OK',
        message: 'Airline deactivated',
      );
      when(
        () => mockRepository.deactivateAirline('air123'),
      ).thenAnswer((_) async => response);

      // Act
      final result = await useCase.call('air123');

      // Assert
      expect(result.success, isTrue);
      verify(() => mockRepository.deactivateAirline('air123')).called(1);
    });
  });
}
