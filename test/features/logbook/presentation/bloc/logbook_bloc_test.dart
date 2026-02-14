import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/create_daily_logbook_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/update_daily_logbook_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/activate_daily_logbook_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/deactivate_daily_logbook_use_case.dart';
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

class MockCreateDailyLogbookUseCase extends Mock
    implements CreateDailyLogbookUseCase {}

class MockUpdateDailyLogbookUseCase extends Mock
    implements UpdateDailyLogbookUseCase {}

class MockActivateDailyLogbookUseCase extends Mock
    implements ActivateDailyLogbookUseCase {}

class MockDeactivateDailyLogbookUseCase extends Mock
    implements DeactivateDailyLogbookUseCase {}

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

    test('CreateDailyLogbookEvent should contain logDate and bookPage', () {
      final event = CreateDailyLogbookEvent(
        logDate: DateTime(2024, 1, 15),
        bookPage: 1,
      );
      expect(event, isA<LogbookEvent>());
      expect(event.props.length, equals(2));
      expect(event.logDate, DateTime(2024, 1, 15));
      expect(event.bookPage, 1);
    });

    test('UpdateDailyLogbookEvent should contain id, logDate and bookPage', () {
      final event = UpdateDailyLogbookEvent(
        id: 'lb1',
        logDate: DateTime(2024, 1, 15),
        bookPage: 2,
      );
      expect(event, isA<LogbookEvent>());
      expect(event.props.length, equals(3));
      expect(event.id, 'lb1');
    });

    test('ActivateDailyLogbookEvent should contain id', () {
      const event = ActivateDailyLogbookEvent('lb1');
      expect(event, isA<LogbookEvent>());
      expect(event.props.length, equals(1));
      expect(event.id, 'lb1');
    });

    test('DeactivateDailyLogbookEvent should contain id', () {
      const event = DeactivateDailyLogbookEvent('lb1');
      expect(event, isA<LogbookEvent>());
      expect(event.props.length, equals(1));
      expect(event.id, 'lb1');
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
    late MockCreateDailyLogbookUseCase mockCreateUseCase;
    late MockUpdateDailyLogbookUseCase mockUpdateUseCase;
    late MockActivateDailyLogbookUseCase mockActivateUseCase;
    late MockDeactivateDailyLogbookUseCase mockDeactivateUseCase;

    setUp(() {
      mockListDailyUseCase = MockListDailyLogbooksUseCase();
      mockListDetailsUseCase = MockListLogbookDetailsUseCase();
      mockDeleteUseCase = MockDeleteLogbookDetailUseCase();
      mockCreateUseCase = MockCreateDailyLogbookUseCase();
      mockUpdateUseCase = MockUpdateDailyLogbookUseCase();
      mockActivateUseCase = MockActivateDailyLogbookUseCase();
      mockDeactivateUseCase = MockDeactivateDailyLogbookUseCase();
    });

    LogbookBloc buildBloc() {
      return LogbookBloc(
        listDailyLogbooksUseCase: mockListDailyUseCase,
        listLogbookDetailsUseCase: mockListDetailsUseCase,
        deleteLogbookDetailUseCase: mockDeleteUseCase,
        createDailyLogbookUseCase: mockCreateUseCase,
        updateDailyLogbookUseCase: mockUpdateUseCase,
        activateDailyLogbookUseCase: mockActivateUseCase,
        deactivateDailyLogbookUseCase: mockDeactivateUseCase,
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

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Error] when SelectDailyLogbook fails',
      setUp: () {
        when(() => mockListDetailsUseCase.call(any())).thenAnswer(
          (_) async => const Left(Failure(message: 'Failed to load details')),
        );
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            const SelectDailyLogbook(DailyLogbookEntity(id: 'log1')),
          ),
      expect: () => [isA<LogbookLoading>(), isA<LogbookError>()],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Error] when FetchLogbookDetails called without selected logbook',
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const FetchLogbookDetails('some-id')),
      expect: () => [isA<LogbookError>()],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, DetailsLoaded] when FetchLogbookDetails succeeds',
      setUp: () {
        when(
          () => mockListDetailsUseCase.call(any()),
        ).thenAnswer((_) async => const Right([LogbookDetailEntity(id: 'd1')]));
      },
      build: () => buildBloc(),
      seed:
          () => const LogbookDetailsLoaded(
            selectedLogbook: DailyLogbookEntity(id: 'log1'),
            details: [],
          ),
      act: (bloc) {
        // First select a logbook so _currentSelectedLogbook is set
        bloc.add(const SelectDailyLogbook(DailyLogbookEntity(id: 'log1')));
      },
      expect: () => [isA<LogbookLoading>(), isA<LogbookDetailsLoaded>()],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Error] when FetchLogbookDetails fails after select',
      setUp: () {
        // First call succeeds (SelectDailyLogbook), second call fails (FetchLogbookDetails)
        int callCount = 0;
        when(() => mockListDetailsUseCase.call(any())).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) {
            return const Right([LogbookDetailEntity(id: 'd1')]);
          }
          return const Left(Failure(message: 'Failed'));
        });
      },
      build: () => buildBloc(),
      act: (bloc) {
        bloc.add(const SelectDailyLogbook(DailyLogbookEntity(id: 'log1')));
        bloc.add(const FetchLogbookDetails('log1'));
      },
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<LogbookDetailsLoaded>(),
            isA<LogbookLoading>(),
            isA<LogbookError>(),
          ],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Error] when DeleteLogbookDetail called without selected logbook',
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            const DeleteLogbookDetail(detailId: 'det1', dailyLogbookId: 'log1'),
          ),
      expect: () => [isA<LogbookError>()],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, DetailDeleted] when DeleteLogbookDetail succeeds',
      setUp: () {
        when(
          () => mockListDetailsUseCase.call(any()),
        ).thenAnswer((_) async => const Right([LogbookDetailEntity(id: 'd1')]));
        when(
          () => mockDeleteUseCase.call(any()),
        ).thenAnswer((_) async => const Right(true));
      },
      build: () => buildBloc(),
      act: (bloc) {
        // First select so _currentSelectedLogbook is set
        bloc.add(const SelectDailyLogbook(DailyLogbookEntity(id: 'log1')));
        bloc.add(
          const DeleteLogbookDetail(detailId: 'det1', dailyLogbookId: 'log1'),
        );
      },
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<LogbookDetailsLoaded>(),
            isA<LogbookLoading>(),
            isA<LogbookDetailDeleted>(),
          ],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Error] when DeleteLogbookDetail returns Left',
      setUp: () {
        when(
          () => mockListDetailsUseCase.call(any()),
        ).thenAnswer((_) async => const Right([LogbookDetailEntity(id: 'd1')]));
        when(() => mockDeleteUseCase.call(any())).thenAnswer(
          (_) async => const Left(Failure(message: 'Delete failed')),
        );
      },
      build: () => buildBloc(),
      act: (bloc) {
        bloc.add(const SelectDailyLogbook(DailyLogbookEntity(id: 'log1')));
        bloc.add(
          const DeleteLogbookDetail(detailId: 'det1', dailyLogbookId: 'log1'),
        );
      },
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<LogbookDetailsLoaded>(),
            isA<LogbookLoading>(),
            isA<LogbookError>(),
          ],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Error] when DeleteLogbookDetail returns false',
      setUp: () {
        when(
          () => mockListDetailsUseCase.call(any()),
        ).thenAnswer((_) async => const Right([LogbookDetailEntity(id: 'd1')]));
        when(
          () => mockDeleteUseCase.call(any()),
        ).thenAnswer((_) async => const Right(false));
      },
      build: () => buildBloc(),
      act: (bloc) {
        bloc.add(const SelectDailyLogbook(DailyLogbookEntity(id: 'log1')));
        bloc.add(
          const DeleteLogbookDetail(detailId: 'det1', dailyLogbookId: 'log1'),
        );
      },
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<LogbookDetailsLoaded>(),
            isA<LogbookLoading>(),
            isA<LogbookError>(),
          ],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Error] when ClearSelectedLogbook fails to reload',
      setUp: () {
        when(() => mockListDailyUseCase.call()).thenAnswer(
          (_) async => const Left(Failure(message: 'Reload failed')),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const ClearSelectedLogbook()),
      expect: () => [isA<LogbookLoading>(), isA<LogbookError>()],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, DailyLogbooksLoaded] when RefreshLogbook without selected logbook',
      setUp: () {
        when(() => mockListDailyUseCase.call()).thenAnswer(
          (_) async => const Right([DailyLogbookEntity(id: 'log1')]),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const RefreshLogbook()),
      expect: () => [isA<LogbookLoading>(), isA<DailyLogbooksLoaded>()],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Error] when RefreshLogbook without selected logbook fails',
      setUp: () {
        when(() => mockListDailyUseCase.call()).thenAnswer(
          (_) async => const Left(Failure(message: 'Refresh failed')),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const RefreshLogbook()),
      expect: () => [isA<LogbookLoading>(), isA<LogbookError>()],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, DetailsLoaded] when RefreshLogbook with selected logbook',
      setUp: () {
        when(
          () => mockListDetailsUseCase.call(any()),
        ).thenAnswer((_) async => const Right([LogbookDetailEntity(id: 'd1')]));
      },
      build: () => buildBloc(),
      act: (bloc) {
        // First select a logbook
        bloc.add(const SelectDailyLogbook(DailyLogbookEntity(id: 'log1')));
        // Then refresh
        bloc.add(const RefreshLogbook());
      },
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<LogbookDetailsLoaded>(),
            isA<LogbookLoading>(),
            isA<LogbookDetailsLoaded>(),
          ],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Error] when RefreshLogbook with selected logbook fails',
      setUp: () {
        int callCount = 0;
        when(() => mockListDetailsUseCase.call(any())).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) {
            return const Right([LogbookDetailEntity(id: 'd1')]);
          }
          return const Left(Failure(message: 'Refresh failed'));
        });
      },
      build: () => buildBloc(),
      act: (bloc) {
        bloc.add(const SelectDailyLogbook(DailyLogbookEntity(id: 'log1')));
        bloc.add(const RefreshLogbook());
      },
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<LogbookDetailsLoaded>(),
            isA<LogbookLoading>(),
            isA<LogbookError>(),
          ],
    );

    // ========== CreateDailyLogbook Tests ==========

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Created, LogbooksLoaded] when CreateDailyLogbook succeeds',
      setUp: () {
        when(
          () => mockCreateUseCase.call(
            logDate: any(named: 'logDate'),
            bookPage: any(named: 'bookPage'),
          ),
        ).thenAnswer((_) async => const Right(DailyLogbookEntity(id: 'new1')));
        when(() => mockListDailyUseCase.call()).thenAnswer(
          (_) async => const Right([DailyLogbookEntity(id: 'new1')]),
        );
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            CreateDailyLogbookEvent(
              logDate: DateTime(2024, 1, 15),
              bookPage: 1,
            ),
          ),
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<DailyLogbookCreated>(),
            isA<DailyLogbooksLoaded>(),
          ],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Error, LogbooksLoaded] when CreateDailyLogbook fails',
      setUp: () {
        when(
          () => mockCreateUseCase.call(
            logDate: any(named: 'logDate'),
            bookPage: any(named: 'bookPage'),
          ),
        ).thenAnswer(
          (_) async => const Left(Failure(message: 'Duplicate entry')),
        );
        when(() => mockListDailyUseCase.call()).thenAnswer(
          (_) async => const Right([DailyLogbookEntity(id: 'log1')]),
        );
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            CreateDailyLogbookEvent(
              logDate: DateTime(2024, 1, 15),
              bookPage: 1,
            ),
          ),
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<LogbookError>(),
            isA<DailyLogbooksLoaded>(),
          ],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Created] when CreateDailyLogbook succeeds but refresh fails',
      setUp: () {
        when(
          () => mockCreateUseCase.call(
            logDate: any(named: 'logDate'),
            bookPage: any(named: 'bookPage'),
          ),
        ).thenAnswer((_) async => const Right(DailyLogbookEntity(id: 'new1')));
        when(() => mockListDailyUseCase.call()).thenAnswer(
          (_) async => const Left(Failure(message: 'Refresh failed')),
        );
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            CreateDailyLogbookEvent(
              logDate: DateTime(2024, 1, 15),
              bookPage: 1,
            ),
          ),
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<DailyLogbookCreated>(),
            isA<LogbookError>(),
          ],
    );

    // ========== UpdateDailyLogbook Tests ==========

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Updated, LogbooksLoaded] when UpdateDailyLogbook succeeds',
      setUp: () {
        when(
          () => mockUpdateUseCase.call(
            id: any(named: 'id'),
            logDate: any(named: 'logDate'),
            bookPage: any(named: 'bookPage'),
          ),
        ).thenAnswer((_) async => const Right(DailyLogbookEntity(id: 'lb1')));
        when(
          () => mockListDailyUseCase.call(),
        ).thenAnswer((_) async => const Right([DailyLogbookEntity(id: 'lb1')]));
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            UpdateDailyLogbookEvent(
              id: 'lb1',
              logDate: DateTime(2024, 1, 15),
              bookPage: 2,
            ),
          ),
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<DailyLogbookUpdated>(),
            isA<DailyLogbooksLoaded>(),
          ],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Error, LogbooksLoaded] when UpdateDailyLogbook fails',
      setUp: () {
        when(
          () => mockUpdateUseCase.call(
            id: any(named: 'id'),
            logDate: any(named: 'logDate'),
            bookPage: any(named: 'bookPage'),
          ),
        ).thenAnswer((_) async => const Left(Failure(message: 'Not found')));
        when(
          () => mockListDailyUseCase.call(),
        ).thenAnswer((_) async => const Right([DailyLogbookEntity(id: 'lb1')]));
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            UpdateDailyLogbookEvent(
              id: 'lb1',
              logDate: DateTime(2024, 1, 15),
              bookPage: 2,
            ),
          ),
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<LogbookError>(),
            isA<DailyLogbooksLoaded>(),
          ],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Updated, Error] when UpdateDailyLogbook succeeds but refresh fails',
      setUp: () {
        when(
          () => mockUpdateUseCase.call(
            id: any(named: 'id'),
            logDate: any(named: 'logDate'),
            bookPage: any(named: 'bookPage'),
          ),
        ).thenAnswer((_) async => const Right(DailyLogbookEntity(id: 'lb1')));
        when(() => mockListDailyUseCase.call()).thenAnswer(
          (_) async => const Left(Failure(message: 'Refresh failed')),
        );
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            UpdateDailyLogbookEvent(
              id: 'lb1',
              logDate: DateTime(2024, 1, 15),
              bookPage: 2,
            ),
          ),
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<DailyLogbookUpdated>(),
            isA<LogbookError>(),
          ],
    );

    // ========== ActivateDailyLogbook Tests ==========

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, StatusChanged, LogbooksLoaded] when ActivateDailyLogbook succeeds',
      setUp: () {
        when(
          () => mockActivateUseCase.call(any()),
        ).thenAnswer((_) async => const Right(true));
        when(
          () => mockListDailyUseCase.call(),
        ).thenAnswer((_) async => const Right([DailyLogbookEntity(id: 'lb1')]));
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const ActivateDailyLogbookEvent('lb1')),
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<DailyLogbookStatusChanged>(),
            isA<DailyLogbooksLoaded>(),
          ],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Error, LogbooksLoaded] when ActivateDailyLogbook fails',
      setUp: () {
        when(() => mockActivateUseCase.call(any())).thenAnswer(
          (_) async => const Left(Failure(message: 'Activate failed')),
        );
        when(
          () => mockListDailyUseCase.call(),
        ).thenAnswer((_) async => const Right([DailyLogbookEntity(id: 'lb1')]));
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const ActivateDailyLogbookEvent('lb1')),
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<LogbookError>(),
            isA<DailyLogbooksLoaded>(),
          ],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, StatusChanged, Error] when ActivateDailyLogbook succeeds but refresh fails',
      setUp: () {
        when(
          () => mockActivateUseCase.call(any()),
        ).thenAnswer((_) async => const Right(true));
        when(() => mockListDailyUseCase.call()).thenAnswer(
          (_) async => const Left(Failure(message: 'Refresh failed')),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const ActivateDailyLogbookEvent('lb1')),
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<DailyLogbookStatusChanged>(),
            isA<LogbookError>(),
          ],
    );

    // ========== DeactivateDailyLogbook Tests ==========

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, StatusChanged, LogbooksLoaded] when DeactivateDailyLogbook succeeds',
      setUp: () {
        when(
          () => mockDeactivateUseCase.call(any()),
        ).thenAnswer((_) async => const Right(true));
        when(
          () => mockListDailyUseCase.call(),
        ).thenAnswer((_) async => const Right([DailyLogbookEntity(id: 'lb1')]));
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const DeactivateDailyLogbookEvent('lb1')),
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<DailyLogbookStatusChanged>(),
            isA<DailyLogbooksLoaded>(),
          ],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Error, LogbooksLoaded] when DeactivateDailyLogbook fails',
      setUp: () {
        when(() => mockDeactivateUseCase.call(any())).thenAnswer(
          (_) async => const Left(Failure(message: 'Deactivate failed')),
        );
        when(
          () => mockListDailyUseCase.call(),
        ).thenAnswer((_) async => const Right([DailyLogbookEntity(id: 'lb1')]));
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const DeactivateDailyLogbookEvent('lb1')),
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<LogbookError>(),
            isA<DailyLogbooksLoaded>(),
          ],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, StatusChanged, Error] when DeactivateDailyLogbook succeeds but refresh fails',
      setUp: () {
        when(
          () => mockDeactivateUseCase.call(any()),
        ).thenAnswer((_) async => const Right(true));
        when(() => mockListDailyUseCase.call()).thenAnswer(
          (_) async => const Left(Failure(message: 'Refresh failed')),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const DeactivateDailyLogbookEvent('lb1')),
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<DailyLogbookStatusChanged>(),
            isA<LogbookError>(),
          ],
    );
  });
}
