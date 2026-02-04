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

    test('should return list of daily logbooks from repository', () async {
      // Arrange
      final logbooks = [
        DailyLogbookEntity(id: '1', employeeId: 'emp1'),
        DailyLogbookEntity(id: '2', employeeId: 'emp1'),
      ];
      when(
        () => mockRepository.getDailyLogbooks(),
      ).thenAnswer((_) async => logbooks);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(logbooks));
      verify(() => mockRepository.getDailyLogbooks()).called(1);
    });

    test('should return empty list when no logbooks', () async {
      // Arrange
      when(() => mockRepository.getDailyLogbooks()).thenAnswer((_) async => []);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isEmpty);
    });
  });

  group('ListLogbookDetailsUseCase', () {
    late ListLogbookDetailsUseCase useCase;

    setUp(() {
      useCase = ListLogbookDetailsUseCase(repository: mockRepository);
    });

    test('should return list of logbook details from repository', () async {
      // Arrange
      final details = [
        const LogbookDetailEntity(id: '1', dailyLogbookId: 'lb1'),
        const LogbookDetailEntity(id: '2', dailyLogbookId: 'lb1'),
      ];
      when(
        () => mockRepository.getLogbookDetails('lb1'),
      ).thenAnswer((_) async => details);

      // Act
      final result = await useCase.call('lb1');

      // Assert
      expect(result, equals(details));
      verify(() => mockRepository.getLogbookDetails('lb1')).called(1);
    });
  });

  group('GetLogbookDetailByIdUseCase', () {
    late GetLogbookDetailByIdUseCase useCase;

    setUp(() {
      useCase = GetLogbookDetailByIdUseCase(repository: mockRepository);
    });

    test('should return logbook detail by id from repository', () async {
      // Arrange
      const detail = LogbookDetailEntity(id: 'det1', dailyLogbookId: 'lb1');
      when(
        () => mockRepository.getLogbookDetailById('det1'),
      ).thenAnswer((_) async => detail);

      // Act
      final result = await useCase.call('det1');

      // Assert
      expect(result, equals(detail));
      verify(() => mockRepository.getLogbookDetailById('det1')).called(1);
    });
  });

  group('DeleteLogbookDetailUseCase', () {
    late DeleteLogbookDetailUseCase useCase;

    setUp(() {
      useCase = DeleteLogbookDetailUseCase(repository: mockRepository);
    });

    test('should call repository delete and return true on success', () async {
      // Arrange
      when(
        () => mockRepository.deleteLogbookDetail('det1'),
      ).thenAnswer((_) async => true);

      // Act
      final result = await useCase.call('det1');

      // Assert
      expect(result, isTrue);
      verify(() => mockRepository.deleteLogbookDetail('det1')).called(1);
    });

    test('should return false on failure', () async {
      // Arrange
      when(
        () => mockRepository.deleteLogbookDetail('det1'),
      ).thenAnswer((_) async => false);

      // Act
      final result = await useCase.call('det1');

      // Assert
      expect(result, isFalse);
    });
  });
}
