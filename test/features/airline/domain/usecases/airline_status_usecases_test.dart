import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/activate_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/deactivate_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/repositories/airline_repository.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';

class MockAirlineRepository extends Mock implements AirlineRepository {}

void main() {
  late MockAirlineRepository mockRepository;

  setUp(() {
    mockRepository = MockAirlineRepository();
  });

  group('ActivateAirlineUseCase', () {
    late ActivateAirlineUseCase useCase;

    setUp(() {
      useCase = ActivateAirlineUseCase(repository: mockRepository);
    });

    test('should call repository.activateAirline with correct id', () async {
      // Arrange
      const testId = 'airline-123';
      const response = AirlineStatusResponseModel(
        success: true,
        code: 'MOD_AIR_ACTIVATE_00001',
        message: 'Airline activated',
      );
      when(
        () => mockRepository.activateAirline(testId),
      ).thenAnswer((_) async => response);

      // Act
      final result = await useCase.call(testId);

      // Assert
      expect(result, equals(response));
      verify(() => mockRepository.activateAirline(testId)).called(1);
    });

    test('should return success response when activation succeeds', () async {
      // Arrange
      const testId = 'airline-456';
      const response = AirlineStatusResponseModel(
        success: true,
        code: 'MOD_AIR_ACTIVATE_00001',
        message: 'Successfully activated',
      );
      when(
        () => mockRepository.activateAirline(testId),
      ).thenAnswer((_) async => response);

      // Act
      final result = await useCase.call(testId);

      // Assert
      expect(result.success, isTrue);
      expect(result.message, equals('Successfully activated'));
      expect(result.code, equals('MOD_AIR_ACTIVATE_00001'));
    });

    test('should return error response when activation fails', () async {
      // Arrange
      const testId = 'airline-789';
      const response = AirlineStatusResponseModel(
        success: false,
        code: 'MOD_AIR_ACTIVATE_ERR_00001',
        message: 'Activation failed',
      );
      when(
        () => mockRepository.activateAirline(testId),
      ).thenAnswer((_) async => response);

      // Act
      final result = await useCase.call(testId);

      // Assert
      expect(result.success, isFalse);
      expect(result.message, equals('Activation failed'));
    });
  });

  group('DeactivateAirlineUseCase', () {
    late DeactivateAirlineUseCase useCase;

    setUp(() {
      useCase = DeactivateAirlineUseCase(repository: mockRepository);
    });

    test('should call repository.deactivateAirline with correct id', () async {
      // Arrange
      const testId = 'airline-123';
      const response = AirlineStatusResponseModel(
        success: true,
        code: 'MOD_AIR_DEACTIVATE_00001',
        message: 'Airline deactivated',
      );
      when(
        () => mockRepository.deactivateAirline(testId),
      ).thenAnswer((_) async => response);

      // Act
      final result = await useCase.call(testId);

      // Assert
      expect(result, equals(response));
      verify(() => mockRepository.deactivateAirline(testId)).called(1);
    });

    test('should return success response when deactivation succeeds', () async {
      // Arrange
      const testId = 'airline-456';
      const response = AirlineStatusResponseModel(
        success: true,
        code: 'MOD_AIR_DEACTIVATE_00001',
        message: 'Successfully deactivated',
      );
      when(
        () => mockRepository.deactivateAirline(testId),
      ).thenAnswer((_) async => response);

      // Act
      final result = await useCase.call(testId);

      // Assert
      expect(result.success, isTrue);
      expect(result.message, equals('Successfully deactivated'));
    });

    test('should return error response when deactivation fails', () async {
      // Arrange
      const testId = 'airline-789';
      const response = AirlineStatusResponseModel(
        success: false,
        code: 'MOD_AIR_DEACTIVATE_ERR_00001',
        message: 'Deactivation failed',
      );
      when(
        () => mockRepository.deactivateAirline(testId),
      ).thenAnswer((_) async => response);

      // Act
      final result = await useCase.call(testId);

      // Assert
      expect(result.success, isFalse);
      expect(result.message, equals('Deactivation failed'));
    });
  });
}
