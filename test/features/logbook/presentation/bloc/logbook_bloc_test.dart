import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/create_daily_logbook_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/delete_daily_logbook_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/update_logbook_detail_use_case.dart';
import 'package:flight_hours_app/features/logbook/domain/usecases/get_logbook_detail_by_id_use_case.dart';

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

class MockActivateDailyLogbookUseCase extends Mock
    implements ActivateDailyLogbookUseCase {}

class MockDeactivateDailyLogbookUseCase extends Mock
    implements DeactivateDailyLogbookUseCase {}

class MockDeleteDailyLogbookUseCase extends Mock
    implements DeleteDailyLogbookUseCase {}

class MockUpdateLogbookDetailUseCase extends Mock
    implements UpdateLogbookDetailUseCase {}

class MockGetLogbookDetailByIdUseCase extends Mock
    implements GetLogbookDetailByIdUseCase {}

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

    test('DeleteDailyLogbookEvent should contain id', () {
      const event = DeleteDailyLogbookEvent('lb1');
      expect(event, isA<LogbookEvent>());
      expect(event.props.length, equals(1));
      expect(event.id, 'lb1');
    });

    test('UpdateLogbookDetailEvent should contain all fields', () {
      const detail = LogbookDetailEntity(id: 'd1');
      const event = UpdateLogbookDetailEvent(
        originalDetail: detail,
        dailyLogbookId: 'lb1',
        passengers: 150,
        outTime: '08:00',
        takeoffTime: '08:15',
        landingTime: '10:00',
        inTime: '10:15',
        pilotRole: 'PIC',
        crewRole: 'Captain',
      );
      expect(event, isA<LogbookEvent>());
      expect(event.props.length, equals(15));
      expect(event.originalDetail.id, 'd1');
      expect(event.passengers, 150);
    });
    test('FetchLogbookDetailById should contain detailId', () {
      const event = FetchLogbookDetailById('det-123');
      expect(event, isA<LogbookEvent>());
      expect(event.props.length, equals(1));
      expect(event.detailId, 'det-123');
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

    group('DailyLogbookDeleted', () {
      test('should create with message', () {
        const state = DailyLogbookDeleted(message: 'Logbook deleted');
        expect(state.message, equals('Logbook deleted'));
      });

      test('props should contain message', () {
        const state = DailyLogbookDeleted(message: 'msg');
        expect(state.props.length, equals(1));
      });
    });

    group('LogbookDetailUpdated', () {
      test('should create with message', () {
        const state = LogbookDetailUpdated(message: 'Flight updated');
        expect(state.message, equals('Flight updated'));
      });

      test('props should contain message', () {
        const state = LogbookDetailUpdated(message: 'msg');
        expect(state.props.length, equals(1));
      });
    });

    group('LogbookDetailByIdLoaded', () {
      test('should create with detail', () {
        const detail = LogbookDetailEntity(id: 'det-1');
        const state = LogbookDetailByIdLoaded(detail);
        expect(state.detail.id, equals('det-1'));
      });

      test('props should contain detail', () {
        const detail = LogbookDetailEntity(id: 'det-1');
        const state = LogbookDetailByIdLoaded(detail);
        expect(state.props.length, equals(1));
      });
    });
  });

  group('LogbookBloc', () {
    late MockListDailyLogbooksUseCase mockListDailyUseCase;
    late MockListLogbookDetailsUseCase mockListDetailsUseCase;
    late MockDeleteLogbookDetailUseCase mockDeleteUseCase;
    late MockCreateDailyLogbookUseCase mockCreateUseCase;

    late MockActivateDailyLogbookUseCase mockActivateUseCase;
    late MockDeactivateDailyLogbookUseCase mockDeactivateUseCase;
    late MockDeleteDailyLogbookUseCase mockDeleteDailyUseCase;
    late MockUpdateLogbookDetailUseCase mockUpdateDetailUseCase;
    late MockGetLogbookDetailByIdUseCase mockGetDetailByIdUseCase;

    setUp(() {
      mockListDailyUseCase = MockListDailyLogbooksUseCase();
      mockListDetailsUseCase = MockListLogbookDetailsUseCase();
      mockDeleteUseCase = MockDeleteLogbookDetailUseCase();
      mockCreateUseCase = MockCreateDailyLogbookUseCase();

      mockActivateUseCase = MockActivateDailyLogbookUseCase();
      mockDeactivateUseCase = MockDeactivateDailyLogbookUseCase();
      mockDeleteDailyUseCase = MockDeleteDailyLogbookUseCase();
      mockUpdateDetailUseCase = MockUpdateLogbookDetailUseCase();
      mockGetDetailByIdUseCase = MockGetLogbookDetailByIdUseCase();
    });

    LogbookBloc buildBloc() {
      return LogbookBloc(
        listDailyLogbooksUseCase: mockListDailyUseCase,
        listLogbookDetailsUseCase: mockListDetailsUseCase,
        deleteLogbookDetailUseCase: mockDeleteUseCase,
        createDailyLogbookUseCase: mockCreateUseCase,
        deleteDailyLogbookUseCase: mockDeleteDailyUseCase,

        activateDailyLogbookUseCase: mockActivateUseCase,
        deactivateDailyLogbookUseCase: mockDeactivateUseCase,
        updateLogbookDetailUseCase: mockUpdateDetailUseCase,
        getLogbookDetailByIdUseCase: mockGetDetailByIdUseCase,
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

    // ========== DeleteDailyLogbook Tests ==========

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, DailyLogbookDeleted, LogbooksLoaded] when DeleteDailyLogbook succeeds',
      setUp: () {
        when(
          () => mockDeleteDailyUseCase.call(any()),
        ).thenAnswer((_) async => const Right(true));
        when(
          () => mockListDailyUseCase.call(),
        ).thenAnswer((_) async => const Right([DailyLogbookEntity(id: 'lb2')]));
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const DeleteDailyLogbookEvent('lb1')),
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<DailyLogbookDeleted>(),
            isA<DailyLogbooksLoaded>(),
          ],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Error, LogbooksLoaded] when DeleteDailyLogbook fails',
      setUp: () {
        when(() => mockDeleteDailyUseCase.call(any())).thenAnswer(
          (_) async => const Left(Failure(message: 'Delete failed')),
        );
        when(
          () => mockListDailyUseCase.call(),
        ).thenAnswer((_) async => const Right([DailyLogbookEntity(id: 'lb1')]));
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const DeleteDailyLogbookEvent('lb1')),
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<LogbookError>(),
            isA<DailyLogbooksLoaded>(),
          ],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Error] when DeleteDailyLogbook returns false',
      setUp: () {
        when(
          () => mockDeleteDailyUseCase.call(any()),
        ).thenAnswer((_) async => const Right(false));
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const DeleteDailyLogbookEvent('lb1')),
      expect: () => [isA<LogbookLoading>(), isA<LogbookError>()],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, DailyLogbookDeleted, Error] when DeleteDailyLogbook succeeds but refresh fails',
      setUp: () {
        when(
          () => mockDeleteDailyUseCase.call(any()),
        ).thenAnswer((_) async => const Right(true));
        when(() => mockListDailyUseCase.call()).thenAnswer(
          (_) async => const Left(Failure(message: 'Refresh failed')),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const DeleteDailyLogbookEvent('lb1')),
      expect:
          () => [
            isA<LogbookLoading>(),
            isA<DailyLogbookDeleted>(),
            isA<LogbookError>(),
          ],
    );

    // ========== UpdateLogbookDetail Tests ==========

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, DetailUpdated] when UpdateLogbookDetail succeeds',
      setUp: () {
        when(
          () => mockUpdateDetailUseCase.call(
            id: any(named: 'id'),
            flightRealDate: any(named: 'flightRealDate'),
            flightNumber: any(named: 'flightNumber'),
            airlineRouteId: any(named: 'airlineRouteId'),
            licensePlateId: any(named: 'licensePlateId'),
            passengers: any(named: 'passengers'),
            outTime: any(named: 'outTime'),
            takeoffTime: any(named: 'takeoffTime'),
            landingTime: any(named: 'landingTime'),
            inTime: any(named: 'inTime'),
            pilotRole: any(named: 'pilotRole'),
            crewRole: any(named: 'crewRole'),
            companionName: any(named: 'companionName'),
            airTime: any(named: 'airTime'),
            blockTime: any(named: 'blockTime'),
            dutyTime: any(named: 'dutyTime'),
            approachType: any(named: 'approachType'),
            flightType: any(named: 'flightType'),
          ),
        ).thenAnswer((_) async => const Right(LogbookDetailEntity(id: 'd1')));
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            const UpdateLogbookDetailEvent(
              originalDetail: LogbookDetailEntity(id: 'd1'),
              dailyLogbookId: 'lb1',
              passengers: 150,
              outTime: '08:00',
              takeoffTime: '08:15',
              landingTime: '10:00',
              inTime: '10:15',
              pilotRole: 'PIC',
              crewRole: 'Captain',
            ),
          ),
      expect: () => [isA<LogbookLoading>(), isA<LogbookDetailUpdated>()],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Error] when UpdateLogbookDetail fails',
      setUp: () {
        when(
          () => mockUpdateDetailUseCase.call(
            id: any(named: 'id'),
            flightRealDate: any(named: 'flightRealDate'),
            flightNumber: any(named: 'flightNumber'),
            airlineRouteId: any(named: 'airlineRouteId'),
            licensePlateId: any(named: 'licensePlateId'),
            passengers: any(named: 'passengers'),
            outTime: any(named: 'outTime'),
            takeoffTime: any(named: 'takeoffTime'),
            landingTime: any(named: 'landingTime'),
            inTime: any(named: 'inTime'),
            pilotRole: any(named: 'pilotRole'),
            crewRole: any(named: 'crewRole'),
            companionName: any(named: 'companionName'),
            airTime: any(named: 'airTime'),
            blockTime: any(named: 'blockTime'),
            dutyTime: any(named: 'dutyTime'),
            approachType: any(named: 'approachType'),
            flightType: any(named: 'flightType'),
          ),
        ).thenAnswer(
          (_) async => const Left(Failure(message: 'Update failed')),
        );
      },
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            const UpdateLogbookDetailEvent(
              originalDetail: LogbookDetailEntity(id: 'd1'),
              dailyLogbookId: 'lb1',
              passengers: 150,
              outTime: '08:00',
              takeoffTime: '08:15',
              landingTime: '10:00',
              inTime: '10:15',
              pilotRole: 'PIC',
              crewRole: 'Captain',
            ),
          ),
      expect: () => [isA<LogbookLoading>(), isA<LogbookError>()],
    );

    // ========== FetchLogbookDetailById Tests ==========

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, DetailByIdLoaded] when FetchLogbookDetailById succeeds',
      setUp: () {
        when(() => mockGetDetailByIdUseCase.call(any())).thenAnswer(
          (_) async => const Right(LogbookDetailEntity(id: 'det-1')),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const FetchLogbookDetailById('det-1')),
      expect: () => [isA<LogbookLoading>(), isA<LogbookDetailByIdLoaded>()],
    );

    blocTest<LogbookBloc, LogbookState>(
      'emits [Loading, Error] when FetchLogbookDetailById fails',
      setUp: () {
        when(() => mockGetDetailByIdUseCase.call(any())).thenAnswer(
          (_) async => const Left(Failure(message: 'Detail not found')),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const FetchLogbookDetailById('det-1')),
      expect: () => [isA<LogbookLoading>(), isA<LogbookError>()],
    );
  });
}
