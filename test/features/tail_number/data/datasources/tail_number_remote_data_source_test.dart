import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/tail_number/data/datasources/tail_number_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late TailNumberRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = TailNumberRemoteDataSourceImpl(dio: mockDio);
  });

  group('listTailNumbers', () {
    test('should return list when registrations key exists', () async {
      when(() => mockDio.get('/tail-numbers')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tail-numbers'),
          statusCode: 200,
          data: {
            'registrations': [
              {'id': '1', 'tail_number': 'HK-1333'},
              {'id': '2', 'tail_number': 'HK-4567'},
            ],
            'total': 2,
          },
        ),
      );

      final result = await dataSource.listTailNumbers();

      expect(result.length, 2);
      expect(result[0].tailNumber, 'HK-1333');
      expect(result[1].tailNumber, 'HK-4567');
    });

    test('should return empty list when registrations key missing', () async {
      when(() => mockDio.get('/tail-numbers')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tail-numbers'),
          statusCode: 200,
          data: {'other_key': 'value'},
        ),
      );

      final result = await dataSource.listTailNumbers();

      expect(result, isEmpty);
    });

    test('should return empty list when data is not a Map', () async {
      when(() => mockDio.get('/tail-numbers')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tail-numbers'),
          statusCode: 200,
          data: 'not a map',
        ),
      );

      final result = await dataSource.listTailNumbers();

      expect(result, isEmpty);
    });
  });

  group('getTailNumberByPlate', () {
    test('should return model when data key wraps response', () async {
      when(() => mockDio.get('/tail-numbers/HK-1333')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tail-numbers/HK-1333'),
          statusCode: 200,
          data: {
            'data': {'id': '1', 'tail_number': 'HK-1333'},
          },
        ),
      );

      final result = await dataSource.getTailNumberByPlate('HK-1333');

      expect(result.id, '1');
      expect(result.tailNumber, 'HK-1333');
    });

    test('should return model when response is a flat map', () async {
      when(() => mockDio.get('/tail-numbers/HK-1333')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tail-numbers/HK-1333'),
          statusCode: 200,
          data: {'id': '1', 'tail_number': 'HK-1333'},
        ),
      );

      final result = await dataSource.getTailNumberByPlate('HK-1333');

      expect(result.id, '1');
      expect(result.tailNumber, 'HK-1333');
    });

    test('should throw when data is not a Map', () async {
      when(() => mockDio.get('/tail-numbers/HK-1333')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tail-numbers/HK-1333'),
          statusCode: 200,
          data: 'not a map',
        ),
      );

      expect(
        () => dataSource.getTailNumberByPlate('HK-1333'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
