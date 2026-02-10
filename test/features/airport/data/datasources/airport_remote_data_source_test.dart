import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airport/data/datasources/airport_remote_data_source.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_model.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AirportRemoteDataSourceImpl datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = AirportRemoteDataSourceImpl(dio: mockDio);
  });

  group('AirportRemoteDataSourceImpl', () {
    group('getAirports', () {
      test('should return list of AirportModel on success', () async {
        // Arrange
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'data': {
                'airports': [
                  {
                    'id': 'apt1',
                    'name': 'El Dorado',
                    'iata_code': 'BOG',
                    'city': 'Bogotá',
                    'country': 'Colombia',
                    'status': 'active',
                  },
                  {
                    'id': 'apt2',
                    'name': 'Alfonso Bonilla',
                    'iata_code': 'CLO',
                    'city': 'Cali',
                    'country': 'Colombia',
                    'status': 'active',
                  },
                ],
              },
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airports'),
          ),
        );

        // Act
        final result = await datasource.getAirports();

        // Assert
        expect(result, isA<List<AirportModel>>());
        expect(result.length, equals(2));
        expect(result[0].name, equals('El Dorado'));
      });

      test('should return empty list on DioException with response', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'error': 'Not found'},
              statusCode: 404,
              requestOptions: RequestOptions(path: '/airports'),
            ),
            requestOptions: RequestOptions(path: '/airports'),
          ),
        );

        // Act
        final result = await datasource.getAirports();

        // Assert
        expect(result, isEmpty);
      });

      test('should rethrow DioException without response', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: '/airports'),
          ),
        );

        // Act & Assert
        expect(() => datasource.getAirports(), throwsA(isA<DioException>()));
      });
    });

    group('getAirportById', () {
      test('should return AirportModel on success', () async {
        // Arrange
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'data': {
                'airport': {
                  'id': 'apt1',
                  'name': 'El Dorado',
                  'iata_code': 'BOG',
                  'city': 'Bogotá',
                  'country': 'Colombia',
                  'status': 'active',
                },
              },
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airports/apt1'),
          ),
        );

        // Act
        final result = await datasource.getAirportById('apt1');

        // Assert
        expect(result, isA<AirportModel>());
        expect(result?.name, equals('El Dorado'));
      });

      test('should return null on DioException with response', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'error': 'Not found'},
              statusCode: 404,
              requestOptions: RequestOptions(path: '/airports/apt1'),
            ),
            requestOptions: RequestOptions(path: '/airports/apt1'),
          ),
        );

        // Act
        final result = await datasource.getAirportById('apt1');

        // Assert
        expect(result, isNull);
      });
    });

    group('activateAirport', () {
      test('should return AirportStatusResponseModel on success', () async {
        // Arrange
        when(() => mockDio.patch(any())).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'code': 'ACTIVATED',
              'message': 'Airport activated',
              'data': {'id': 'apt1', 'status': 'active', 'updated': true},
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airports/apt1/activate'),
          ),
        );

        // Act
        final result = await datasource.activateAirport('apt1');

        // Assert
        expect(result, isA<AirportStatusResponseModel>());
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
              requestOptions: RequestOptions(path: '/airports/apt1/activate'),
            ),
            requestOptions: RequestOptions(path: '/airports/apt1/activate'),
          ),
        );

        // Act
        final result = await datasource.activateAirport('apt1');

        // Assert
        expect(result.success, isFalse);
      });
    });

    group('deactivateAirport', () {
      test('should return AirportStatusResponseModel on success', () async {
        // Arrange
        when(() => mockDio.patch(any())).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'code': 'DEACTIVATED',
              'message': 'Airport deactivated',
              'data': {'id': 'apt1', 'status': 'inactive', 'updated': true},
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airports/apt1/deactivate'),
          ),
        );

        // Act
        final result = await datasource.deactivateAirport('apt1');

        // Assert
        expect(result, isA<AirportStatusResponseModel>());
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
              requestOptions: RequestOptions(path: '/airports/apt1/deactivate'),
            ),
            requestOptions: RequestOptions(path: '/airports/apt1/deactivate'),
          ),
        );

        // Act
        final result = await datasource.deactivateAirport('apt1');

        // Assert
        expect(result.success, isFalse);
      });
    });

    group('getAirports - parse fallbacks', () {
      test('should handle data as direct array', () async {
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'data': [
                {'id': 'apt1', 'name': 'El Dorado', 'status': 'active'},
              ],
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airports'),
          ),
        );

        final result = await datasource.getAirports();
        expect(result.length, 1);
      });

      test('should handle direct array response', () async {
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: [
              {'id': 'apt1', 'name': 'El Dorado', 'status': 'active'},
            ],
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airports'),
          ),
        );

        final result = await datasource.getAirports();
        expect(result.length, 1);
      });

      test('should return empty list for empty data object', () async {
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {'success': true, 'data': <String, dynamic>{}},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airports'),
          ),
        );

        final result = await datasource.getAirports();
        expect(result, isEmpty);
      });
    });

    group('getAirportById - parse fallback', () {
      test('should parse airport directly from data map', () async {
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'data': {'id': 'apt1', 'name': 'El Dorado', 'status': 'active'},
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/airports/apt1'),
          ),
        );

        final result = await datasource.getAirportById('apt1');
        expect(result, isNotNull);
        expect(result!.name, 'El Dorado');
      });
    });
  });
}
