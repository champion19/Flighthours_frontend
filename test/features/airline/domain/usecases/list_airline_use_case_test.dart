import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
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
    test('should return Right with list of airlines from repository', () async {
      final airlines = <AirlineEntity>[
        const AirlineModel(id: 'a1', name: 'Avianca', code: 'AV'),
        const AirlineModel(id: 'a2', name: 'Latam', code: 'LA'),
      ];
      when(
        () => mockRepository.getAirlines(),
      ).thenAnswer((_) async => Right(airlines));

      final result = await useCase.call();

      expect(result, isA<Right>());
      result.fold((failure) => fail('Expected Right'), (data) {
        expect(data, isA<List<AirlineEntity>>());
        expect(data.length, equals(2));
      });
      verify(() => mockRepository.getAirlines()).called(1);
    });

    test('should return Right with empty list when no airlines', () async {
      when(
        () => mockRepository.getAirlines(),
      ).thenAnswer((_) async => const Right(<AirlineEntity>[]));

      final result = await useCase.call();

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, isEmpty),
      );
    });

    test('should return Left when repository fails', () async {
      when(() => mockRepository.getAirlines()).thenAnswer(
        (_) async => const Left(Failure(message: 'Failed to load airlines')),
      );

      final result = await useCase.call();

      expect(result, isA<Left>());
    });
  });
}
