import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/core/error/failure.dart';

void main() {
  group('Failure', () {
    test('should create with required message', () {
      const failure = Failure(message: 'Something went wrong');
      expect(failure.message, 'Something went wrong');
      expect(failure.code, isNull);
      expect(failure.statusCode, isNull);
    });

    test('should create with all fields', () {
      const failure = Failure(
        message: 'Not found',
        code: 'ERR_404',
        statusCode: 404,
      );
      expect(failure.message, 'Not found');
      expect(failure.code, 'ERR_404');
      expect(failure.statusCode, 404);
    });

    test('props should contain all fields', () {
      const failure = Failure(message: 'Error', code: 'CODE', statusCode: 500);
      expect(failure.props, ['Error', 'CODE', 500]);
    });

    test('toString should return formatted string', () {
      const failure = Failure(
        message: 'Server error',
        code: 'ERR_500',
        statusCode: 500,
      );
      expect(
        failure.toString(),
        'Failure(message: Server error, code: ERR_500, statusCode: 500)',
      );
    });

    test('two failures with same values should be equal', () {
      const a = Failure(message: 'Error', code: 'X', statusCode: 400);
      const b = Failure(message: 'Error', code: 'X', statusCode: 400);
      expect(a, equals(b));
    });

    test('two failures with different values should not be equal', () {
      const a = Failure(message: 'Error A');
      const b = Failure(message: 'Error B');
      expect(a, isNot(equals(b)));
    });
  });
}
