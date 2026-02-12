import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airport/data/datasources/airport_remote_data_source.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_model.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';
import 'package:flight_hours_app/features/airport/data/repositories/airport_repository_impl.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';

class MockAirportRemoteDataSource extends Mock
    implements AirportRemoteDataSource {}

void main() {
  late MockAirportRemoteDataSource mockDataSource;
  late AirportRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockAirportRemoteDataSource();
    repository = AirportRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('AirportRepositoryImpl', () {
    group('getAirports', () {
      test('should return Right with list from datasource', () async {
        final airports = <AirportModel>[
          const AirportModel(
            id: 'ap1',
            name: 'El Dorado',
            iataCode: 'BOG',
            city: 'Bogota',
            country: 'Colombia',
          ),
          const AirportModel(
            id: 'ap2',
            name: 'Jose Maria Cordova',
            iataCode: 'MDE',
            city: 'Medellin',
            country: 'Colombia',
          ),
        ];
        when(
          () => mockDataSource.getAirports(),
        ).thenAnswer((_) async => airports);

        final result = await repository.getAirports();

        expect(result, isA<Right>());
        result.fold((failure) => fail('Expected Right'), (data) {
          expect(data, isA<List<AirportEntity>>());
          expect(data.length, equals(2));
        });
        verify(() => mockDataSource.getAirports()).called(1);
      });

      test('should return Left on exception', () async {
        when(() => mockDataSource.getAirports()).thenThrow(Exception('Error'));

        final result = await repository.getAirports();

        expect(result, isA<Left>());
      });
    });

    group('getAirportById', () {
      test('should return Right with entity from datasource', () async {
        const airport = AirportModel(
          id: 'ap1',
          name: 'El Dorado',
          iataCode: 'BOG',
          city: 'Bogota',
          country: 'Colombia',
        );
        when(
          () => mockDataSource.getAirportById(any()),
        ).thenAnswer((_) async => airport);

        final result = await repository.getAirportById('ap1');

        expect(result, isA<Right>());
        result.fold((failure) => fail('Expected Right'), (data) {
          expect(data, isA<AirportEntity>());
          expect(data.name, equals('El Dorado'));
        });
        verify(() => mockDataSource.getAirportById('ap1')).called(1);
      });

      test('should return Left when not found', () async {
        when(
          () => mockDataSource.getAirportById(any()),
        ).thenAnswer((_) async => null);

        final result = await repository.getAirportById('notfound');

        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure.statusCode, 404),
          (data) => fail('Expected Left'),
        );
      });
    });

    group('activateAirport', () {
      test(
        'should return Right with status response from datasource',
        () async {
          final response = AirportStatusResponseModel(
            success: true,
            code: 'ACTIVATED',
            message: 'Airport activated',
          );
          when(
            () => mockDataSource.activateAirport(any()),
          ).thenAnswer((_) async => response);

          final result = await repository.activateAirport('ap1');

          expect(result, isA<Right>());
          result.fold((failure) => fail('Expected Right'), (data) {
            expect(data, isA<AirportStatusResponseModel>());
            expect(data.success, isTrue);
          });
          verify(() => mockDataSource.activateAirport('ap1')).called(1);
        },
      );
    });

    group('deactivateAirport', () {
      test(
        'should return Right with status response from datasource',
        () async {
          final response = AirportStatusResponseModel(
            success: true,
            code: 'DEACTIVATED',
            message: 'Airport deactivated',
          );
          when(
            () => mockDataSource.deactivateAirport(any()),
          ).thenAnswer((_) async => response);

          final result = await repository.deactivateAirport('ap1');

          expect(result, isA<Right>());
          result.fold((failure) => fail('Expected Right'), (data) {
            expect(data, isA<AirportStatusResponseModel>());
            expect(data.success, isTrue);
          });
          verify(() => mockDataSource.deactivateAirport('ap1')).called(1);
        },
      );
    });
  });
}
