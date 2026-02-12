import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
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

    test('should return Right with list of airports from repository', () async {
      final airports = [
        const AirportEntity(id: '1', name: 'El Dorado'),
        const AirportEntity(id: '2', name: 'JFK'),
      ];
      when(
        () => mockRepository.getAirports(),
      ).thenAnswer((_) async => Right(airports));

      final result = await useCase.call();

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, equals(airports)),
      );
      verify(() => mockRepository.getAirports()).called(1);
    });

    test('should return Right with empty list when no airports', () async {
      when(
        () => mockRepository.getAirports(),
      ).thenAnswer((_) async => const Right([]));

      final result = await useCase.call();

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, isEmpty),
      );
    });
  });

  group('GetAirportByIdUseCase', () {
    late GetAirportByIdUseCase useCase;

    setUp(() {
      useCase = GetAirportByIdUseCase(repository: mockRepository);
    });

    test('should return Right with airport by id from repository', () async {
      const airport = AirportEntity(id: 'air123', name: 'LAX');
      when(
        () => mockRepository.getAirportById('air123'),
      ).thenAnswer((_) async => const Right(airport));

      final result = await useCase.call('air123');

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, equals(airport)),
      );
      verify(() => mockRepository.getAirportById('air123')).called(1);
    });
  });

  group('ActivateAirportUseCase', () {
    late ActivateAirportUseCase useCase;

    setUp(() {
      useCase = ActivateAirportUseCase(repository: mockRepository);
    });

    test('should return Right with response from repository', () async {
      final response = AirportStatusResponseModel(
        success: true,
        code: 'OK',
        message: 'Airport activated',
      );
      when(
        () => mockRepository.activateAirport('air123'),
      ).thenAnswer((_) async => Right(response));

      final result = await useCase.call('air123');

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.success, isTrue),
      );
      verify(() => mockRepository.activateAirport('air123')).called(1);
    });
  });

  group('DeactivateAirportUseCase', () {
    late DeactivateAirportUseCase useCase;

    setUp(() {
      useCase = DeactivateAirportUseCase(repository: mockRepository);
    });

    test('should return Right with response from repository', () async {
      final response = AirportStatusResponseModel(
        success: true,
        code: 'OK',
        message: 'Airport deactivated',
      );
      when(
        () => mockRepository.deactivateAirport('air123'),
      ).thenAnswer((_) async => Right(response));

      final result = await useCase.call('air123');

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.success, isTrue),
      );
      verify(() => mockRepository.deactivateAirport('air123')).called(1);
    });
  });
}
