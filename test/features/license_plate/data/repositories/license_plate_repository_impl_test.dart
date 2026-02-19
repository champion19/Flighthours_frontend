import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/license_plate/data/datasources/license_plate_remote_data_source.dart';
import 'package:flight_hours_app/features/license_plate/data/models/license_plate_model.dart';
import 'package:flight_hours_app/features/license_plate/data/repositories/license_plate_repository_impl.dart';

class MockLicensePlateRemoteDataSource extends Mock
    implements LicensePlateRemoteDataSource {}

void main() {
  late MockLicensePlateRemoteDataSource mockDataSource;
  late LicensePlateRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockLicensePlateRemoteDataSource();
    repository = LicensePlateRepositoryImpl(mockDataSource);
  });

  group('listLicensePlates', () {
    test('should return Right with list on success', () async {
      const plates = [
        LicensePlateModel(id: '1', licensePlate: 'HK-1333'),
        LicensePlateModel(id: '2', licensePlate: 'HK-4567'),
      ];
      when(
        () => mockDataSource.listLicensePlates(),
      ).thenAnswer((_) async => plates);

      final result = await repository.listLicensePlates();

      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Should be Right'),
        (list) => expect(list.length, 2),
      );
    });

    test(
      'should return Left with Failure on DioException with response',
      () async {
        when(() => mockDataSource.listLicensePlates()).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/license-plates'),
            response: Response(
              requestOptions: RequestOptions(path: '/license-plates'),
              statusCode: 500,
              data: {'message': 'Server error', 'code': 'ERR_500'},
            ),
          ),
        );

        final result = await repository.listLicensePlates();

        expect(result, isA<Left>());
        result.fold((failure) {
          expect(failure.message, 'Server error');
          expect(failure.statusCode, 500);
        }, (_) => fail('Should be Left'));
      },
    );

    test(
      'should return Left with generic message on DioException without data map',
      () async {
        when(() => mockDataSource.listLicensePlates()).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/license-plates'),
            response: Response(
              requestOptions: RequestOptions(path: '/license-plates'),
              statusCode: 503,
              data: 'Service Unavailable',
            ),
          ),
        );

        final result = await repository.listLicensePlates();

        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure.message, 'Server error'),
          (_) => fail('Should be Left'),
        );
      },
    );

    test('should return Left on non-Dio exception', () async {
      when(
        () => mockDataSource.listLicensePlates(),
      ).thenThrow(Exception('Unknown'));

      final result = await repository.listLicensePlates();

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure.message, contains('Unexpected')),
        (_) => fail('Should be Left'),
      );
    });
  });

  group('getLicensePlateByPlate', () {
    test('should return Right with entity on success', () async {
      const plate = LicensePlateModel(id: '1', licensePlate: 'HK-1333');
      when(
        () => mockDataSource.getLicensePlateByPlate('HK-1333'),
      ).thenAnswer((_) async => plate);

      final result = await repository.getLicensePlateByPlate('HK-1333');

      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Should be Right'),
        (entity) => expect(entity.licensePlate, 'HK-1333'),
      );
    });

    test('should return Left on DioException with response', () async {
      when(() => mockDataSource.getLicensePlateByPlate('INVALID')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/license-plates/INVALID'),
          response: Response(
            requestOptions: RequestOptions(path: '/license-plates/INVALID'),
            statusCode: 404,
            data: {'message': 'Not found'},
          ),
        ),
      );

      final result = await repository.getLicensePlateByPlate('INVALID');

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure.message, 'Not found'),
        (_) => fail('Should be Left'),
      );
    });
  });
}
