import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_model.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';
import 'package:flight_hours_app/features/airline/domain/repositories/airline_repository.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/list_airline_use_case.dart';

class MockAirlineRepository extends Mock implements AirlineRepository {}

void main() {
  late MockAirlineRepository mockRepository;
  late ListAirlineUseCase useCase;

  setUp(() {
    mockRepository = MockAirlineRepository();
    useCase = ListAirlineUseCase(repository: mockRepository);
  });

  group('ListAirlineUseCase', () {
    test('should return list of airlines from repository', () async {
      // Arrange
      final airlines = <AirlineEntity>[
        const AirlineModel(id: 'a1', name: 'Avianca', code: 'AV'),
        const AirlineModel(id: 'a2', name: 'Latam', code: 'LA'),
      ];
      when(
        () => mockRepository.getAirlines(),
      ).thenAnswer((_) async => airlines);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<List<AirlineEntity>>());
      expect(result.length, equals(2));
      verify(() => mockRepository.getAirlines()).called(1);
    });

    test('should return empty list when no airlines', () async {
      // Arrange
      when(
        () => mockRepository.getAirlines(),
      ).thenAnswer((_) async => <AirlineEntity>[]);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isEmpty);
    });

    test('should propagate exception from repository', () async {
      // Arrange
      when(
        () => mockRepository.getAirlines(),
      ).thenThrow(Exception('Failed to load airlines'));

      // Act & Assert
      expect(() => useCase.call(), throwsA(isA<Exception>()));
    });
  });
}
