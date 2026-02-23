import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/aircraft_model/data/datasources/aircraft_model_remote_data_source.dart';
import 'package:flight_hours_app/features/aircraft_model/data/models/aircraft_model_model.dart';
import 'package:flight_hours_app/features/aircraft_model/data/models/aircraft_model_status_response_model.dart';
import 'package:flight_hours_app/features/aircraft_model/data/repositories/aircraft_model_repository_impl.dart';

class MockAircraftModelRemoteDataSource extends Mock
    implements AircraftModelRemoteDataSource {}

void main() {
  late MockAircraftModelRemoteDataSource mockDataSource;
  late AircraftModelRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockAircraftModelRemoteDataSource();
    repository = AircraftModelRepositoryImpl(remoteDataSource: mockDataSource);
  });

  // ========== getAircraftModels ==========

  group('getAircraftModels', () {
    test('should return Right with list on success', () async {
      final models = [
        AircraftModelModel.fromJson({
          'id': '1',
          'name': 'A320',
          'family': 'A320',
          'manufacturer': 'Airbus',
          'status': true,
        }),
      ];
      when(
        () => mockDataSource.getAircraftModels(),
      ).thenAnswer((_) async => models);

      final result = await repository.getAircraftModels();

      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Should be Right'),
        (list) => expect(list.length, 1),
      );
    });

    test('should return Left on DioException with response data map', () async {
      when(() => mockDataSource.getAircraftModels()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/aircraft-models'),
          response: Response(
            requestOptions: RequestOptions(path: '/aircraft-models'),
            statusCode: 500,
            data: {'message': 'Server error', 'code': 'ERR_500'},
          ),
        ),
      );

      final result = await repository.getAircraftModels();

      expect(result, isA<Left>());
      result.fold((failure) {
        expect(failure.message, 'Server error');
        expect(failure.statusCode, 500);
      }, (_) => fail('Should be Left'));
    });

    test('should return Left on DioException with non-map data', () async {
      when(() => mockDataSource.getAircraftModels()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/aircraft-models'),
          response: Response(
            requestOptions: RequestOptions(path: '/aircraft-models'),
            statusCode: 503,
            data: 'Service Unavailable',
          ),
        ),
      );

      final result = await repository.getAircraftModels();

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure.message, 'Server error'),
        (_) => fail('Should be Left'),
      );
    });

    test('should return Left on non-Dio exception', () async {
      when(
        () => mockDataSource.getAircraftModels(),
      ).thenThrow(Exception('Unknown'));

      final result = await repository.getAircraftModels();

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure.message, contains('Unexpected')),
        (_) => fail('Should be Left'),
      );
    });
  });

  // ========== getAircraftModelById ==========

  group('getAircraftModelById', () {
    test('should return Right with entity on success', () async {
      final model = AircraftModelModel.fromJson({
        'id': '1',
        'name': 'A320',
        'family': 'A320',
        'manufacturer': 'Airbus',
        'status': true,
      });
      when(
        () => mockDataSource.getAircraftModelById('1'),
      ).thenAnswer((_) async => model);

      final result = await repository.getAircraftModelById('1');

      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Should be Right'),
        (entity) => expect(entity.id, '1'),
      );
    });

    test('should return Left on error', () async {
      when(() => mockDataSource.getAircraftModelById('bad')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/aircraft-models/bad'),
          response: Response(
            requestOptions: RequestOptions(path: '/aircraft-models/bad'),
            statusCode: 404,
            data: {'message': 'Not found'},
          ),
        ),
      );

      final result = await repository.getAircraftModelById('bad');

      expect(result, isA<Left>());
    });
  });

  // ========== getAircraftModelsByFamily ==========

  group('getAircraftModelsByFamily', () {
    test('should return Right with list on success', () async {
      when(
        () => mockDataSource.getAircraftModelsByFamily('A320'),
      ).thenAnswer((_) async => []);

      final result = await repository.getAircraftModelsByFamily('A320');

      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Should be Right'),
        (list) => expect(list, isEmpty),
      );
    });

    test('should return Left on error', () async {
      when(
        () => mockDataSource.getAircraftModelsByFamily('bad'),
      ).thenThrow(Exception('fail'));

      final result = await repository.getAircraftModelsByFamily('bad');

      expect(result, isA<Left>());
    });
  });

  // ========== activateAircraftModel ==========

  group('activateAircraftModel', () {
    test('should return Right with response on success', () async {
      const response = AircraftModelStatusResponseModel(
        success: true,
        code: 'ACTIVATED',
        message: 'Model activated',
      );
      when(
        () => mockDataSource.activateAircraftModel('1'),
      ).thenAnswer((_) async => response);

      final result = await repository.activateAircraftModel('1');

      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Should be Right'),
        (resp) => expect(resp.success, true),
      );
    });

    test('should return Left on error', () async {
      when(() => mockDataSource.activateAircraftModel('1')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 409,
            data: {'message': 'Already active'},
          ),
        ),
      );

      final result = await repository.activateAircraftModel('1');

      expect(result, isA<Left>());
    });
  });

  // ========== deactivateAircraftModel ==========

  group('deactivateAircraftModel', () {
    test('should return Right with response on success', () async {
      const response = AircraftModelStatusResponseModel(
        success: true,
        code: 'DEACTIVATED',
        message: 'Model deactivated',
      );
      when(
        () => mockDataSource.deactivateAircraftModel('1'),
      ).thenAnswer((_) async => response);

      final result = await repository.deactivateAircraftModel('1');

      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Should be Right'),
        (resp) => expect(resp.success, true),
      );
    });

    test('should return Left on error', () async {
      when(() => mockDataSource.deactivateAircraftModel('1')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 409,
            data: {'message': 'Already inactive'},
          ),
        ),
      );

      final result = await repository.deactivateAircraftModel('1');

      expect(result, isA<Left>());
    });
  });
}
