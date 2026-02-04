import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_event.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_state.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';

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
}
