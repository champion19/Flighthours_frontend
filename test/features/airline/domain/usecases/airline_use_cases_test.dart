import 'package:dartz/dartz.dart';
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

    test('should return Right with list of airlines from repository', () async {
      final airlines = [
        const AirlineEntity(id: '1', name: 'Avianca'),
        const AirlineEntity(id: '2', name: 'LATAM'),
      ];
      when(
        () => mockRepository.getAirlines(),
      ).thenAnswer((_) async => Right(airlines));

      final result = await useCase.call();

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, equals(airlines)),
      );
      verify(() => mockRepository.getAirlines()).called(1);
    });

    test('should return Right with empty list when no airlines', () async {
      when(
        () => mockRepository.getAirlines(),
      ).thenAnswer((_) async => const Right([]));

      final result = await useCase.call();

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, isEmpty),
      );
    });
  });

  group('GetAirlineByIdUseCase', () {
    late GetAirlineByIdUseCase useCase;

    setUp(() {
      useCase = GetAirlineByIdUseCase(repository: mockRepository);
    });

    test('should return Right with airline by id from repository', () async {
      const airline = AirlineEntity(id: 'air123', name: 'Copa');
      when(
        () => mockRepository.getAirlineById('air123'),
      ).thenAnswer((_) async => const Right(airline));

      final result = await useCase.call('air123');

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, equals(airline)),
      );
      verify(() => mockRepository.getAirlineById('air123')).called(1);
    });
  });

  group('ActivateAirlineUseCase', () {
    late ActivateAirlineUseCase useCase;

    setUp(() {
      useCase = ActivateAirlineUseCase(repository: mockRepository);
    });

    test('should return Right with response on success', () async {
      final response = AirlineStatusResponseModel(
        success: true,
        code: 'OK',
        message: 'Airline activated',
      );
      when(
        () => mockRepository.activateAirline('air123'),
      ).thenAnswer((_) async => Right(response));

      final result = await useCase.call('air123');

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.success, isTrue),
      );
      verify(() => mockRepository.activateAirline('air123')).called(1);
    });
  });

  group('DeactivateAirlineUseCase', () {
    late DeactivateAirlineUseCase useCase;

    setUp(() {
      useCase = DeactivateAirlineUseCase(repository: mockRepository);
    });

    test('should return Right with response on success', () async {
      final response = AirlineStatusResponseModel(
        success: true,
        code: 'OK',
        message: 'Airline deactivated',
      );
      when(
        () => mockRepository.deactivateAirline('air123'),
      ).thenAnswer((_) async => Right(response));

      final result = await useCase.call('air123');

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.success, isTrue),
      );
      verify(() => mockRepository.deactivateAirline('air123')).called(1);
    });
  });
}
