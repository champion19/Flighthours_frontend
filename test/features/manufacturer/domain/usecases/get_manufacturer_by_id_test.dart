import 'package:flight_hours_app/features/manufacturer/domain/entities/manufacturer_entity.dart';
import 'package:flight_hours_app/features/manufacturer/domain/repositories/manufacturer_repository.dart';
import 'package:flight_hours_app/features/manufacturer/domain/usecases/get_manufacturer_by_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockManufacturerRepository extends Mock
    implements ManufacturerRepository {}

void main() {
  late GetManufacturerById usecase;
  late MockManufacturerRepository mockRepository;

  setUp(() {
    mockRepository = MockManufacturerRepository();
    usecase = GetManufacturerById(mockRepository);
  });

  group('GetManufacturerById', () {
    const testManufacturer = ManufacturerEntity(
      id: 'test-id',
      name: 'Boeing',
      country: 'USA',
    );

    test('should get manufacturer by id from repository', () async {
      when(
        () => mockRepository.getManufacturerById('test-id'),
      ).thenAnswer((_) async => testManufacturer);

      final result = await usecase('test-id');

      expect(result, testManufacturer);
      verify(() => mockRepository.getManufacturerById('test-id')).called(1);
    });

    test('should return null when manufacturer not found', () async {
      when(
        () => mockRepository.getManufacturerById('not-found'),
      ).thenAnswer((_) async => null);

      final result = await usecase('not-found');

      expect(result, isNull);
    });

    test('should propagate exception from repository', () async {
      when(
        () => mockRepository.getManufacturerById(any()),
      ).thenThrow(Exception('Network error'));

      expect(() => usecase('test-id'), throwsException);
    });
  });
}
