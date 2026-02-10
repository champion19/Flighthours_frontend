import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/aircraft_model/data/datasources/aircraft_model_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AircraftModelRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = AircraftModelRemoteDataSourceImpl(dio: mockDio);
  });

  group('getAircraftModels', () {
    test('should return list of AircraftModelModel on success', () async {
      when(() => mockDio.get('/aircraft-models')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/aircraft-models'),
          statusCode: 200,
          data: {
            'success': true,
            'data': {
              'aircraft_models': [
                {'id': '1', 'name': 'A320', 'status': 'active'},
                {'id': '2', 'name': 'B737', 'status': 'inactive'},
              ],
              'total': 2,
            },
          },
        ),
      );

      final result = await dataSource.getAircraftModels();

      expect(result.length, 2);
      expect(result[0].name, 'A320');
      expect(result[1].name, 'B737');
    });

    test('should return empty list on DioException with response', () async {
      when(() => mockDio.get('/aircraft-models')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/aircraft-models'),
          response: Response(
            requestOptions: RequestOptions(path: '/aircraft-models'),
            statusCode: 404,
            data: {'error': 'Not found'},
          ),
        ),
      );

      final result = await dataSource.getAircraftModels();
      expect(result, isEmpty);
    });

    test('should rethrow DioException without response', () async {
      when(() => mockDio.get('/aircraft-models')).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/aircraft-models')),
      );

      expect(
        () => dataSource.getAircraftModels(),
        throwsA(isA<DioException>()),
      );
    });

    test('should handle data as direct array', () async {
      when(() => mockDio.get('/aircraft-models')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/aircraft-models'),
          statusCode: 200,
          data: {
            'success': true,
            'data': [
              {'id': '1', 'name': 'E190'},
            ],
          },
        ),
      );

      final result = await dataSource.getAircraftModels();
      expect(result.length, 1);
      expect(result[0].name, 'E190');
    });

    test('should handle direct array response', () async {
      when(() => mockDio.get('/aircraft-models')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/aircraft-models'),
          statusCode: 200,
          data: [
            {'id': '1', 'name': 'CRJ-900'},
          ],
        ),
      );

      final result = await dataSource.getAircraftModels();
      expect(result.length, 1);
    });

    test('should return empty list for unexpected format', () async {
      when(() => mockDio.get('/aircraft-models')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/aircraft-models'),
          statusCode: 200,
          data: 'unexpected',
        ),
      );

      final result = await dataSource.getAircraftModels();
      expect(result, isEmpty);
    });

    test('should handle camelCase key aircraftModels', () async {
      when(() => mockDio.get('/aircraft-models')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/aircraft-models'),
          statusCode: 200,
          data: {
            'success': true,
            'data': {
              'aircraftModels': [
                {'id': '1', 'name': 'ATR72'},
              ],
            },
          },
        ),
      );

      final result = await dataSource.getAircraftModels();
      expect(result.length, 1);
      expect(result[0].name, 'ATR72');
    });
  });

  group('getAircraftModelById', () {
    test('should return model from wrapped response', () async {
      when(() => mockDio.get('/aircraft-models/1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/aircraft-models/1'),
          statusCode: 200,
          data: {
            'success': true,
            'data': {'id': '1', 'name': 'A320', 'status': 'active'},
          },
        ),
      );

      final result = await dataSource.getAircraftModelById('1');
      expect(result.name, 'A320');
    });

    test('should return model from direct map', () async {
      when(() => mockDio.get('/aircraft-models/1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/aircraft-models/1'),
          statusCode: 200,
          data: {'id': '1', 'name': 'B737'},
        ),
      );

      final result = await dataSource.getAircraftModelById('1');
      expect(result.name, 'B737');
    });

    test('should throw on unexpected format', () async {
      when(() => mockDio.get('/aircraft-models/1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/aircraft-models/1'),
          statusCode: 200,
          data: 'unexpected',
        ),
      );

      expect(
        () => dataSource.getAircraftModelById('1'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getAircraftModelsByFamily', () {
    test('should return models for family', () async {
      when(() => mockDio.get('/aircraft-families/A320')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/aircraft-families/A320'),
          statusCode: 200,
          data: {
            'success': true,
            'data': {
              'aircraft_models': [
                {'id': '1', 'name': 'A320-200'},
                {'id': '2', 'name': 'A320neo'},
              ],
            },
          },
        ),
      );

      final result = await dataSource.getAircraftModelsByFamily('A320');
      expect(result.length, 2);
    });

    test('should return empty list on error with response', () async {
      when(() => mockDio.get('/aircraft-families/X')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/aircraft-families/X'),
          response: Response(
            requestOptions: RequestOptions(path: '/aircraft-families/X'),
            statusCode: 404,
          ),
        ),
      );

      final result = await dataSource.getAircraftModelsByFamily('X');
      expect(result, isEmpty);
    });

    test('should rethrow DioException without response', () async {
      when(() => mockDio.get('/aircraft-families/X')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/aircraft-families/X'),
        ),
      );

      expect(
        () => dataSource.getAircraftModelsByFamily('X'),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('activateAircraftModel', () {
    test('should return success response', () async {
      when(() => mockDio.patch('/aircraft-models/1/activate')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/aircraft-models/1/activate'),
          statusCode: 200,
          data: {
            'success': true,
            'code': 'MOD_AM_ACT_04201',
            'message': 'Activated',
            'data': {'id': '1', 'status': 'active', 'updated': true},
          },
        ),
      );

      final result = await dataSource.activateAircraftModel('1');
      expect(result.success, true);
      expect(result.status, 'active');
    });

    test(
      'should return error response on DioException with response',
      () async {
        when(() => mockDio.patch('/aircraft-models/1/activate')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/aircraft-models/1/activate'),
            response: Response(
              requestOptions: RequestOptions(
                path: '/aircraft-models/1/activate',
              ),
              statusCode: 400,
              data: {
                'success': false,
                'code': 'ERROR_01',
                'message': 'Already active',
              },
            ),
          ),
        );

        final result = await dataSource.activateAircraftModel('1');
        expect(result.success, false);
        expect(result.message, 'Already active');
      },
    );

    test('should rethrow DioException without response', () async {
      when(() => mockDio.patch('/aircraft-models/1/activate')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/aircraft-models/1/activate'),
        ),
      );

      expect(
        () => dataSource.activateAircraftModel('1'),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('deactivateAircraftModel', () {
    test('should return success response', () async {
      when(() => mockDio.patch('/aircraft-models/1/deactivate')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/aircraft-models/1/deactivate'),
          statusCode: 200,
          data: {
            'success': true,
            'code': 'MOD_AM_DEACT_04201',
            'message': 'Deactivated',
            'data': {'id': '1', 'status': 'inactive', 'updated': true},
          },
        ),
      );

      final result = await dataSource.deactivateAircraftModel('1');
      expect(result.success, true);
      expect(result.status, 'inactive');
    });

    test(
      'should return error response on DioException with response',
      () async {
        when(() => mockDio.patch('/aircraft-models/1/deactivate')).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: '/aircraft-models/1/deactivate',
            ),
            response: Response(
              requestOptions: RequestOptions(
                path: '/aircraft-models/1/deactivate',
              ),
              statusCode: 400,
              data: {
                'success': false,
                'code': 'ERROR_02',
                'message': 'Already inactive',
              },
            ),
          ),
        );

        final result = await dataSource.deactivateAircraftModel('1');
        expect(result.success, false);
      },
    );

    test('should rethrow DioException without response', () async {
      when(() => mockDio.patch('/aircraft-models/1/deactivate')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/aircraft-models/1/deactivate'),
        ),
      );

      expect(
        () => dataSource.deactivateAircraftModel('1'),
        throwsA(isA<DioException>()),
      );
    });
  });
}
