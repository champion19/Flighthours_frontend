import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/logbook/data/models/daily_logbook_model.dart';

void main() {
  group('DailyLogbookModel Tests', () {
    group('fromJson', () {
      test('should create model from valid json', () {
        final json = {
          'id': '1',
          'uuid': 'uuid-123',
          'employee_id': 'emp-1',
          'log_date': '2024-01-15T00:00:00Z',
          'book_page': 12345,
          'status': true,
        };

        final model = DailyLogbookModel.fromJson(json);

        expect(model.id, equals('1'));
        expect(model.uuid, equals('uuid-123'));
        expect(model.employeeId, equals('emp-1'));
        expect(model.logDate, isNotNull);
        expect(model.bookPage, equals(12345));
        expect(model.status, isTrue);
      });

      test('should handle null log_date', () {
        final json = {'id': '1', 'log_date': null};

        final model = DailyLogbookModel.fromJson(json);

        expect(model.logDate, isNull);
      });

      test('should handle string book_page', () {
        final json = {'id': '1', 'book_page': '12345'};

        final model = DailyLogbookModel.fromJson(json);

        expect(model.bookPage, equals(12345));
      });

      test('should handle double book_page', () {
        final json = {'id': '1', 'book_page': 123.45};

        final model = DailyLogbookModel.fromJson(json);

        expect(model.bookPage, equals(123));
      });

      test('should handle string status active', () {
        final json = {'id': '1', 'status': 'active'};

        final model = DailyLogbookModel.fromJson(json);

        expect(model.status, isTrue);
      });

      test('should handle string status inactive', () {
        final json = {'id': '1', 'status': 'inactive'};

        final model = DailyLogbookModel.fromJson(json);

        expect(model.status, isFalse);
      });

      test('should handle int status 1', () {
        final json = {'id': '1', 'status': 1};

        final model = DailyLogbookModel.fromJson(json);

        expect(model.status, isTrue);
      });

      test('should handle int status 0', () {
        final json = {'id': '1', 'status': 0};

        final model = DailyLogbookModel.fromJson(json);

        expect(model.status, isFalse);
      });

      test('should handle null status', () {
        final json = {'id': '1', 'status': null};

        final model = DailyLogbookModel.fromJson(json);

        expect(model.status, isNull);
      });

      test('should handle DateTime for log_date', () {
        final date = DateTime(2024, 1, 15);
        final json = {'id': '1', 'log_date': date};

        final model = DailyLogbookModel.fromJson(json);

        expect(model.logDate, equals(date));
      });
    });

    group('toJson', () {
      test('should convert model to json', () {
        final model = DailyLogbookModel(
          id: '1',
          uuid: 'uuid-123',
          employeeId: 'emp-1',
          logDate: DateTime(2024, 1, 15),
          bookPage: 12345,
          status: true,
        );

        final json = model.toJson();

        expect(json['id'], equals('1'));
        expect(json['uuid'], equals('uuid-123'));
        expect(json['employee_id'], equals('emp-1'));
        expect(json['book_page'], equals(12345));
        expect(json['status'], isTrue);
      });
    });

    group('createRequest', () {
      test('should create request body', () {
        final logDate = DateTime(2024, 1, 15);

        final request = DailyLogbookModel.createRequest(
          logDate: logDate,
          bookPage: 12345,
        );

        expect(request['log_date'], equals('2024-01-15'));
        expect(request['book_page'], equals(12345));
      });
    });

    group('updateRequest', () {
      test('should create update request body', () {
        final logDate = DateTime(2024, 1, 15);

        final request = DailyLogbookModel.updateRequest(
          logDate: logDate,
          bookPage: 12345,
        );

        expect(request['log_date'], equals('2024-01-15'));
        expect(request['book_page'], equals(12345));
        expect(request.containsKey('status'), isFalse);
      });
    });
  });
}
