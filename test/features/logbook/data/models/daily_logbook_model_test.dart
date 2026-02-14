import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/logbook/data/models/daily_logbook_model.dart';

void main() {
  group('DailyLogbookModel', () {
    test('fromJson should parse valid JSON correctly', () {
      // Arrange
      final json = {
        'id': 'logbook123',
        'uuid': 'uuid-1234-5678',
        'employee_id': 'emp456',
        'log_date': '2026-01-10T00:00:00-05:00',
        'book_page': 210930050,
        'status': true,
      };

      // Act
      final result = DailyLogbookModel.fromJson(json);

      // Assert
      expect(result.id, equals('logbook123'));
      expect(result.uuid, equals('uuid-1234-5678'));
      expect(result.employeeId, equals('emp456'));
      expect(result.logDate, isNotNull);
      expect(result.logDate!.year, equals(2026));
      expect(result.bookPage, equals(210930050));
      expect(result.status, isTrue);
    });

    test('fromJson should parse status from string correctly', () {
      // Arrange - status as "active"
      final jsonActive = {'id': 'test1', 'status': 'active'};
      // Arrange - status as "inactive"
      final jsonInactive = {'id': 'test2', 'status': 'inactive'};
      // Arrange - status as "true"
      final jsonTrue = {'id': 'test3', 'status': 'true'};

      // Act
      final resultActive = DailyLogbookModel.fromJson(jsonActive);
      final resultInactive = DailyLogbookModel.fromJson(jsonInactive);
      final resultTrue = DailyLogbookModel.fromJson(jsonTrue);

      // Assert
      expect(resultActive.status, isTrue);
      expect(resultInactive.status, isFalse);
      expect(resultTrue.status, isTrue);
    });

    test('fromJson should parse status from int correctly', () {
      // Arrange
      final json1 = {'id': 'test1', 'status': 1};
      final json0 = {'id': 'test2', 'status': 0};

      // Act
      final result1 = DailyLogbookModel.fromJson(json1);
      final result0 = DailyLogbookModel.fromJson(json0);

      // Assert
      expect(result1.status, isTrue);
      expect(result0.status, isFalse);
    });

    test('fromJson should parse book_page from various types', () {
      // Arrange - int
      final jsonInt = {'id': 'test1', 'book_page': 123};
      // Arrange - string
      final jsonString = {'id': 'test2', 'book_page': '456'};
      // Arrange - double
      final jsonDouble = {'id': 'test3', 'book_page': 789.0};

      // Act
      final resultInt = DailyLogbookModel.fromJson(jsonInt);
      final resultString = DailyLogbookModel.fromJson(jsonString);
      final resultDouble = DailyLogbookModel.fromJson(jsonDouble);

      // Assert
      expect(resultInt.bookPage, equals(123));
      expect(resultString.bookPage, equals(456));
      expect(resultDouble.bookPage, equals(789));
    });

    test('fromJson should handle null values gracefully', () {
      // Arrange
      final json = {'id': 'test1'};

      // Act
      final result = DailyLogbookModel.fromJson(json);

      // Assert
      expect(result.id, equals('test1'));
      expect(result.uuid, isNull);
      expect(result.employeeId, isNull);
      expect(result.logDate, isNull);
      expect(result.bookPage, isNull);
      expect(result.status, isNull);
    });

    test('toJson should serialize correctly', () {
      // Arrange
      final model = DailyLogbookModel(
        id: 'logbook123',
        uuid: 'uuid-1234',
        employeeId: 'emp456',
        logDate: DateTime(2026, 1, 10),
        bookPage: 123,
        status: true,
      );

      // Act
      final result = model.toJson();

      // Assert
      expect(result['id'], equals('logbook123'));
      expect(result['uuid'], equals('uuid-1234'));
      expect(result['employee_id'], equals('emp456'));
      expect(result['log_date'], equals('2026-01-10'));
      expect(result['book_page'], equals(123));
      expect(result['status'], isTrue);
    });

    test('toJson should exclude null values', () {
      // Arrange
      const model = DailyLogbookModel(id: 'test1');

      // Act
      final result = model.toJson();

      // Assert
      expect(result.containsKey('uuid'), isFalse);
      expect(result.containsKey('employee_id'), isFalse);
      expect(result.containsKey('log_date'), isFalse);
    });

    test('createRequest should build correct request body', () {
      // Act
      final result = DailyLogbookModel.createRequest(
        logDate: DateTime(2026, 3, 15),
        bookPage: 999,
      );

      // Assert
      expect(result['log_date'], equals('2026-03-15'));
      expect(result['book_page'], equals(999));
    });

    test('updateRequest should build correct request body', () {
      // Act
      final result = DailyLogbookModel.updateRequest(
        logDate: DateTime(2026, 5, 20),
        bookPage: 500,
      );

      // Assert
      expect(result['log_date'], equals('2026-05-20'));
      expect(result['book_page'], equals(500));
      expect(result.containsKey('status'), isFalse);
    });
  });
}
