import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/delete_logbook_detail_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/list_daily_logbooks_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/list_logbook_details_use_case.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_bloc.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_event.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_state.dart';

class MockListDailyLogbooksUseCase extends Mock
    implements ListDailyLogbooksUseCase {}

class MockListLogbookDetailsUseCase extends Mock
    implements ListLogbookDetailsUseCase {}

class MockDeleteLogbookDetailUseCase extends Mock
    implements DeleteLogbookDetailUseCase {}

void main() {
  group('LogbookEvent', () {
    test('FetchDailyLogbooks should be a valid event', () {
      const event = FetchDailyLogbooks();
      expect(event, isA<LogbookEvent>());
      expect(event.props, isEmpty);
    });

    group('SelectDailyLogbook', () {
      test('should create with logbook entity', () {
        const logbook = DailyLogbookEntity(id: 'log123');
        const event = SelectDailyLogbook(logbook);
        expect(event.logbook.id, equals('log123'));
      });

      test('props should contain logbook', () {
        const logbook = DailyLogbookEntity(id: 'log123');
        const event = SelectDailyLogbook(logbook);
        expect(event.props.length, equals(1));
      });
    });

    group('FetchLogbookDetails', () {
      test('should create with dailyLogbookId', () {
        const event = FetchLogbookDetails('logbook456');
        expect(event.dailyLogbookId, equals('logbook456'));
      });

      test('props should contain dailyLogbookId', () {
        const event = FetchLogbookDetails('id123');
        expect(event.props.length, equals(1));
      });
    });

    group('DeleteLogbookDetail', () {
      test('should create with required fields', () {
        const event = DeleteLogbookDetail(
          detailId: 'detail789',
          dailyLogbookId: 'logbook123',
        );
        expect(event.detailId, equals('detail789'));
        expect(event.dailyLogbookId, equals('logbook123'));
      });

      test('props should contain detailId and dailyLogbookId', () {
        const event = DeleteLogbookDetail(
          detailId: 'd1',
          dailyLogbookId: 'lb1',
        );
        expect(event.props.length, equals(2));
      });
    });

    test('ClearSelectedLogbook should be a valid event', () {
      const event = ClearSelectedLogbook();
      expect(event, isA<LogbookEvent>());
      expect(event.props, isEmpty);
    });

    test('RefreshLogbook should be a valid event', () {
      const event = RefreshLogbook();
      expect(event, isA<LogbookEvent>());
      expect(event.props, isEmpty);
    });
  });

  group('LogbookState', () {
    test('LogbookInitial should be a valid state', () {
      const state = LogbookInitial();
      expect(state, isA<LogbookState>());
      expect(state.props, isEmpty);
    });

    test('LogbookLoading should be a valid state', () {
      const state = LogbookLoading();
      expect(state, isA<LogbookState>());
    });

    group('DailyLogbooksLoaded', () {
      test('should create with logbooks list', () {
        const logbooks = [
          DailyLogbookEntity(id: '1'),
          DailyLogbookEntity(id: '2'),
        ];
        const state = DailyLogbooksLoaded(logbooks);
        expect(state.logbooks.length, equals(2));
      });

      test('props should contain logbooks', () {
        const state = DailyLogbooksLoaded([]);
        expect(state.props.length, equals(1));
      });
    });

    group('LogbookDetailsLoaded', () {
      test('should create with selectedLogbook and details', () {
        const logbook = DailyLogbookEntity(id: 'log1');
        const details = [
          LogbookDetailEntity(id: 'detail1'),
          LogbookDetailEntity(id: 'detail2'),
        ];
        const state = LogbookDetailsLoaded(
          selectedLogbook: logbook,
          details: details,
        );
        expect(state.selectedLogbook.id, equals('log1'));
        expect(state.details.length, equals(2));
      });

      test('props should contain selectedLogbook and details', () {
        const logbook = DailyLogbookEntity(id: 'log1');
        const state = LogbookDetailsLoaded(
          selectedLogbook: logbook,
          details: [],
        );
        expect(state.props.length, equals(2));
      });
    });

    group('LogbookError', () {
      test('should create with message', () {
        const state = LogbookError('Network error');
        expect(state.message, equals('Network error'));
      });

      test('props should contain message', () {
        const state = LogbookError('Error');
        expect(state.props.length, equals(1));
      });
    });

    group('LogbookDetailDeleted', () {
      test('should create with message, selectedLogbook and details', () {
        const logbook = DailyLogbookEntity(id: 'log1');
        const state = LogbookDetailDeleted(
          message: 'Deleted successfully',
          selectedLogbook: logbook,
          details: [],
        );
        expect(state.message, equals('Deleted successfully'));
        expect(state.selectedLogbook.id, equals('log1'));
      });

      test('props should contain message, selectedLogbook and details', () {
        const logbook = DailyLogbookEntity(id: 'log1');
        const state = LogbookDetailDeleted(
          message: 'msg',
          selectedLogbook: logbook,
          details: [],
        );
        expect(state.props.length, equals(3));
      });
    });
  });

  group('LogbookBloc', () {
    late MockListDailyLogbooksUseCase mockListDailyUseCase;
    late MockListLogbookDetailsUseCase mockListDetailsUseCase;
    late MockDeleteLogbookDetailUseCase mockDeleteUseCase;

    setUp(() {
      mockListDailyUseCase = MockListDailyLogbooksUseCase();
      mockListDetailsUseCase = MockListLogbookDetailsUseCase();
      mockDeleteUseCase = MockDeleteLogbookDetailUseCase();
    });

    LogbookBloc buildBloc() {
      return LogbookBloc(
        listDailyLogbooksUseCase: mockListDailyUseCase,
        listLogbookDetailsUseCase: mockListDetailsUseCase,
        deleteLogbookDetailUseCase: mockDeleteUseCase,
      );
    }

    test('initial state should be LogbookInitial', () {
      final bloc = buildBloc();
      expect(bloc.state, isA<LogbookInitial>());
    });

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, DailyLogbooksLoaded] when FetchDailyLogbooks succeeds',
      setUp: () {
        when(() => mockListDailyUseCase.call()).thenAnswer(
          (_) async => const Right([
            DailyLogbookEntity(id: 'log1'),
            DailyLogbookEntity(id: 'log2'),
          ]),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const FetchDailyLogbooks()),
      expect: () => [isA<LogbookLoading>(), isA<DailyLogbooksLoaded>()],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, LogbookError] when FetchDailyLogbooks fails',
      setUp: () {
        when(() => mockListDailyUseCase.call()).thenAnswer(
          (_) async => const Left(Failure(message: 'Network error')),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const FetchDailyLogbooks()),
      expect: () => [isA<LogbookLoading>(), isA<LogbookError>()],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, LogbookDetailsLoaded] when SelectDailyLogbook succeeds',
      setUp: () {
        when(() => mockListDetailsUseCase.call(any())).thenAnswer(
          (_) async => const Right([LogbookDetailEntity(id: 'detail1')]),
        );
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            const SelectDailyLogbook(DailyLogbookEntity(id: 'log1')),
          ),
      expect: () => [isA<LogbookLoading>(), isA<LogbookDetailsLoaded>()],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, DailyLogbooksLoaded] when ClearSelectedLogbook is called',
      setUp: () {
        when(
          () => mockListDailyUseCase.call(),
        ).thenAnswer((_) async => const Right([]));
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const ClearSelectedLogbook()),
      expect: () => [isA<LogbookLoading>(), isA<DailyLogbooksLoaded>()],
    );
  });
}
