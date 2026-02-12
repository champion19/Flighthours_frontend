import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
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

    test('should return Right with list from repository', () async {
      final airports = <AirportEntity>[
        const AirportModel(id: 'ap1', name: 'El Dorado', iataCode: 'BOG'),
        const AirportModel(id: 'ap2', name: 'JMC', iataCode: 'MDE'),
      ];
      when(
        () => mockRepository.getAirports(),
      ).thenAnswer((_) async => Right(airports));

      final result = await useCase.call();

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.length, equals(2)),
      );
      verify(() => mockRepository.getAirports()).called(1);
    });
  });

  group('GetAirportByIdUseCase', () {
    late GetAirportByIdUseCase useCase;

    setUp(() {
      useCase = GetAirportByIdUseCase(repository: mockRepository);
    });

    test('should return Right with airport from repository', () async {
      const airport = AirportModel(
        id: 'ap1',
        name: 'El Dorado',
        iataCode: 'BOG',
      );
      when(
        () => mockRepository.getAirportById(any()),
      ).thenAnswer((_) async => const Right(airport));

      final result = await useCase.call('ap1');

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.name, equals('El Dorado')),
      );
      verify(() => mockRepository.getAirportById('ap1')).called(1);
    });

    test('should return Left when not found', () async {
      when(() => mockRepository.getAirportById(any())).thenAnswer(
        (_) async =>
            const Left(Failure(message: 'Airport not found', statusCode: 404)),
      );

      final result = await useCase.call('notfound');

      expect(result, isA<Left>());
    });
  });

  group('ActivateAirportUseCase', () {
    late ActivateAirportUseCase useCase;

    setUp(() {
      useCase = ActivateAirportUseCase(repository: mockRepository);
    });

    test('should return Right with response on success', () async {
      final response = AirportStatusResponseModel(
        success: true,
        code: 'ACTIVATED',
        message: 'Airport activated',
      );
      when(
        () => mockRepository.activateAirport(any()),
      ).thenAnswer((_) async => Right(response));

      final result = await useCase.call('ap1');

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.success, isTrue),
      );
      verify(() => mockRepository.activateAirport('ap1')).called(1);
    });
  });

  group('DeactivateAirportUseCase', () {
    late DeactivateAirportUseCase useCase;

    setUp(() {
      useCase = DeactivateAirportUseCase(repository: mockRepository);
    });

    test('should return Right with response on success', () async {
      final response = AirportStatusResponseModel(
        success: true,
        code: 'DEACTIVATED',
        message: 'Airport deactivated',
      );
      when(
        () => mockRepository.deactivateAirport(any()),
      ).thenAnswer((_) async => Right(response));

      final result = await useCase.call('ap1');

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.success, isTrue),
      );
      verify(() => mockRepository.deactivateAirport('ap1')).called(1);
    });
  });
}
