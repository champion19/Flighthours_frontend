import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/crew_member_type/data/datasources/crew_member_type_remote_data_source.dart';
import 'package:flight_hours_app/features/crew_member_type/data/models/crew_member_type_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late CrewMemberTypeRemoteDataSourceImpl datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = CrewMemberTypeRemoteDataSourceImpl(dio: mockDio);
  });

  group('getCrewMemberTypes', () {
    test('should return list from nested data.crew_member_types', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: {
            'success': true,
            'data': {
              'crew_member_types': [
                {'id': '1', 'name': 'Pilot'},
                {'id': '2', 'name': 'Co-Pilot'},
              ],
            },
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/crew-member-types/pilot'),
        ),
      );

      final result = await datasource.getCrewMemberTypes('pilot');

      expect(result.length, 2);
      expect(result[0], isA<CrewMemberTypeModel>());
      expect(result[0].name, 'Pilot');
      expect(result[1].name, 'Co-Pilot');
    });

    test('should return list from direct data array', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: {
            'data': [
              {'id': '1', 'name': 'Pilot'},
            ],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/crew-member-types/pilot'),
        ),
      );

      final result = await datasource.getCrewMemberTypes('pilot');
      expect(result.length, 1);
    });

    test('should return list from top-level array', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: [
            {'id': '1', 'name': 'Pilot'},
          ],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/crew-member-types/pilot'),
        ),
      );

      final result = await datasource.getCrewMemberTypes('pilot');
      expect(result.length, 1);
    });

    test('should return empty list for unrecognized format', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: {'unknown': 'data'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/crew-member-types/pilot'),
        ),
      );

      final result = await datasource.getCrewMemberTypes('pilot');
      expect(result, isEmpty);
    });
  });
}
