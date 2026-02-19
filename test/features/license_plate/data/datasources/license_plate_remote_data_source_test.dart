import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/license_plate/data/datasources/license_plate_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late LicensePlateRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = LicensePlateRemoteDataSourceImpl(dio: mockDio);
  });

  group('listLicensePlates', () {
    test('should return list when registrations key exists', () async {
      when(() => mockDio.get('/license-plates')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/license-plates'),
          statusCode: 200,
          data: {
            'registrations': [
              {'id': '1', 'license_plate': 'HK-1333'},
              {'id': '2', 'license_plate': 'HK-4567'},
            ],
            'total': 2,
          },
        ),
      );

      final result = await dataSource.listLicensePlates();

      expect(result.length, 2);
      expect(result[0].licensePlate, 'HK-1333');
      expect(result[1].licensePlate, 'HK-4567');
    });

    test('should return empty list when registrations key missing', () async {
      when(() => mockDio.get('/license-plates')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/license-plates'),
          statusCode: 200,
          data: {'other_key': 'value'},
        ),
      );

      final result = await dataSource.listLicensePlates();

      expect(result, isEmpty);
    });

    test('should return empty list when data is not a Map', () async {
      when(() => mockDio.get('/license-plates')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/license-plates'),
          statusCode: 200,
          data: 'not a map',
        ),
      );

      final result = await dataSource.listLicensePlates();

      expect(result, isEmpty);
    });
  });

  group('getLicensePlateByPlate', () {
    test('should return model when data key wraps response', () async {
      when(() => mockDio.get('/license-plates/HK-1333')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/license-plates/HK-1333'),
          statusCode: 200,
          data: {
            'data': {'id': '1', 'license_plate': 'HK-1333'},
          },
        ),
      );

      final result = await dataSource.getLicensePlateByPlate('HK-1333');

      expect(result.id, '1');
      expect(result.licensePlate, 'HK-1333');
    });

    test('should return model when response is a flat map', () async {
      when(() => mockDio.get('/license-plates/HK-1333')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/license-plates/HK-1333'),
          statusCode: 200,
          data: {'id': '1', 'license_plate': 'HK-1333'},
        ),
      );

      final result = await dataSource.getLicensePlateByPlate('HK-1333');

      expect(result.id, '1');
      expect(result.licensePlate, 'HK-1333');
    });

    test('should throw when data is not a Map', () async {
      when(() => mockDio.get('/license-plates/HK-1333')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/license-plates/HK-1333'),
          statusCode: 200,
          data: 'not a map',
        ),
      );

      expect(
        () => dataSource.getLicensePlateByPlate('HK-1333'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
