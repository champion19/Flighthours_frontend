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
import 'package:flight_hours_app/features/logbook/domain/usecases/delete_daily_logbook_use_case.dart';

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

    test('should return Right with list of daily logbooks', () async {
      final logbooks = [
        DailyLogbookEntity(id: '1', employeeId: 'emp1'),
        DailyLogbookEntity(id: '2', employeeId: 'emp1'),
      ];
      when(
        () => mockRepository.getDailyLogbooks(),
      ).thenAnswer((_) async => Right(logbooks));

      final result = await useCase.call();

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, equals(logbooks)),
      );
      verify(() => mockRepository.getDailyLogbooks()).called(1);
    });

    test('should return Right with empty list when no logbooks', () async {
      when(
        () => mockRepository.getDailyLogbooks(),
      ).thenAnswer((_) async => const Right([]));

      final result = await useCase.call();

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, isEmpty),
      );
    });

    test('should return Left when repository fails', () async {
      when(
        () => mockRepository.getDailyLogbooks(),
      ).thenAnswer((_) async => const Left(Failure(message: 'Error')));

      final result = await useCase.call();

      expect(result, isA<Left>());
    });
  });

  group('ListLogbookDetailsUseCase', () {
    late ListLogbookDetailsUseCase useCase;

    setUp(() {
      useCase = ListLogbookDetailsUseCase(repository: mockRepository);
    });

    test('should return Right with list of logbook details', () async {
      final details = [
        const LogbookDetailEntity(id: '1', dailyLogbookId: 'lb1'),
        const LogbookDetailEntity(id: '2', dailyLogbookId: 'lb1'),
      ];
      when(
        () => mockRepository.getLogbookDetails('lb1'),
      ).thenAnswer((_) async => Right(details));

      final result = await useCase.call('lb1');

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, equals(details)),
      );
      verify(() => mockRepository.getLogbookDetails('lb1')).called(1);
    });
  });

  group('GetLogbookDetailByIdUseCase', () {
    late GetLogbookDetailByIdUseCase useCase;

    setUp(() {
      useCase = GetLogbookDetailByIdUseCase(repository: mockRepository);
    });

    test('should return Right with logbook detail by id', () async {
      const detail = LogbookDetailEntity(id: 'det1', dailyLogbookId: 'lb1');
      when(
        () => mockRepository.getLogbookDetailById('det1'),
      ).thenAnswer((_) async => const Right(detail));

      final result = await useCase.call('det1');

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, equals(detail)),
      );
      verify(() => mockRepository.getLogbookDetailById('det1')).called(1);
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
        () => mockRepository.deleteLogbookDetail('det1'),
      ).thenAnswer((_) async => const Right(true));

      final result = await useCase.call('det1');

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, isTrue),
      );
      verify(() => mockRepository.deleteLogbookDetail('det1')).called(1);
    });

    test('should return Left on failure', () async {
      when(
        () => mockRepository.deleteLogbookDetail('det1'),
      ).thenAnswer((_) async => const Left(Failure(message: 'Delete failed')));

      final result = await useCase.call('det1');

      expect(result, isA<Left>());
    });
  });

  group('DeleteDailyLogbookUseCase', () {
    late DeleteDailyLogbookUseCase useCase;

    setUp(() {
      useCase = DeleteDailyLogbookUseCase(repository: mockRepository);
    });

    test('should return Right with true on success', () async {
      when(
        () => mockRepository.deleteDailyLogbook('lb1'),
      ).thenAnswer((_) async => const Right(true));

      final result = await useCase.call('lb1');

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, isTrue),
      );
      verify(() => mockRepository.deleteDailyLogbook('lb1')).called(1);
    });

    test('should return Left on failure', () async {
      when(
        () => mockRepository.deleteDailyLogbook('lb1'),
      ).thenAnswer((_) async => const Left(Failure(message: 'Delete failed')));

      final result = await useCase.call('lb1');

      expect(result, isA<Left>());
    });
  });
}
