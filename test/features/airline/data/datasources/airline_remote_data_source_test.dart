import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airline/data/datasources/airline_remote_data_source.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_model.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AirlineRemoteDataSourceImpl datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = AirlineRemoteDataSourceImpl(dio: mockDio);
  });

  group('AirlineRemoteDataSourceImpl', () {
    group('getAirlines', () {
      test('should return list of AirlineModel on success', () async {
        // Arrange
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'data': {
                'airlines': [
                  {
                    'id': 'a1',
                    'name': 'Avianca',
                    'iata_code': 'AV',
                    'status': 'active',
                  },
                  {
                    'id': 'a2',
                    'name': 'LATAM',
                    'iata_code': 'LA',
                    'status': 'active',
                  },
                ],
              },
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airlines'),
          ),
        );

        // Act
        final result = await datasource.getAirlines();

        // Assert
        expect(result, isA<List<AirlineModel>>());
        expect(result.length, equals(2));
        expect(result[0].name, equals('Avianca'));
      });

      test('should return empty list on DioException with response', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'error': 'Not found'},
              statusCode: 404,
              requestOptions: RequestOptions(path: '/airlines'),
            ),
            requestOptions: RequestOptions(path: '/airlines'),
          ),
        );

        // Act
        final result = await datasource.getAirlines();

        // Assert
        expect(result, isEmpty);
      });

      test('should rethrow DioException without response', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: '/airlines'),
          ),
        );

        // Act & Assert
        expect(() => datasource.getAirlines(), throwsA(isA<DioException>()));
      });
    });

    group('getAirlineById', () {
      test('should return AirlineModel on success', () async {
        // Arrange
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'data': {
                'airline': {
                  'id': 'a1',
                  'name': 'Avianca',
                  'iata_code': 'AV',
                  'status': 'active',
                },
              },
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airlines/a1'),
          ),
        );

        // Act
        final result = await datasource.getAirlineById('a1');

        // Assert
        expect(result, isA<AirlineModel>());
        expect(result?.name, equals('Avianca'));
      });

      test('should return null on DioException with response', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'error': 'Not found'},
              statusCode: 404,
              requestOptions: RequestOptions(path: '/airlines/a1'),
            ),
            requestOptions: RequestOptions(path: '/airlines/a1'),
          ),
        );

        // Act
        final result = await datasource.getAirlineById('a1');

        // Assert
        expect(result, isNull);
      });
    });

    group('activateAirline', () {
      test('should return AirlineStatusResponseModel on success', () async {
        // Arrange
        when(() => mockDio.patch(any())).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'code': 'ACTIVATED',
              'message': 'Airline activated',
              'data': {'id': 'a1', 'status': 'active', 'updated': true},
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airlines/a1/activate'),
          ),
        );

        // Act
        final result = await datasource.activateAirline('a1');

        // Assert
        expect(result, isA<AirlineStatusResponseModel>());
        expect(result.success, isTrue);
      });

      test('should return error response on DioException', () async {
        // Arrange
        when(() => mockDio.patch(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'success': false, 'code': 'ERR', 'message': 'Error'},
              statusCode: 400,
              requestOptions: RequestOptions(path: '/airlines/a1/activate'),
            ),
            requestOptions: RequestOptions(path: '/airlines/a1/activate'),
          ),
        );

        // Act
        final result = await datasource.activateAirline('a1');

        // Assert
        expect(result.success, isFalse);
      });
    });

    group('deactivateAirline', () {
      test('should return AirlineStatusResponseModel on success', () async {
        // Arrange
        when(() => mockDio.patch(any())).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'code': 'DEACTIVATED',
              'message': 'Airline deactivated',
              'data': {'id': 'a1', 'status': 'inactive', 'updated': true},
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airlines/a1/deactivate'),
          ),
        );

        // Act
        final result = await datasource.deactivateAirline('a1');

        // Assert
        expect(result, isA<AirlineStatusResponseModel>());
        expect(result.success, isTrue);
      });

      test('should return error response on DioException', () async {
        // Arrange
        when(() => mockDio.patch(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'success': false, 'code': 'ERR', 'message': 'Error'},
              statusCode: 400,
              requestOptions: RequestOptions(path: '/airlines/a1/deactivate'),
            ),
            requestOptions: RequestOptions(path: '/airlines/a1/deactivate'),
          ),
        );

        // Act
        final result = await datasource.deactivateAirline('a1');

        // Assert
        expect(result.success, isFalse);
      });
    });

    group('getAirlines - parse fallbacks', () {
      test('should handle data as direct array', () async {
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'data': [
                {'id': 'a1', 'name': 'Avianca', 'status': 'active'},
              ],
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airlines'),
          ),
        );

        final result = await datasource.getAirlines();
        expect(result.length, 1);
      });

      test('should handle direct array response', () async {
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: [
              {'id': 'a1', 'name': 'Avianca', 'status': 'active'},
            ],
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airlines'),
          ),
        );

        final result = await datasource.getAirlines();
        expect(result.length, 1);
      });

      test('should return empty list for empty data object', () async {
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {'success': true, 'data': <String, dynamic>{}},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airlines'),
          ),
        );

        final result = await datasource.getAirlines();
        expect(result, isEmpty);
      });
    });

    group('getAirlineById - parse airline', () {
      test('should parse airline from data.airline', () async {
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'data': {
                'airline': {'id': 'a1', 'name': 'Avianca', 'status': 'active'},
              },
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airlines/a1'),
          ),
        );

        final result = await datasource.getAirlineById('a1');
        expect(result, isNotNull);
        expect(result!.name, 'Avianca');
      });

      test('should parse airline directly from data map', () async {
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'data': {'id': 'a1', 'name': 'LATAM', 'status': 'active'},
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airlines/a1'),
          ),
        );

        final result = await datasource.getAirlineById('a1');
        expect(result, isNotNull);
        expect(result!.name, 'LATAM');
      });
    });
  });
}
