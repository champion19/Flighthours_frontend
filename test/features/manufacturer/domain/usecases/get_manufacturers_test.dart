import 'package:flight_hours_app/features/manufacturer/domain/entities/manufacturer_entity.dart';
import 'package:flight_hours_app/features/manufacturer/domain/repositories/manufacturer_repository.dart';
import 'package:flight_hours_app/features/manufacturer/domain/usecases/get_manufacturers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockManufacturerRepository extends Mock
    implements ManufacturerRepository {}

void main() {
  late GetManufacturers usecase;
  late MockManufacturerRepository mockRepository;

  setUp(() {
    mockRepository = MockManufacturerRepository();
    usecase = GetManufacturers(mockRepository);
  });

  group('GetManufacturers', () {
    final testManufacturers = [
      const ManufacturerEntity(id: '1', name: 'Boeing'),
      const ManufacturerEntity(id: '2', name: 'Airbus'),
    ];

    test('should get list of manufacturers from repository', () async {
      when(
        () => mockRepository.getManufacturers(),
      ).thenAnswer((_) async => testManufacturers);

      final result = await usecase();

      expect(result, testManufacturers);
      verify(() => mockRepository.getManufacturers()).called(1);
    });

    test('should return empty list when no manufacturers', () async {
      when(() => mockRepository.getManufacturers()).thenAnswer((_) async => []);

      final result = await usecase();

      expect(result, isEmpty);
    });

    test('should propagate exception from repository', () async {
      when(
        () => mockRepository.getManufacturers(),
      ).thenThrow(Exception('Network error'));

      expect(() => usecase(), throwsException);
    });
  });
}
