import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_model.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';
import 'package:flight_hours_app/features/airport/domain/repositories/airport_repository.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/list_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/get_airport_by_id_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/activate_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/deactivate_airport_use_case.dart';

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

    test('should return list from repository', () async {
      // Arrange
      final airports = <AirportEntity>[
        const AirportModel(id: 'ap1', name: 'El Dorado', iataCode: 'BOG'),
        const AirportModel(id: 'ap2', name: 'JMC', iataCode: 'MDE'),
      ];
      when(
        () => mockRepository.getAirports(),
      ).thenAnswer((_) async => airports);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result.length, equals(2));
      verify(() => mockRepository.getAirports()).called(1);
    });
  });

  group('GetAirportByIdUseCase', () {
    late GetAirportByIdUseCase useCase;

    setUp(() {
      useCase = GetAirportByIdUseCase(repository: mockRepository);
    });

    test('should return airport from repository', () async {
      // Arrange
      const airport = AirportModel(
        id: 'ap1',
        name: 'El Dorado',
        iataCode: 'BOG',
      );
      when(
        () => mockRepository.getAirportById(any()),
      ).thenAnswer((_) async => airport);

      // Act
      final result = await useCase.call('ap1');

      // Assert
      expect(result?.name, equals('El Dorado'));
      verify(() => mockRepository.getAirportById('ap1')).called(1);
    });

    test('should return null when not found', () async {
      // Arrange
      when(
        () => mockRepository.getAirportById(any()),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase.call('notfound');

      // Assert
      expect(result, isNull);
    });
  });

  group('ActivateAirportUseCase', () {
    late ActivateAirportUseCase useCase;

    setUp(() {
      useCase = ActivateAirportUseCase(repository: mockRepository);
    });

    test('should activate airport successfully', () async {
      // Arrange
      final response = AirportStatusResponseModel(
        success: true,
        code: 'ACTIVATED',
        message: 'Airport activated',
      );
      when(
        () => mockRepository.activateAirport(any()),
      ).thenAnswer((_) async => response);

      // Act
      final result = await useCase.call('ap1');

      // Assert
      expect(result.success, isTrue);
      verify(() => mockRepository.activateAirport('ap1')).called(1);
    });
  });

  group('DeactivateAirportUseCase', () {
    late DeactivateAirportUseCase useCase;

    setUp(() {
      useCase = DeactivateAirportUseCase(repository: mockRepository);
    });

    test('should deactivate airport successfully', () async {
      // Arrange
      final response = AirportStatusResponseModel(
        success: true,
        code: 'DEACTIVATED',
        message: 'Airport deactivated',
      );
      when(
        () => mockRepository.deactivateAirport(any()),
      ).thenAnswer((_) async => response);

      // Act
      final result = await useCase.call('ap1');

      // Assert
      expect(result.success, isTrue);
      verify(() => mockRepository.deactivateAirport('ap1')).called(1);
    });
  });
}
