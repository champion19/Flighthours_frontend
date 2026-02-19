import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/crew_member_type/data/datasources/crew_member_type_remote_data_source.dart';
import 'package:flight_hours_app/features/crew_member_type/data/models/crew_member_type_model.dart';
import 'package:flight_hours_app/features/crew_member_type/data/repositories/crew_member_type_repository_impl.dart';

class MockCrewMemberTypeRemoteDataSource extends Mock
    implements CrewMemberTypeRemoteDataSource {}

void main() {
  late MockCrewMemberTypeRemoteDataSource mockDataSource;
  late CrewMemberTypeRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockCrewMemberTypeRemoteDataSource();
    repository = CrewMemberTypeRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('getCrewMemberTypes', () {
    test('should return Right with list on success', () async {
      final types = [
        CrewMemberTypeModel(id: '1', name: 'Captain'),
        CrewMemberTypeModel(id: '2', name: 'First Officer'),
      ];
      when(
        () => mockDataSource.getCrewMemberTypes('captain'),
      ).thenAnswer((_) async => types);

      final result = await repository.getCrewMemberTypes('captain');

      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Should be Right'),
        (list) => expect(list.length, 2),
      );
    });

    test(
      'should return Left on DioException with response and data map',
      () async {
        when(() => mockDataSource.getCrewMemberTypes('captain')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/crew-member-types/captain'),
            response: Response(
              requestOptions: RequestOptions(
                path: '/crew-member-types/captain',
              ),
              statusCode: 500,
              data: {'message': 'Server error'},
            ),
          ),
        );

        final result = await repository.getCrewMemberTypes('captain');

        expect(result, isA<Left>());
        result.fold((failure) {
          expect(failure.message, 'Server error');
          expect(failure.statusCode, 500);
        }, (_) => fail('Should be Left'));
      },
    );

    test(
      'should return Left on DioException with response but non-map data',
      () async {
        when(() => mockDataSource.getCrewMemberTypes('captain')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/crew-member-types/captain'),
            response: Response(
              requestOptions: RequestOptions(
                path: '/crew-member-types/captain',
              ),
              statusCode: 503,
              data: 'Service Unavailable',
            ),
          ),
        );

        final result = await repository.getCrewMemberTypes('captain');

        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure.message, contains('Network error')),
          (_) => fail('Should be Left'),
        );
      },
    );

    test('should return Left on DioException without response', () async {
      when(() => mockDataSource.getCrewMemberTypes('captain')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/crew-member-types/captain'),
        ),
      );

      final result = await repository.getCrewMemberTypes('captain');

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure.message, contains('Network error')),
        (_) => fail('Should be Left'),
      );
    });

    test('should return Left on non-Dio exception', () async {
      when(
        () => mockDataSource.getCrewMemberTypes('captain'),
      ).thenThrow(Exception('Unknown'));

      final result = await repository.getCrewMemberTypes('captain');

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure.message, contains('Exception')),
        (_) => fail('Should be Left'),
      );
    });
  });
}
