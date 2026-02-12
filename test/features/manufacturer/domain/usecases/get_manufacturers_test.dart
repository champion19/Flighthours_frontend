import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
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

    test(
      'should get Right with list of manufacturers from repository',
      () async {
        when(
          () => mockRepository.getManufacturers(),
        ).thenAnswer((_) async => Right(testManufacturers));

        final result = await usecase();

        expect(result, isA<Right>());
        result.fold(
          (failure) => fail('Expected Right'),
          (data) => expect(data, testManufacturers),
        );
        verify(() => mockRepository.getManufacturers()).called(1);
      },
    );

    test('should return Right with empty list when no manufacturers', () async {
      when(
        () => mockRepository.getManufacturers(),
      ).thenAnswer((_) async => const Right([]));

      final result = await usecase();

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data, isEmpty),
      );
    });

    test('should return Left when repository fails', () async {
      when(
        () => mockRepository.getManufacturers(),
      ).thenAnswer((_) async => const Left(Failure(message: 'Network error')));

      final result = await usecase();

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure.message, 'Network error'),
        (data) => fail('Expected Left'),
      );
    });
  });
}
