import 'package:dio/dio.dart';
import 'package:flight_hours_app/features/manufacturer/data/datasources/manufacturer_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ManufacturerRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = ManufacturerRemoteDataSourceImpl(dio: mockDio);
  });

  group('ManufacturerRemoteDataSourceImpl', () {
    group('getManufacturers', () {
      test('should return list of manufacturers on success', () async {
        when(() => mockDio.get('/manufacturers')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/manufacturers'),
            data: {
              'success': true,
              'data': {
                'manufacturers': [
                  {'id': '1', 'name': 'Boeing', 'status': '1'},
                  {'id': '2', 'name': 'Airbus', 'status': '1'},
                ],
              },
            },
            statusCode: 200,
          ),
        );

        final result = await dataSource.getManufacturers();

        expect(result.length, 2);
        expect(result[0].name, 'Boeing');
        expect(result[1].name, 'Airbus');
      });

      test('should return empty list when data is array', () async {
        when(() => mockDio.get('/manufacturers')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/manufacturers'),
            data: {'success': true, 'data': []},
            statusCode: 200,
          ),
        );

        final result = await dataSource.getManufacturers();

        expect(result, isEmpty);
      });

      test('should return empty list on DioException with response', () async {
        when(() => mockDio.get('/manufacturers')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/manufacturers'),
            response: Response(
              requestOptions: RequestOptions(path: '/manufacturers'),
              statusCode: 500,
            ),
          ),
        );

        final result = await dataSource.getManufacturers();

        expect(result, isEmpty);
      });

      test('should rethrow DioException without response', () async {
        when(() => mockDio.get('/manufacturers')).thenThrow(
          DioException(requestOptions: RequestOptions(path: '/manufacturers')),
        );

        expect(
          () => dataSource.getManufacturers(),
          throwsA(isA<DioException>()),
        );
      });

      test('should parse direct array response', () async {
        when(() => mockDio.get('/manufacturers')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/manufacturers'),
            data: [
              {'id': '1', 'name': 'Embraer', 'status': '1'},
            ],
            statusCode: 200,
          ),
        );

        final result = await dataSource.getManufacturers();

        expect(result.length, 1);
        expect(result[0].name, 'Embraer');
      });
    });

    group('getManufacturerById', () {
      test('should return manufacturer on success', () async {
        when(() => mockDio.get('/manufacturers/test-id')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/manufacturers/test-id'),
            data: {
              'success': true,
              'data': {
                'manufacturer': {
                  'id': 'test-id',
                  'name': 'Boeing',
                  'country': 'USA',
                  'status': '1',
                },
              },
            },
            statusCode: 200,
          ),
        );

        final result = await dataSource.getManufacturerById('test-id');

        expect(result, isNotNull);
        expect(result!.name, 'Boeing');
        expect(result.country, 'USA');
      });

      test('should return manufacturer when data is direct object', () async {
        when(() => mockDio.get('/manufacturers/test-id')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/manufacturers/test-id'),
            data: {
              'success': true,
              'data': {'id': 'test-id', 'name': 'Airbus', 'status': '1'},
            },
            statusCode: 200,
          ),
        );

        final result = await dataSource.getManufacturerById('test-id');

        expect(result, isNotNull);
        expect(result!.name, 'Airbus');
      });

      test('should return null on DioException with response', () async {
        when(() => mockDio.get('/manufacturers/not-found')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/manufacturers/not-found'),
            response: Response(
              requestOptions: RequestOptions(path: '/manufacturers/not-found'),
              statusCode: 404,
            ),
          ),
        );

        final result = await dataSource.getManufacturerById('not-found');

        expect(result, isNull);
      });

      test('should rethrow DioException without response', () async {
        when(() => mockDio.get('/manufacturers/test-id')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/manufacturers/test-id'),
          ),
        );

        expect(
          () => dataSource.getManufacturerById('test-id'),
          throwsA(isA<DioException>()),
        );
      });

      test('should return null for invalid response format', () async {
        when(() => mockDio.get('/manufacturers/test-id')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/manufacturers/test-id'),
            data: 'invalid',
            statusCode: 200,
          ),
        );

        final result = await dataSource.getManufacturerById('test-id');

        expect(result, isNull);
      });
    });
  });
}
