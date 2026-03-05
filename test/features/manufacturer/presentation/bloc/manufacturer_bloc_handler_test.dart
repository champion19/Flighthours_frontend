import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/manufacturer/domain/entities/manufacturer_entity.dart';
import 'package:flight_hours_app/features/manufacturer/domain/usecases/get_manufacturers.dart';
import 'package:flight_hours_app/features/manufacturer/domain/usecases/get_manufacturer_by_id.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/bloc/manufacturer_bloc.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/bloc/manufacturer_event.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/bloc/manufacturer_state.dart';

class MockGetManufacturers extends Mock implements GetManufacturers {}

class MockGetManufacturerById extends Mock implements GetManufacturerById {}

void main() {
  late MockGetManufacturers mockGetManufacturers;
  late MockGetManufacturerById mockGetManufacturerById;

  setUp(() {
    mockGetManufacturers = MockGetManufacturers();
    mockGetManufacturerById = MockGetManufacturerById();
  });

  ManufacturerBloc buildBloc() => ManufacturerBloc(
    getManufacturers: mockGetManufacturers,
    getManufacturerById: mockGetManufacturerById,
  );

  group('FetchManufacturers', () {
    blocTest<ManufacturerBloc, ManufacturerState>(
      'emits [Loading, Success] on success',
      build: () {
        when(
          () => mockGetManufacturers(),
        ).thenAnswer((_) async => const Right(<ManufacturerEntity>[]));
        return buildBloc();
      },
      act: (bloc) => bloc.add(FetchManufacturers()),
      expect: () => [isA<ManufacturerLoading>(), isA<ManufacturerSuccess>()],
    );

    blocTest<ManufacturerBloc, ManufacturerState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockGetManufacturers()).thenAnswer(
          (_) async => const Left(Failure(message: 'Network error')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(FetchManufacturers()),
      expect:
          () => [
            isA<ManufacturerLoading>(),
            isA<ManufacturerError>().having(
              (s) => s.message,
              'message',
              'Network error',
            ),
          ],
    );
  });

  group('GetManufacturerDetail', () {
    blocTest<ManufacturerBloc, ManufacturerState>(
      'emits [Loading, DetailSuccess] on success',
      build: () {
        when(() => mockGetManufacturerById(any())).thenAnswer(
          (_) async => const Right(ManufacturerEntity(id: '1', name: 'Airbus')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const GetManufacturerDetail(manufacturerId: '1')),
      expect:
          () => [isA<ManufacturerLoading>(), isA<ManufacturerDetailSuccess>()],
    );

    blocTest<ManufacturerBloc, ManufacturerState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(
          () => mockGetManufacturerById(any()),
        ).thenAnswer((_) async => const Left(Failure(message: 'Not found')));
        return buildBloc();
      },
      act:
          (bloc) =>
              bloc.add(const GetManufacturerDetail(manufacturerId: 'bad')),
      expect:
          () => [
            isA<ManufacturerLoading>(),
            isA<ManufacturerError>().having(
              (s) => s.message,
              'message',
              'Not found',
            ),
          ],
    );
  });
}
