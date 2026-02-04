import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/logbook/data/datasources/logbook_remote_data_source.dart';
import 'package:flight_hours_app/features/logbook/data/models/daily_logbook_model.dart';
import 'package:flight_hours_app/features/logbook/data/models/logbook_detail_model.dart';
import 'package:flight_hours_app/features/logbook/data/repositories/logbook_repository_impl.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';

class MockLogbookRemoteDataSource extends Mock
    implements LogbookRemoteDataSource {}

void main() {
  late MockLogbookRemoteDataSource mockDataSource;
  late LogbookRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockLogbookRemoteDataSource();
    repository = LogbookRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('LogbookRepositoryImpl', () {
    // ========== Daily Logbook Operations ==========

    group('getDailyLogbooks', () {
      test('should return list from datasource', () async {
        // Arrange
        final logbooks = [
          const DailyLogbookModel(id: 'lb1', bookPage: 1),
          const DailyLogbookModel(id: 'lb2', bookPage: 2),
        ];
        when(
          () => mockDataSource.getDailyLogbooks(),
        ).thenAnswer((_) async => logbooks);

        // Act
        final result = await repository.getDailyLogbooks();

        // Assert
        expect(result, isA<List<DailyLogbookEntity>>());
        expect(result.length, equals(2));
        verify(() => mockDataSource.getDailyLogbooks()).called(1);
      });
    });

    group('getDailyLogbookById', () {
      test('should return entity from datasource', () async {
        // Arrange
        const logbook = DailyLogbookModel(id: 'lb1', bookPage: 1);
        when(
          () => mockDataSource.getDailyLogbookById(any()),
        ).thenAnswer((_) async => logbook);

        // Act
        final result = await repository.getDailyLogbookById('lb1');

        // Assert
        expect(result, isA<DailyLogbookEntity>());
        verify(() => mockDataSource.getDailyLogbookById('lb1')).called(1);
      });

      test('should return null when not found', () async {
        // Arrange
        when(
          () => mockDataSource.getDailyLogbookById(any()),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.getDailyLogbookById('notfound');

        // Assert
        expect(result, isNull);
      });
    });

    group('createDailyLogbook', () {
      test('should call datasource and return entity', () async {
        // Arrange
        const logbook = DailyLogbookModel(id: 'lb1', bookPage: 1);
        when(
          () => mockDataSource.createDailyLogbook(
            logDate: any(named: 'logDate'),
            bookPage: any(named: 'bookPage'),
          ),
        ).thenAnswer((_) async => logbook);

        // Act
        final result = await repository.createDailyLogbook(
          logDate: DateTime(2024, 1, 15),
          bookPage: 1,
        );

        // Assert
        expect(result, isA<DailyLogbookEntity>());
        verify(
          () => mockDataSource.createDailyLogbook(
            logDate: any(named: 'logDate'),
            bookPage: 1,
          ),
        ).called(1);
      });
    });

    group('updateDailyLogbook', () {
      test('should call datasource and return entity', () async {
        // Arrange
        const logbook = DailyLogbookModel(id: 'lb1', bookPage: 2);
        when(
          () => mockDataSource.updateDailyLogbook(
            id: any(named: 'id'),
            logDate: any(named: 'logDate'),
            bookPage: any(named: 'bookPage'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => logbook);

        // Act
        final result = await repository.updateDailyLogbook(
          id: 'lb1',
          logDate: DateTime(2024, 1, 15),
          bookPage: 2,
          status: true,
        );

        // Assert
        expect(result, isA<DailyLogbookEntity>());
        verify(
          () => mockDataSource.updateDailyLogbook(
            id: 'lb1',
            logDate: any(named: 'logDate'),
            bookPage: 2,
            status: true,
          ),
        ).called(1);
      });
    });

    group('deleteDailyLogbook', () {
      test('should return true on success', () async {
        // Arrange
        when(
          () => mockDataSource.deleteDailyLogbook(any()),
        ).thenAnswer((_) async => true);

        // Act
        final result = await repository.deleteDailyLogbook('lb1');

        // Assert
        expect(result, isTrue);
        verify(() => mockDataSource.deleteDailyLogbook('lb1')).called(1);
      });

      test('should return false on failure', () async {
        // Arrange
        when(
          () => mockDataSource.deleteDailyLogbook(any()),
        ).thenAnswer((_) async => false);

        // Act
        final result = await repository.deleteDailyLogbook('lb1');

        // Assert
        expect(result, isFalse);
      });
    });

    // ========== Logbook Detail Operations ==========

    group('getLogbookDetails', () {
      test('should return list from datasource', () async {
        // Arrange
        final details = [
          const LogbookDetailModel(id: 'det1', flightNumber: 'AV001'),
        ];
        when(
          () => mockDataSource.getLogbookDetails(any()),
        ).thenAnswer((_) async => details);

        // Act
        final result = await repository.getLogbookDetails('lb1');

        // Assert
        expect(result, isA<List<LogbookDetailEntity>>());
        verify(() => mockDataSource.getLogbookDetails('lb1')).called(1);
      });
    });

    group('getLogbookDetailById', () {
      test('should return entity from datasource', () async {
        // Arrange
        const detail = LogbookDetailModel(id: 'det1', flightNumber: 'AV001');
        when(
          () => mockDataSource.getLogbookDetailById(any()),
        ).thenAnswer((_) async => detail);

        // Act
        final result = await repository.getLogbookDetailById('det1');

        // Assert
        expect(result, isA<LogbookDetailEntity>());
        verify(() => mockDataSource.getLogbookDetailById('det1')).called(1);
      });
    });

    group('createLogbookDetail', () {
      test('should call datasource with correct request data', () async {
        // Arrange
        const detail = LogbookDetailModel(id: 'det1', flightNumber: 'AV001');
        when(
          () => mockDataSource.createLogbookDetail(
            dailyLogbookId: any(named: 'dailyLogbookId'),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => detail);

        // Act
        final result = await repository.createLogbookDetail(
          dailyLogbookId: 'lb1',
          flightRealDate: '2024-01-15',
          flightNumber: 'AV001',
          airlineRouteId: 'route1',
          actualAircraftRegistrationId: 'aircraft1',
          passengers: 150,
          outTime: '10:00',
          takeoffTime: '10:15',
          landingTime: '11:00',
          inTime: '11:10',
          pilotRole: 'PF',
          companionName: 'Co-pilot',
          airTime: '00:45',
          blockTime: '01:10',
          dutyTime: '08:00',
          approachType: 'ILS',
          flightType: 'Commercial',
        );

        // Assert
        expect(result, isA<LogbookDetailEntity>());
        verify(
          () => mockDataSource.createLogbookDetail(
            dailyLogbookId: 'lb1',
            data: any(named: 'data'),
          ),
        ).called(1);
      });
    });

    group('updateLogbookDetail', () {
      test('should call datasource with correct request data', () async {
        // Arrange
        const detail = LogbookDetailModel(id: 'det1', flightNumber: 'AV002');
        when(
          () => mockDataSource.updateLogbookDetail(
            id: any(named: 'id'),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => detail);

        // Act
        final result = await repository.updateLogbookDetail(
          id: 'det1',
          flightRealDate: '2024-01-15',
          flightNumber: 'AV002',
          airlineRouteId: 'route1',
          actualAircraftRegistrationId: 'aircraft1',
          passengers: 160,
          outTime: '10:00',
          takeoffTime: '10:15',
          landingTime: '11:00',
          inTime: '11:10',
          pilotRole: 'PM',
          companionName: 'Co-pilot',
          airTime: '00:45',
          blockTime: '01:10',
          dutyTime: '08:00',
          approachType: 'VISUAL',
          flightType: 'Commercial',
        );

        // Assert
        expect(result, isA<LogbookDetailEntity>());
        verify(
          () => mockDataSource.updateLogbookDetail(
            id: 'det1',
            data: any(named: 'data'),
          ),
        ).called(1);
      });
    });

    group('deleteLogbookDetail', () {
      test('should return true on success', () async {
        // Arrange
        when(
          () => mockDataSource.deleteLogbookDetail(any()),
        ).thenAnswer((_) async => true);

        // Act
        final result = await repository.deleteLogbookDetail('det1');

        // Assert
        expect(result, isTrue);
        verify(() => mockDataSource.deleteLogbookDetail('det1')).called(1);
      });
    });
  });
}
