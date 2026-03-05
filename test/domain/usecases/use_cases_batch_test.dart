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
import 'package:flight_hours_app/features/aircraft_model/domain/usecases/get_aircraft_model_by_id_use_case.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/usecases/get_aircraft_models_by_family_use_case.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/usecases/activate_aircraft_model_use_case.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/usecases/deactivate_aircraft_model_use_case.dart';
import 'package:flight_hours_app/features/aircraft_model/data/models/aircraft_model_status_response_model.dart';
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

  group('GetAircraftModelByIdUseCase', () {
    late MockAircraftModelRepository mockRepo;
    late GetAircraftModelByIdUseCase useCase;

    setUp(() {
      mockRepo = MockAircraftModelRepository();
      useCase = GetAircraftModelByIdUseCase(repository: mockRepo);
    });

    test('should call repository.getAircraftModelById', () async {
      when(() => mockRepo.getAircraftModelById(any())).thenAnswer(
        (_) async => const Right(AircraftModelEntity(id: '1', name: 'A320')),
      );
      final result = await useCase('1');
      expect(result, isA<Right>());
    });
  });

  group('GetAircraftModelsByFamilyUseCase', () {
    late MockAircraftModelRepository mockRepo;
    late GetAircraftModelsByFamilyUseCase useCase;

    setUp(() {
      mockRepo = MockAircraftModelRepository();
      useCase = GetAircraftModelsByFamilyUseCase(repository: mockRepo);
    });

    test('should call repository.getAircraftModelsByFamily', () async {
      when(
        () => mockRepo.getAircraftModelsByFamily(any()),
      ).thenAnswer((_) async => const Right(<AircraftModelEntity>[]));
      final result = await useCase('A320');
      expect(result, isA<Right>());
    });
  });

  group('ActivateAircraftModelUseCase', () {
    late MockAircraftModelRepository mockRepo;
    late ActivateAircraftModelUseCase useCase;

    setUp(() {
      mockRepo = MockAircraftModelRepository();
      useCase = ActivateAircraftModelUseCase(repository: mockRepo);
    });

    test('should call repository.activateAircraftModel', () async {
      when(() => mockRepo.activateAircraftModel(any())).thenAnswer(
        (_) async => const Right(
          AircraftModelStatusResponseModel(
            success: true,
            code: 'OK',
            message: 'Activated',
          ),
        ),
      );
      final result = await useCase('1');
      expect(result, isA<Right>());
    });
  });

  group('DeactivateAircraftModelUseCase', () {
    late MockAircraftModelRepository mockRepo;
    late DeactivateAircraftModelUseCase useCase;

    setUp(() {
      mockRepo = MockAircraftModelRepository();
      useCase = DeactivateAircraftModelUseCase(repository: mockRepo);
    });

    test('should call repository.deactivateAircraftModel', () async {
      when(() => mockRepo.deactivateAircraftModel(any())).thenAnswer(
        (_) async => const Right(
          AircraftModelStatusResponseModel(
            success: true,
            code: 'OK',
            message: 'Deactivated',
          ),
        ),
      );
      final result = await useCase('1');
      expect(result, isA<Right>());
    });
  });
}
