import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/activate_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/deactivate_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/repositories/airport_repository.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';

class MockAirportRepository extends Mock implements AirportRepository {}

void main() {
  late MockAirportRepository mockRepository;

  setUp(() {
    mockRepository = MockAirportRepository();
  });

  group('ActivateAirportUseCase', () {
    late ActivateAirportUseCase useCase;

    setUp(() {
      useCase = ActivateAirportUseCase(repository: mockRepository);
    });

    test('should call repository.activateAirport with correct id', () async {
      const testId = 'airport-123';
      const response = AirportStatusResponseModel(
        success: true,
        code: 'MOD_APT_ACTIVATE_00001',
        message: 'Airport activated',
      );
      when(
        () => mockRepository.activateAirport(testId),
      ).thenAnswer((_) async => const Right(response));

      final result = await useCase.call(testId);

      expect(result, isA<Right>());
      verify(() => mockRepository.activateAirport(testId)).called(1);
    });

    test(
      'should return Right with success response when activation succeeds',
      () async {
        const testId = 'airport-456';
        const response = AirportStatusResponseModel(
          success: true,
          code: 'MOD_APT_ACTIVATE_00001',
          message: 'Successfully activated',
        );
        when(
          () => mockRepository.activateAirport(testId),
        ).thenAnswer((_) async => const Right(response));

        final result = await useCase.call(testId);

        result.fold((failure) => fail('Expected Right'), (data) {
          expect(data.success, isTrue);
          expect(data.message, equals('Successfully activated'));
          expect(data.code, equals('MOD_APT_ACTIVATE_00001'));
        });
      },
    );

    test(
      'should return Right with error response when activation fails',
      () async {
        const testId = 'airport-789';
        const response = AirportStatusResponseModel(
          success: false,
          code: 'MOD_APT_ACTIVATE_ERR_00001',
          message: 'Activation failed',
        );
        when(
          () => mockRepository.activateAirport(testId),
        ).thenAnswer((_) async => const Right(response));

        final result = await useCase.call(testId);

        result.fold((failure) => fail('Expected Right'), (data) {
          expect(data.success, isFalse);
          expect(data.message, equals('Activation failed'));
        });
      },
    );
  });

  group('DeactivateAirportUseCase', () {
    late DeactivateAirportUseCase useCase;

    setUp(() {
      useCase = DeactivateAirportUseCase(repository: mockRepository);
    });

    test('should call repository.deactivateAirport with correct id', () async {
      const testId = 'airport-123';
      const response = AirportStatusResponseModel(
        success: true,
        code: 'MOD_APT_DEACTIVATE_00001',
        message: 'Airport deactivated',
      );
      when(
        () => mockRepository.deactivateAirport(testId),
      ).thenAnswer((_) async => const Right(response));

      final result = await useCase.call(testId);

      expect(result, isA<Right>());
      verify(() => mockRepository.deactivateAirport(testId)).called(1);
    });

    test(
      'should return Right with success response when deactivation succeeds',
      () async {
        const testId = 'airport-456';
        const response = AirportStatusResponseModel(
          success: true,
          code: 'MOD_APT_DEACTIVATE_00001',
          message: 'Successfully deactivated',
        );
        when(
          () => mockRepository.deactivateAirport(testId),
        ).thenAnswer((_) async => const Right(response));

        final result = await useCase.call(testId);

        result.fold((failure) => fail('Expected Right'), (data) {
          expect(data.success, isTrue);
          expect(data.message, equals('Successfully deactivated'));
        });
      },
    );

    test(
      'should return Right with error response when deactivation fails',
      () async {
        const testId = 'airport-789';
        const response = AirportStatusResponseModel(
          success: false,
          code: 'MOD_APT_DEACTIVATE_ERR_00001',
          message: 'Deactivation failed',
        );
        when(
          () => mockRepository.deactivateAirport(testId),
        ).thenAnswer((_) async => const Right(response));

        final result = await useCase.call(testId);

        result.fold((failure) => fail('Expected Right'), (data) {
          expect(data.success, isFalse);
          expect(data.message, equals('Deactivation failed'));
        });
      },
    );
  });
}
