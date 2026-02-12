import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_model.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';
import 'package:flight_hours_app/features/airline/domain/repositories/airline_repository.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/get_airline_by_id_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/activate_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/deactivate_airline_use_case.dart';

class MockAirlineRepository extends Mock implements AirlineRepository {}

void main() {
  late MockAirlineRepository mockRepository;

  setUp(() {
    mockRepository = MockAirlineRepository();
  });

  group('GetAirlineByIdUseCase', () {
    late GetAirlineByIdUseCase useCase;

    setUp(() {
      useCase = GetAirlineByIdUseCase(repository: mockRepository);
    });

    test('should return Right with airline from repository', () async {
      const airline = AirlineModel(id: 'a1', name: 'Avianca', code: 'AV');
      when(
        () => mockRepository.getAirlineById(any()),
      ).thenAnswer((_) async => const Right(airline));

      final result = await useCase.call('a1');

      expect(result, isA<Right>());
      result.fold((failure) => fail('Expected Right'), (data) {
        expect(data, isA<AirlineEntity>());
        expect(data.name, equals('Avianca'));
      });
      verify(() => mockRepository.getAirlineById('a1')).called(1);
    });

    test('should return Left when not found', () async {
      when(() => mockRepository.getAirlineById(any())).thenAnswer(
        (_) async =>
            const Left(Failure(message: 'Airline not found', statusCode: 404)),
      );

      final result = await useCase.call('notfound');

      expect(result, isA<Left>());
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
        code: 'ACTIVATED',
        message: 'Airline activated',
      );
      when(
        () => mockRepository.activateAirline(any()),
      ).thenAnswer((_) async => Right(response));

      final result = await useCase.call('a1');

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.success, isTrue),
      );
      verify(() => mockRepository.activateAirline('a1')).called(1);
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
        code: 'DEACTIVATED',
        message: 'Airline deactivated',
      );
      when(
        () => mockRepository.deactivateAirline(any()),
      ).thenAnswer((_) async => Right(response));

      final result = await useCase.call('a1');

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.success, isTrue),
      );
      verify(() => mockRepository.deactivateAirline('a1')).called(1);
    });
  });
}
