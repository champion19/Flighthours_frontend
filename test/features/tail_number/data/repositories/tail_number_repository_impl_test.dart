import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/tail_number/data/datasources/tail_number_remote_data_source.dart';
import 'package:flight_hours_app/features/tail_number/data/models/tail_number_model.dart';
import 'package:flight_hours_app/features/tail_number/data/repositories/tail_number_repository_impl.dart';

class MockTailNumberRemoteDataSource extends Mock
    implements TailNumberRemoteDataSource {}

void main() {
  late MockTailNumberRemoteDataSource mockDataSource;
  late TailNumberRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockTailNumberRemoteDataSource();
    repository = TailNumberRepositoryImpl(mockDataSource);
  });

  group('listTailNumbers', () {
    test('should return Right with list on success', () async {
      const plates = [
        TailNumberModel(id: '1', tailNumber: 'HK-1333'),
        TailNumberModel(id: '2', tailNumber: 'HK-4567'),
      ];
      when(
        () => mockDataSource.listTailNumbers(),
      ).thenAnswer((_) async => plates);

      final result = await repository.listTailNumbers();

      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Should be Right'),
        (list) => expect(list.length, 2),
      );
    });

    test(
      'should return Left with Failure on DioException with response',
      () async {
        when(() => mockDataSource.listTailNumbers()).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/tail-numbers'),
            response: Response(
              requestOptions: RequestOptions(path: '/tail-numbers'),
              statusCode: 500,
              data: {'message': 'Server error', 'code': 'ERR_500'},
            ),
          ),
        );

        final result = await repository.listTailNumbers();

        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure.message, 'Server error'),
          (_) => fail('Should be Left'),
        );
      },
    );

    test(
      'should return Left with generic message on DioException without data map',
      () async {
        when(() => mockDataSource.listTailNumbers()).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/tail-numbers'),
            response: Response(
              requestOptions: RequestOptions(path: '/tail-numbers'),
              statusCode: 503,
              data: 'Service Unavailable',
            ),
          ),
        );

        final result = await repository.listTailNumbers();

        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure.message, 'Server error'),
          (_) => fail('Should be Left'),
        );
      },
    );

    test('should return Left on non-Dio exception', () async {
      when(
        () => mockDataSource.listTailNumbers(),
      ).thenThrow(Exception('Unknown'));

      final result = await repository.listTailNumbers();

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure.message, contains('Exception')),
        (_) => fail('Should be Left'),
      );
    });
  });

  group('getTailNumberByPlate', () {
    test('should return Right with entity on success', () async {
      const plate = TailNumberModel(id: '1', tailNumber: 'HK-1333');
      when(
        () => mockDataSource.getTailNumberByPlate('HK-1333'),
      ).thenAnswer((_) async => plate);

      final result = await repository.getTailNumberByPlate('HK-1333');

      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Should be Right'),
        (entity) => expect(entity.tailNumber, 'HK-1333'),
      );
    });

    test('should return Left on DioException with response', () async {
      when(() => mockDataSource.getTailNumberByPlate('INVALID')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/tail-numbers/INVALID'),
          response: Response(
            requestOptions: RequestOptions(path: '/tail-numbers/INVALID'),
            statusCode: 404,
            data: {'message': 'Not found'},
          ),
        ),
      );

      final result = await repository.getTailNumberByPlate('INVALID');

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure.message, 'Not found'),
        (_) => fail('Should be Left'),
      );
    });
  });
}
