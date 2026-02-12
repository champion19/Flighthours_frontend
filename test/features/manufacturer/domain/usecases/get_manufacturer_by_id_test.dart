import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
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

    test('should get Right with manufacturer by id from repository', () async {
      when(
        () => mockRepository.getManufacturerById('test-id'),
      ).thenAnswer((_) async => const Right(testManufacturer));

      final result = await usecase('test-id');

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right'),
        (manufacturer) => expect(manufacturer, testManufacturer),
      );
      verify(() => mockRepository.getManufacturerById('test-id')).called(1);
    });

    test('should return Left when manufacturer not found', () async {
      when(() => mockRepository.getManufacturerById('not-found')).thenAnswer(
        (_) async => const Left(
          Failure(message: 'Manufacturer not found', statusCode: 404),
        ),
      );

      final result = await usecase('not-found');

      expect(result, isA<Left>());
    });

    test('should return Left when repository fails', () async {
      when(
        () => mockRepository.getManufacturerById(any()),
      ).thenAnswer((_) async => const Left(Failure(message: 'Network error')));

      final result = await usecase('test-id');

      expect(result, isA<Left>());
    });
  });
}
