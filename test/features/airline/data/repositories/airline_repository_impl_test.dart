import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airline/data/datasources/airline_remote_data_source.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_model.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';
import 'package:flight_hours_app/features/airline/data/repositories/airline_repository_impl.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';

class MockAirlineRemoteDataSource extends Mock
    implements AirlineRemoteDataSource {}

void main() {
  late MockAirlineRemoteDataSource mockDataSource;
  late AirlineRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockAirlineRemoteDataSource();
    repository = AirlineRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('AirlineRepositoryImpl', () {
    group('getAirlines', () {
      test('should return Right with list from datasource', () async {
        final airlines = <AirlineModel>[
          const AirlineModel(id: 'a1', name: 'Avianca', code: 'AV'),
          const AirlineModel(id: 'a2', name: 'Latam', code: 'LA'),
        ];
        when(
          () => mockDataSource.getAirlines(),
        ).thenAnswer((_) async => airlines);

        final result = await repository.getAirlines();

        expect(result, isA<Right>());
        result.fold((failure) => fail('Expected Right'), (data) {
          expect(data, isA<List<AirlineEntity>>());
          expect(data.length, equals(2));
        });
        verify(() => mockDataSource.getAirlines()).called(1);
      });

      test('should return Left on exception', () async {
        when(() => mockDataSource.getAirlines()).thenThrow(Exception('Error'));

        final result = await repository.getAirlines();

        expect(result, isA<Left>());
      });
    });

    group('getAirlineById', () {
      test('should return Right with entity from datasource', () async {
        const airline = AirlineModel(id: 'a1', name: 'Avianca', code: 'AV');
        when(
          () => mockDataSource.getAirlineById(any()),
        ).thenAnswer((_) async => airline);

        final result = await repository.getAirlineById('a1');

        expect(result, isA<Right>());
        result.fold((failure) => fail('Expected Right'), (data) {
          expect(data, isA<AirlineEntity>());
          expect(data.name, equals('Avianca'));
        });
        verify(() => mockDataSource.getAirlineById('a1')).called(1);
      });

      test('should return Left when not found', () async {
        when(
          () => mockDataSource.getAirlineById(any()),
        ).thenAnswer((_) async => null);

        final result = await repository.getAirlineById('notfound');

        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure.statusCode, 404),
          (data) => fail('Expected Left'),
        );
      });
    });

    group('activateAirline', () {
      test(
        'should return Right with status response from datasource',
        () async {
          final response = AirlineStatusResponseModel(
            success: true,
            code: 'ACTIVATED',
            message: 'Airline activated',
          );
          when(
            () => mockDataSource.activateAirline(any()),
          ).thenAnswer((_) async => response);

          final result = await repository.activateAirline('a1');

          expect(result, isA<Right>());
          result.fold((failure) => fail('Expected Right'), (data) {
            expect(data, isA<AirlineStatusResponseModel>());
            expect(data.success, isTrue);
          });
          verify(() => mockDataSource.activateAirline('a1')).called(1);
        },
      );
    });

    group('deactivateAirline', () {
      test(
        'should return Right with status response from datasource',
        () async {
          final response = AirlineStatusResponseModel(
            success: true,
            code: 'DEACTIVATED',
            message: 'Airline deactivated',
          );
          when(
            () => mockDataSource.deactivateAirline(any()),
          ).thenAnswer((_) async => response);

          final result = await repository.deactivateAirline('a1');

          expect(result, isA<Right>());
          result.fold((failure) => fail('Expected Right'), (data) {
            expect(data, isA<AirlineStatusResponseModel>());
            expect(data.success, isTrue);
          });
          verify(() => mockDataSource.deactivateAirline('a1')).called(1);
        },
      );
    });
  });
}
