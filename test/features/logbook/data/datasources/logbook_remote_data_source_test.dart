import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/logbook/data/datasources/logbook_remote_data_source.dart';
import 'package:flight_hours_app/features/logbook/data/models/daily_logbook_model.dart';
import 'package:flight_hours_app/features/logbook/data/models/logbook_detail_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late LogbookRemoteDataSourceImpl datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = LogbookRemoteDataSourceImpl(dio: mockDio);
  });

  group('LogbookRemoteDataSourceImpl', () {
    // ========== Daily Logbook Operations ==========

    group('getDailyLogbooks', () {
      test('should return list of DailyLogbookModel on success', () async {
        // Arrange
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {
              'daily_logbooks': [
                {
                  'id': 'lb1',
                  'log_date': '2024-01-15',
                  'book_page': 1,
                  'status': true,
                },
                {
                  'id': 'lb2',
                  'log_date': '2024-01-16',
                  'book_page': 2,
                  'status': true,
                },
              ],
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/daily-logbooks'),
          ),
        );

        // Act
        final result = await datasource.getDailyLogbooks();

        // Assert
        expect(result, isA<List<DailyLogbookModel>>());
        expect(result.length, equals(2));
      });

      test('should return empty list on DioException with response', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'error': 'Not found'},
              statusCode: 404,
              requestOptions: RequestOptions(path: '/daily-logbooks'),
            ),
            requestOptions: RequestOptions(path: '/daily-logbooks'),
          ),
        );

        // Act
        final result = await datasource.getDailyLogbooks();

        // Assert
        expect(result, isEmpty);
      });

      test('should rethrow DioException without response', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: '/daily-logbooks'),
          ),
        );

        // Act & Assert
        expect(
          () => datasource.getDailyLogbooks(),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('getDailyLogbookById', () {
      test('should return DailyLogbookModel on success', () async {
        // Arrange
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {
              'data': {
                'id': 'lb1',
                'log_date': '2024-01-15',
                'book_page': 1,
                'status': true,
              },
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/daily-logbooks/lb1'),
          ),
        );

        // Act
        final result = await datasource.getDailyLogbookById('lb1');

        // Assert
        expect(result, isA<DailyLogbookModel>());
      });

      test('should return null on DioException with response', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'error': 'Not found'},
              statusCode: 404,
              requestOptions: RequestOptions(path: '/daily-logbooks/lb1'),
            ),
            requestOptions: RequestOptions(path: '/daily-logbooks/lb1'),
          ),
        );

        // Act
        final result = await datasource.getDailyLogbookById('lb1');

        // Assert
        expect(result, isNull);
      });
    });

    group('createDailyLogbook', () {
      test('should return DailyLogbookModel on success', () async {
        // Arrange
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: {
              'data': {
                'id': 'lb1',
                'log_date': '2024-01-15',
                'book_page': 1,
                'status': true,
              },
            },
            statusCode: 201,
            requestOptions: RequestOptions(path: '/daily-logbooks'),
          ),
        );

        // Act
        final result = await datasource.createDailyLogbook(
          logDate: DateTime(2024, 1, 15),
          bookPage: 1,
        );

        // Assert
        expect(result, isA<DailyLogbookModel>());
      });

      test('should return null on DioException with response', () async {
        // Arrange
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'error': 'Bad request'},
              statusCode: 400,
              requestOptions: RequestOptions(path: '/daily-logbooks'),
            ),
            requestOptions: RequestOptions(path: '/daily-logbooks'),
          ),
        );

        // Act
        final result = await datasource.createDailyLogbook(
          logDate: DateTime(2024, 1, 15),
          bookPage: 1,
        );

        // Assert
        expect(result, isNull);
      });
    });

    group('updateDailyLogbook', () {
      test('should return DailyLogbookModel on success', () async {
        // Arrange
        when(() => mockDio.put(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: {
              'data': {
                'id': 'lb1',
                'log_date': '2024-01-15',
                'book_page': 2,
                'status': true,
              },
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/daily-logbooks/lb1'),
          ),
        );

        // Act
        final result = await datasource.updateDailyLogbook(
          id: 'lb1',
          logDate: DateTime(2024, 1, 15),
          bookPage: 2,
          status: true,
        );

        // Assert
        expect(result, isA<DailyLogbookModel>());
      });

      test('should return null on DioException with response', () async {
        // Arrange
        when(() => mockDio.put(any(), data: any(named: 'data'))).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'error': 'Not found'},
              statusCode: 404,
              requestOptions: RequestOptions(path: '/daily-logbooks/lb1'),
            ),
            requestOptions: RequestOptions(path: '/daily-logbooks/lb1'),
          ),
        );

        // Act
        final result = await datasource.updateDailyLogbook(
          id: 'lb1',
          logDate: DateTime(2024, 1, 15),
          bookPage: 2,
          status: true,
        );

        // Assert
        expect(result, isNull);
      });
    });

    group('deleteDailyLogbook', () {
      test('should return true on success', () async {
        // Arrange
        when(() => mockDio.delete(any())).thenAnswer(
          (_) async => Response(
            data: {'success': true},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/daily-logbooks/lb1'),
          ),
        );

        // Act
        final result = await datasource.deleteDailyLogbook('lb1');

        // Assert
        expect(result, isTrue);
      });

      test('should return false on DioException', () async {
        // Arrange
        when(() => mockDio.delete(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            requestOptions: RequestOptions(path: '/daily-logbooks/lb1'),
          ),
        );

        // Act
        final result = await datasource.deleteDailyLogbook('lb1');

        // Assert
        expect(result, isFalse);
      });
    });

    // ========== Logbook Detail Operations ==========

    group('getLogbookDetails', () {
      test('should return list of LogbookDetailModel on success', () async {
        // Arrange
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {
              'data': [
                {
                  'id': 'det1',
                  'daily_logbook_id': 'lb1',
                  'flight_number': 'AV001',
                },
              ],
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/daily-logbooks/lb1/details'),
          ),
        );

        // Act
        final result = await datasource.getLogbookDetails('lb1');

        // Assert
        expect(result, isA<List<LogbookDetailModel>>());
      });

      test('should return empty list on DioException with response', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'error': 'Not found'},
              statusCode: 404,
              requestOptions: RequestOptions(
                path: '/daily-logbooks/lb1/details',
              ),
            ),
            requestOptions: RequestOptions(path: '/daily-logbooks/lb1/details'),
          ),
        );

        // Act
        final result = await datasource.getLogbookDetails('lb1');

        // Assert
        expect(result, isEmpty);
      });
    });

    group('getLogbookDetailById', () {
      test('should return LogbookDetailModel on success', () async {
        // Arrange
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {
              'data': {
                'id': 'det1',
                'daily_logbook_id': 'lb1',
                'flight_number': 'AV001',
              },
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/daily-logbook-details/det1'),
          ),
        );

        // Act
        final result = await datasource.getLogbookDetailById('det1');

        // Assert
        expect(result, isA<LogbookDetailModel>());
      });

      test('should return null on DioException with response', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'error': 'Not found'},
              statusCode: 404,
              requestOptions: RequestOptions(
                path: '/daily-logbook-details/det1',
              ),
            ),
            requestOptions: RequestOptions(path: '/daily-logbook-details/det1'),
          ),
        );

        // Act
        final result = await datasource.getLogbookDetailById('det1');

        // Assert
        expect(result, isNull);
      });
    });

    group('createLogbookDetail', () {
      test('should return LogbookDetailModel on success', () async {
        // Arrange
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: {
              'data': {
                'id': 'det1',
                'daily_logbook_id': 'lb1',
                'flight_number': 'AV001',
              },
            },
            statusCode: 201,
            requestOptions: RequestOptions(path: '/daily-logbooks/lb1/details'),
          ),
        );

        // Act
        final result = await datasource.createLogbookDetail(
          dailyLogbookId: 'lb1',
          data: {'flight_number': 'AV001'},
        );

        // Assert
        expect(result, isA<LogbookDetailModel>());
      });

      test('should return null on DioException with response', () async {
        // Arrange
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'error': 'Bad request'},
              statusCode: 400,
              requestOptions: RequestOptions(
                path: '/daily-logbooks/lb1/details',
              ),
            ),
            requestOptions: RequestOptions(path: '/daily-logbooks/lb1/details'),
          ),
        );

        // Act
        final result = await datasource.createLogbookDetail(
          dailyLogbookId: 'lb1',
          data: {'flight_number': 'AV001'},
        );

        // Assert
        expect(result, isNull);
      });
    });

    group('updateLogbookDetail', () {
      test('should return LogbookDetailModel on success', () async {
        // Arrange
        when(() => mockDio.put(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: {
              'data': {
                'id': 'det1',
                'daily_logbook_id': 'lb1',
                'flight_number': 'AV002',
              },
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/daily-logbook-details/det1'),
          ),
        );

        // Act
        final result = await datasource.updateLogbookDetail(
          id: 'det1',
          data: {'flight_number': 'AV002'},
        );

        // Assert
        expect(result, isA<LogbookDetailModel>());
      });

      test('should return null on DioException with response', () async {
        // Arrange
        when(() => mockDio.put(any(), data: any(named: 'data'))).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'error': 'Not found'},
              statusCode: 404,
              requestOptions: RequestOptions(
                path: '/daily-logbook-details/det1',
              ),
            ),
            requestOptions: RequestOptions(path: '/daily-logbook-details/det1'),
          ),
        );

        // Act
        final result = await datasource.updateLogbookDetail(
          id: 'det1',
          data: {'flight_number': 'AV002'},
        );

        // Assert
        expect(result, isNull);
      });
    });

    group('deleteLogbookDetail', () {
      test('should return true on success', () async {
        // Arrange
        when(() => mockDio.delete(any())).thenAnswer(
          (_) async => Response(
            data: {'success': true},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/daily-logbook-details/det1'),
          ),
        );

        // Act
        final result = await datasource.deleteLogbookDetail('det1');

        // Assert
        expect(result, isTrue);
      });

      test('should return false on DioException', () async {
        // Arrange
        when(() => mockDio.delete(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            requestOptions: RequestOptions(path: '/daily-logbook-details/det1'),
          ),
        );

        // Act
        final result = await datasource.deleteLogbookDetail('det1');

        // Assert
        expect(result, isFalse);
      });
    });
  });
}
