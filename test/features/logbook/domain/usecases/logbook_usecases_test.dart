import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/list_daily_logbooks_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/list_logbook_details_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/get_logbook_detail_by_id_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/delete_logbook_detail_use_case.dart';

class MockLogbookRepository extends Mock implements LogbookRepository {}

void main() {
  late MockLogbookRepository mockRepository;

  setUp(() {
    mockRepository = MockLogbookRepository();
  });

  group('ListDailyLogbooksUseCase', () {
    late ListDailyLogbooksUseCase useCase;

    setUp(() {
      useCase = ListDailyLogbooksUseCase(repository: mockRepository);
    });

    test('should return Right with list from repository', () async {
      final logbooks = <DailyLogbookEntity>[
        DailyLogbookEntity(id: 'lb1', logDate: DateTime(2024, 1, 1)),
        DailyLogbookEntity(id: 'lb2', logDate: DateTime(2024, 1, 2)),
      ];
      when(
        () => mockRepository.getDailyLogbooks(),
      ).thenAnswer((_) async => Right(logbooks));

      final result = await useCase.call();

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.length, equals(2)),
      );
      verify(() => mockRepository.getDailyLogbooks()).called(1);
    });
  });

  group('ListLogbookDetailsUseCase', () {
    late ListLogbookDetailsUseCase useCase;

    setUp(() {
      useCase = ListLogbookDetailsUseCase(repository: mockRepository);
    });

    test('should return Right with list from repository', () async {
      final details = <LogbookDetailEntity>[
        const LogbookDetailEntity(id: 'd1'),
        const LogbookDetailEntity(id: 'd2'),
      ];
      when(
        () => mockRepository.getLogbookDetails(any()),
      ).thenAnswer((_) async => Right(details));

      final result = await useCase.call('lb1');

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.length, equals(2)),
      );
      verify(() => mockRepository.getLogbookDetails('lb1')).called(1);
    });
  });

  group('GetLogbookDetailByIdUseCase', () {
    late GetLogbookDetailByIdUseCase useCase;

    setUp(() {
      useCase = GetLogbookDetailByIdUseCase(repository: mockRepository);
    });

    test('should return Right with detail from repository', () async {
      const detail = LogbookDetailEntity(id: 'd1');
      when(
        () => mockRepository.getLogbookDetailById(any()),
      ).thenAnswer((_) async => const Right(detail));

      final result = await useCase.call('d1');

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.id, equals('d1')),
      );
      verify(() => mockRepository.getLogbookDetailById('d1')).called(1);
    });

    test('should return Left when not found', () async {
      when(() => mockRepository.getLogbookDetailById(any())).thenAnswer(
        (_) async => const Left(Failure(message: 'Not found', statusCode: 404)),
      );

      final result = await useCase.call('notfound');

      expect(result, isA<Left>());
    });
  });

  group('DeleteLogbookDetailUseCase', () {
    late DeleteLogbookDetailUseCase useCase;

    setUp(() {
      useCase = DeleteLogbookDetailUseCase(repository: mockRepository);
    });

    test('should return Right with true on success', () async {
      when(
        () => mockRepository.deleteLogbookDetail(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await useCase.call('d1');

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, isTrue),
      );
      verify(() => mockRepository.deleteLogbookDetail('d1')).called(1);
    });

    test('should return Left on failure', () async {
      when(
        () => mockRepository.deleteLogbookDetail(any()),
      ).thenAnswer((_) async => const Left(Failure(message: 'Failed')));

      final result = await useCase.call('notfound');

      expect(result, isA<Left>());
    });
  });
}
