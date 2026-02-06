import 'package:bloc_test/bloc_test.dart';
import 'package:flight_hours_app/features/manufacturer/domain/entities/manufacturer_entity.dart';
import 'package:flight_hours_app/features/manufacturer/domain/usecases/get_manufacturers.dart';
import 'package:flight_hours_app/features/manufacturer/domain/usecases/get_manufacturer_by_id.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/bloc/manufacturer_bloc.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/bloc/manufacturer_event.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/bloc/manufacturer_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetManufacturers extends Mock implements GetManufacturers {}

class MockGetManufacturerById extends Mock implements GetManufacturerById {}

void main() {
  late ManufacturerBloc bloc;
  late MockGetManufacturers mockGetManufacturers;
  late MockGetManufacturerById mockGetManufacturerById;

  setUp(() {
    mockGetManufacturers = MockGetManufacturers();
    mockGetManufacturerById = MockGetManufacturerById();
    bloc = ManufacturerBloc(
      getManufacturers: mockGetManufacturers,
      getManufacturerById: mockGetManufacturerById,
    );
  });

  tearDown(() {
    bloc.close();
  });

  final testManufacturers = [
    const ManufacturerEntity(id: '1', name: 'Boeing'),
    const ManufacturerEntity(id: '2', name: 'Airbus'),
  ];

  const testManufacturer = ManufacturerEntity(
    id: 'test-id',
    name: 'Embraer',
    country: 'Brazil',
  );

  group('ManufacturerBloc', () {
    test('initial state is ManufacturerInitial', () {
      expect(bloc.state, isA<ManufacturerInitial>());
    });

    group('FetchManufacturers', () {
      blocTest<ManufacturerBloc, ManufacturerState>(
        'emits [Loading, Success] when fetch succeeds',
        build: () {
          when(
            () => mockGetManufacturers(),
          ).thenAnswer((_) async => testManufacturers);
          return bloc;
        },
        act: (bloc) => bloc.add(FetchManufacturers()),
        expect:
            () => [
              isA<ManufacturerLoading>(),
              isA<ManufacturerSuccess>().having(
                (s) => s.manufacturers,
                'manufacturers',
                testManufacturers,
              ),
            ],
      );

      blocTest<ManufacturerBloc, ManufacturerState>(
        'emits [Loading, Success] with empty list when no manufacturers',
        build: () {
          when(() => mockGetManufacturers()).thenAnswer((_) async => []);
          return bloc;
        },
        act: (bloc) => bloc.add(FetchManufacturers()),
        expect:
            () => [
              isA<ManufacturerLoading>(),
              isA<ManufacturerSuccess>().having(
                (s) => s.manufacturers,
                'manufacturers',
                isEmpty,
              ),
            ],
      );

      blocTest<ManufacturerBloc, ManufacturerState>(
        'emits [Loading, Error] when fetch fails',
        build: () {
          when(
            () => mockGetManufacturers(),
          ).thenThrow(Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(FetchManufacturers()),
        expect:
            () => [
              isA<ManufacturerLoading>(),
              isA<ManufacturerError>().having(
                (s) => s.message,
                'message',
                contains('Failed to load manufacturers'),
              ),
            ],
      );
    });

    group('GetManufacturerDetail', () {
      blocTest<ManufacturerBloc, ManufacturerState>(
        'emits [Loading, DetailSuccess] when get by id succeeds',
        build: () {
          when(
            () => mockGetManufacturerById('test-id'),
          ).thenAnswer((_) async => testManufacturer);
          return bloc;
        },
        act:
            (bloc) => bloc.add(
              const GetManufacturerDetail(manufacturerId: 'test-id'),
            ),
        expect:
            () => [
              isA<ManufacturerLoading>(),
              isA<ManufacturerDetailSuccess>().having(
                (s) => s.manufacturer,
                'manufacturer',
                testManufacturer,
              ),
            ],
      );

      blocTest<ManufacturerBloc, ManufacturerState>(
        'emits [Loading, Error] when manufacturer not found',
        build: () {
          when(
            () => mockGetManufacturerById('not-found'),
          ).thenAnswer((_) async => null);
          return bloc;
        },
        act:
            (bloc) => bloc.add(
              const GetManufacturerDetail(manufacturerId: 'not-found'),
            ),
        expect:
            () => [
              isA<ManufacturerLoading>(),
              isA<ManufacturerError>().having(
                (s) => s.message,
                'message',
                'Manufacturer not found',
              ),
            ],
      );

      blocTest<ManufacturerBloc, ManufacturerState>(
        'emits [Loading, Error] when get by id fails',
        build: () {
          when(
            () => mockGetManufacturerById(any()),
          ).thenThrow(Exception('Network error'));
          return bloc;
        },
        act:
            (bloc) => bloc.add(
              const GetManufacturerDetail(manufacturerId: 'test-id'),
            ),
        expect:
            () => [
              isA<ManufacturerLoading>(),
              isA<ManufacturerError>().having(
                (s) => s.message,
                'message',
                contains('Failed to load manufacturer'),
              ),
            ],
      );
    });
  });

  group('ManufacturerEvent', () {
    test('FetchManufacturers props are empty', () {
      expect(FetchManufacturers().props, isEmpty);
    });

    test('GetManufacturerDetail props contain manufacturerId', () {
      const event = GetManufacturerDetail(manufacturerId: 'test-id');
      expect(event.props, contains('test-id'));
    });
  });

  group('ManufacturerState', () {
    test('ManufacturerInitial props are empty', () {
      expect(ManufacturerInitial().props, isEmpty);
    });

    test('ManufacturerLoading props are empty', () {
      expect(ManufacturerLoading().props, isEmpty);
    });

    test('ManufacturerSuccess props contain manufacturers list', () {
      final state = ManufacturerSuccess(manufacturers: testManufacturers);
      expect(state.props, contains(testManufacturers));
    });

    test('ManufacturerDetailSuccess props contain manufacturer', () {
      const state = ManufacturerDetailSuccess(manufacturer: testManufacturer);
      expect(state.props, contains(testManufacturer));
    });

    test('ManufacturerError props contain message', () {
      const state = ManufacturerError(message: 'Test error');
      expect(state.props, contains('Test error'));
    });
  });
}
