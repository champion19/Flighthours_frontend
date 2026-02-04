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

    test('should return list from repository', () async {
      // Arrange
      final logbooks = <DailyLogbookEntity>[
        DailyLogbookEntity(id: 'lb1', logDate: DateTime(2024, 1, 1)),
        DailyLogbookEntity(id: 'lb2', logDate: DateTime(2024, 1, 2)),
      ];
      when(
        () => mockRepository.getDailyLogbooks(),
      ).thenAnswer((_) async => logbooks);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result.length, equals(2));
      verify(() => mockRepository.getDailyLogbooks()).called(1);
    });
  });

  group('ListLogbookDetailsUseCase', () {
    late ListLogbookDetailsUseCase useCase;

    setUp(() {
      useCase = ListLogbookDetailsUseCase(repository: mockRepository);
    });

    test('should return list from repository', () async {
      // Arrange
      final details = <LogbookDetailEntity>[
        const LogbookDetailEntity(id: 'd1'),
        const LogbookDetailEntity(id: 'd2'),
      ];
      when(
        () => mockRepository.getLogbookDetails(any()),
      ).thenAnswer((_) async => details);

      // Act
      final result = await useCase.call('lb1');

      // Assert
      expect(result.length, equals(2));
      verify(() => mockRepository.getLogbookDetails('lb1')).called(1);
    });
  });

  group('GetLogbookDetailByIdUseCase', () {
    late GetLogbookDetailByIdUseCase useCase;

    setUp(() {
      useCase = GetLogbookDetailByIdUseCase(repository: mockRepository);
    });

    test('should return detail from repository', () async {
      // Arrange
      const detail = LogbookDetailEntity(id: 'd1');
      when(
        () => mockRepository.getLogbookDetailById(any()),
      ).thenAnswer((_) async => detail);

      // Act
      final result = await useCase.call('d1');

      // Assert
      expect(result?.id, equals('d1'));
      verify(() => mockRepository.getLogbookDetailById('d1')).called(1);
    });

    test('should return null when not found', () async {
      // Arrange
      when(
        () => mockRepository.getLogbookDetailById(any()),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase.call('notfound');

      // Assert
      expect(result, isNull);
    });
  });

  group('DeleteLogbookDetailUseCase', () {
    late DeleteLogbookDetailUseCase useCase;

    setUp(() {
      useCase = DeleteLogbookDetailUseCase(repository: mockRepository);
    });

    test('should delete detail successfully', () async {
      // Arrange
      when(
        () => mockRepository.deleteLogbookDetail(any()),
      ).thenAnswer((_) async => true);

      // Act
      final result = await useCase.call('d1');

      // Assert
      expect(result, isTrue);
      verify(() => mockRepository.deleteLogbookDetail('d1')).called(1);
    });

    test('should return false on failure', () async {
      // Arrange
      when(
        () => mockRepository.deleteLogbookDetail(any()),
      ).thenAnswer((_) async => false);

      // Act
      final result = await useCase.call('notfound');

      // Assert
      expect(result, isFalse);
    });
  });
}
