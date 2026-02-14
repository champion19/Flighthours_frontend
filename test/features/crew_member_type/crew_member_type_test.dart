import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/crew_member_type/domain/entities/crew_member_type_entity.dart';
import 'package:flight_hours_app/features/crew_member_type/domain/repositories/crew_member_type_repository.dart';
import 'package:flight_hours_app/features/crew_member_type/domain/usecases/list_crew_member_types_use_case.dart';
import 'package:flight_hours_app/features/crew_member_type/presentation/bloc/crew_member_type_bloc.dart';
import 'package:flight_hours_app/features/crew_member_type/presentation/bloc/crew_member_type_event.dart';
import 'package:flight_hours_app/features/crew_member_type/presentation/bloc/crew_member_type_state.dart';

class MockCrewMemberTypeRepository extends Mock
    implements CrewMemberTypeRepository {}

class MockListCrewMemberTypesUseCase extends Mock
    implements ListCrewMemberTypesUseCase {}

void main() {
  // ========== Event Tests ==========
  group('CrewMemberTypeEvent', () {
    test('FetchCrewMemberTypes should contain role', () {
      const event = FetchCrewMemberTypes('pilot');
      expect(event, isA<CrewMemberTypeEvent>());
      expect(event.role, 'pilot');
      expect(event.props.length, equals(1));
    });
  });

  // ========== State Tests ==========
  group('CrewMemberTypeState', () {
    test('CrewMemberTypeInitial should be a valid state', () {
      const state = CrewMemberTypeInitial();
      expect(state, isA<CrewMemberTypeState>());
      expect(state.props, isEmpty);
    });

    test('CrewMemberTypeLoading should be a valid state', () {
      const state = CrewMemberTypeLoading();
      expect(state, isA<CrewMemberTypeState>());
    });

    test('CrewMemberTypesLoaded should contain types', () {
      const types = [
        CrewMemberTypeEntity(id: '1', name: 'Captain'),
        CrewMemberTypeEntity(id: '2', name: 'First Officer'),
      ];
      const state = CrewMemberTypesLoaded(types);
      expect(state.types.length, equals(2));
      expect(state.props.length, equals(1));
    });

    test('CrewMemberTypeError should contain message', () {
      const state = CrewMemberTypeError('Network error');
      expect(state.message, equals('Network error'));
      expect(state.props.length, equals(1));
    });
  });

  // ========== Entity Tests ==========
  group('CrewMemberTypeEntity', () {
    test('isActive should return true for active status', () {
      const entity = CrewMemberTypeEntity(id: '1', status: 'active');
      expect(entity.isActive, isTrue);
    });

    test('isActive should return false for inactive status', () {
      const entity = CrewMemberTypeEntity(id: '1', status: 'inactive');
      expect(entity.isActive, isFalse);
    });

    test('displayStatus should return Active or Inactive', () {
      const active = CrewMemberTypeEntity(id: '1', status: 'active');
      const inactive = CrewMemberTypeEntity(id: '2', status: 'inactive');
      expect(active.displayStatus, 'Active');
      expect(inactive.displayStatus, 'Inactive');
    });
  });

  // ========== UseCase Tests ==========
  group('ListCrewMemberTypesUseCase', () {
    late MockCrewMemberTypeRepository mockRepository;
    late ListCrewMemberTypesUseCase useCase;

    setUp(() {
      mockRepository = MockCrewMemberTypeRepository();
      useCase = ListCrewMemberTypesUseCase(repository: mockRepository);
    });

    test('should return Right with list of types on success', () async {
      const types = [
        CrewMemberTypeEntity(id: '1', name: 'Captain'),
        CrewMemberTypeEntity(id: '2', name: 'First Officer'),
      ];
      when(
        () => mockRepository.getCrewMemberTypes('pilot'),
      ).thenAnswer((_) async => const Right(types));

      final result = await useCase.call('pilot');

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.length, equals(2)),
      );
      verify(() => mockRepository.getCrewMemberTypes('pilot')).called(1);
    });

    test('should return Left on failure', () async {
      when(
        () => mockRepository.getCrewMemberTypes('pilot'),
      ).thenAnswer((_) async => const Left(Failure(message: 'Network error')));

      final result = await useCase.call('pilot');

      expect(result, isA<Left>());
    });
  });

  // ========== BLoC Tests ==========
  group('CrewMemberTypeBloc', () {
    late MockListCrewMemberTypesUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockListCrewMemberTypesUseCase();
    });

    CrewMemberTypeBloc buildBloc() {
      return CrewMemberTypeBloc(listCrewMemberTypesUseCase: mockUseCase);
    }

    test('initial state should be CrewMemberTypeInitial', () {
      final bloc = buildBloc();
      expect(bloc.state, isA<CrewMemberTypeInitial>());
    });

    blocTest<CrewMemberTypeBloc, CrewMemberTypeState>(
      'emits [Loading, Loaded] when FetchCrewMemberTypes succeeds',
      setUp: () {
        when(() => mockUseCase.call(any())).thenAnswer(
          (_) async =>
              const Right([CrewMemberTypeEntity(id: '1', name: 'Captain')]),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const FetchCrewMemberTypes('pilot')),
      expect:
          () => [isA<CrewMemberTypeLoading>(), isA<CrewMemberTypesLoaded>()],
    );

    blocTest<CrewMemberTypeBloc, CrewMemberTypeState>(
      'emits [Loading, Error] when FetchCrewMemberTypes fails',
      setUp: () {
        when(() => mockUseCase.call(any())).thenAnswer(
          (_) async => const Left(Failure(message: 'Network error')),
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const FetchCrewMemberTypes('pilot')),
      expect: () => [isA<CrewMemberTypeLoading>(), isA<CrewMemberTypeError>()],
    );

    blocTest<CrewMemberTypeBloc, CrewMemberTypeState>(
      'emits [Loading, Loaded] with empty list when no types found',
      setUp: () {
        when(
          () => mockUseCase.call(any()),
        ).thenAnswer((_) async => const Right([]));
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const FetchCrewMemberTypes('cabin_crew')),
      expect:
          () => [isA<CrewMemberTypeLoading>(), isA<CrewMemberTypesLoaded>()],
      verify: (bloc) {
        final state = bloc.state as CrewMemberTypesLoaded;
        expect(state.types, isEmpty);
      },
    );
  });
}
