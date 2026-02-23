import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/update_logbook_detail_use_case.dart';
import 'package:flight_hours_app/features/tail_number/domain/entities/tail_number_entity.dart';
import 'package:flight_hours_app/features/tail_number/domain/repositories/tail_number_repository.dart';
import 'package:flight_hours_app/features/tail_number/domain/usecases/list_tail_numbers_use_case.dart';
import 'package:flight_hours_app/features/tail_number/domain/usecases/get_tail_number_by_plate_use_case.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/repositories/aircraft_model_repository.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/usecases/list_aircraft_model_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/create_daily_logbook_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/activate_daily_logbook_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/deactivate_daily_logbook_use_case.dart';

class MockLogbookRepository extends Mock implements LogbookRepository {}

class MockTailNumberRepository extends Mock implements TailNumberRepository {}

class MockAircraftModelRepository extends Mock
    implements AircraftModelRepository {}

void main() {
  group('UpdateLogbookDetailUseCase', () {
    late MockLogbookRepository mockRepo;
    late UpdateLogbookDetailUseCase useCase;

    setUp(() {
      mockRepo = MockLogbookRepository();
      useCase = UpdateLogbookDetailUseCase(repository: mockRepo);
    });

    test(
      'should call repository.updateLogbookDetail and return result',
      () async {
        when(
          () => mockRepo.updateLogbookDetail(
            id: any(named: 'id'),
            flightRealDate: any(named: 'flightRealDate'),
            flightNumber: any(named: 'flightNumber'),
            airlineRouteId: any(named: 'airlineRouteId'),
            tailNumberId: any(named: 'tailNumberId'),
          ),
        ).thenAnswer((_) async => const Left(Failure(message: 'err')));

        final result = await useCase(
          id: '1',
          flightRealDate: '2024-01-01',
          flightNumber: 'AV1',
          airlineRouteId: 'r1',
          tailNumberId: 't1',
        );
        expect(result, isA<Left>());
      },
    );
  });

  group('ListTailNumbersUseCase', () {
    late MockTailNumberRepository mockRepo;
    late ListTailNumbersUseCase useCase;

    setUp(() {
      mockRepo = MockTailNumberRepository();
      useCase = ListTailNumbersUseCase(mockRepo);
    });

    test('should call repository.listTailNumbers and return result', () async {
      when(
        () => mockRepo.listTailNumbers(),
      ).thenAnswer((_) async => const Right(<TailNumberEntity>[]));
      final result = await useCase();
      expect(result, isA<Right>());
    });
  });

  group('GetTailNumberByPlateUseCase', () {
    late MockTailNumberRepository mockRepo;
    late GetTailNumberByPlateUseCase useCase;

    setUp(() {
      mockRepo = MockTailNumberRepository();
      useCase = GetTailNumberByPlateUseCase(mockRepo);
    });

    test(
      'should call repository.getTailNumberByPlate and return result',
      () async {
        when(() => mockRepo.getTailNumberByPlate(any())).thenAnswer(
          (_) async =>
              const Right(TailNumberEntity(id: '1', tailNumber: 'HK-1333')),
        );
        final result = await useCase('HK-1333');
        expect(result, isA<Right>());
      },
    );
  });

  group('ListAircraftModelUseCase', () {
    late MockAircraftModelRepository mockRepo;
    late ListAircraftModelUseCase useCase;

    setUp(() {
      mockRepo = MockAircraftModelRepository();
      useCase = ListAircraftModelUseCase(repository: mockRepo);
    });

    test(
      'should call repository.getAircraftModels and return result',
      () async {
        when(
          () => mockRepo.getAircraftModels(),
        ).thenAnswer((_) async => const Right(<AircraftModelEntity>[]));
        final result = await useCase();
        expect(result, isA<Right>());
      },
    );
  });

  group('CreateDailyLogbookUseCase', () {
    late MockLogbookRepository mockRepo;
    late CreateDailyLogbookUseCase useCase;

    setUp(() {
      mockRepo = MockLogbookRepository();
      useCase = CreateDailyLogbookUseCase(repository: mockRepo);
    });

    test(
      'should call repository.createDailyLogbook and return result',
      () async {
        when(
          () => mockRepo.createDailyLogbook(
            logDate: any(named: 'logDate'),
            bookPage: any(named: 'bookPage'),
          ),
        ).thenAnswer((_) async => const Left(Failure(message: 'err')));
        final result = await useCase(logDate: DateTime(2024));
        expect(result, isA<Left>());
      },
    );
  });

  group('ActivateDailyLogbookUseCase', () {
    late MockLogbookRepository mockRepo;
    late ActivateDailyLogbookUseCase useCase;

    setUp(() {
      mockRepo = MockLogbookRepository();
      useCase = ActivateDailyLogbookUseCase(repository: mockRepo);
    });

    test(
      'should call repository.activateDailyLogbook and return result',
      () async {
        when(
          () => mockRepo.activateDailyLogbook(any()),
        ).thenAnswer((_) async => const Right(true));
        final result = await useCase('id1');
        expect(result, isA<Right>());
      },
    );
  });

  group('DeactivateDailyLogbookUseCase', () {
    late MockLogbookRepository mockRepo;
    late DeactivateDailyLogbookUseCase useCase;

    setUp(() {
      mockRepo = MockLogbookRepository();
      useCase = DeactivateDailyLogbookUseCase(repository: mockRepo);
    });

    test(
      'should call repository.deactivateDailyLogbook and return result',
      () async {
        when(
          () => mockRepo.deactivateDailyLogbook(any()),
        ).thenAnswer((_) async => const Right(true));
        final result = await useCase('id1');
        expect(result, isA<Right>());
      },
    );
  });
}
