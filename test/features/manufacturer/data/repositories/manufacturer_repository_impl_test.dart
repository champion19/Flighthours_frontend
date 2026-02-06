import 'package:flight_hours_app/features/manufacturer/data/datasources/manufacturer_remote_data_source.dart';
import 'package:flight_hours_app/features/manufacturer/data/models/manufacturer_model.dart';
import 'package:flight_hours_app/features/manufacturer/data/repositories/manufacturer_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockManufacturerRemoteDataSource extends Mock
    implements ManufacturerRemoteDataSource {}

void main() {
  late ManufacturerRepositoryImpl repository;
  late MockManufacturerRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockManufacturerRemoteDataSource();
    repository = ManufacturerRepositoryImpl(remoteDataSource: mockDataSource);
  });

  final testManufacturers = [
    const ManufacturerModel(id: '1', name: 'Boeing'),
    const ManufacturerModel(id: '2', name: 'Airbus'),
  ];

  const testManufacturer = ManufacturerModel(
    id: 'test-id',
    name: 'Embraer',
    country: 'Brazil',
  );

  group('ManufacturerRepositoryImpl', () {
    group('getManufacturers', () {
      test('should return list of manufacturers from data source', () async {
        when(
          () => mockDataSource.getManufacturers(),
        ).thenAnswer((_) async => testManufacturers);

        final result = await repository.getManufacturers();

        expect(result, testManufacturers);
        verify(() => mockDataSource.getManufacturers()).called(1);
      });

      test('should return empty list when no manufacturers', () async {
        when(
          () => mockDataSource.getManufacturers(),
        ).thenAnswer((_) async => []);

        final result = await repository.getManufacturers();

        expect(result, isEmpty);
      });

      test('should propagate exception from data source', () async {
        when(
          () => mockDataSource.getManufacturers(),
        ).thenThrow(Exception('Network error'));

        expect(() => repository.getManufacturers(), throwsException);
      });
    });

    group('getManufacturerById', () {
      test('should return manufacturer from data source', () async {
        when(
          () => mockDataSource.getManufacturerById('test-id'),
        ).thenAnswer((_) async => testManufacturer);

        final result = await repository.getManufacturerById('test-id');

        expect(result, testManufacturer);
        verify(() => mockDataSource.getManufacturerById('test-id')).called(1);
      });

      test('should return null when manufacturer not found', () async {
        when(
          () => mockDataSource.getManufacturerById('not-found'),
        ).thenAnswer((_) async => null);

        final result = await repository.getManufacturerById('not-found');

        expect(result, isNull);
      });

      test('should propagate exception from data source', () async {
        when(
          () => mockDataSource.getManufacturerById(any()),
        ).thenThrow(Exception('Network error'));

        expect(
          () => repository.getManufacturerById('test-id'),
          throwsException,
        );
      });
    });
  });
}
