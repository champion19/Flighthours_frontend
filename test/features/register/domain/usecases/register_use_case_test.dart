import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/register/data/models/register_response_model.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';
import 'package:flight_hours_app/features/register/domain/repositories/register_repository.dart';
import 'package:flight_hours_app/features/register/domain/usecases/register_use_case.dart';

// Mock class for RegisterRepository
class MockRegisterRepository extends Mock implements RegisterRepository {}

// Fake class for EmployeeEntityRegister
class FakeEmployeeEntityRegister extends Fake
    implements EmployeeEntityRegister {}

void main() {
  late RegisterUseCase useCase;
  late MockRegisterRepository mockRepository;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(FakeEmployeeEntityRegister());
  });

  setUp(() {
    mockRepository = MockRegisterRepository();
    useCase = RegisterUseCase(mockRepository);
  });

  group('RegisterUseCase', () {
    final testEmployee = EmployeeEntityRegister(
      id: '',
      name: 'John Doe',
      idNumber: '123456789',
      email: 'john@example.com',
      password: 'Password123!',
      fechaInicio: '2024-01-01',
      fechaFin: '2025-12-31',
      role: 'pilot',
    );

    final successResponse = RegisterResponseModel(
      success: true,
      code: 'REG_SUCCESS',
      message: 'Registration completed successfully',
    );

    test(
      'should call registerEmployee on repository with correct parameters',
      () async {
        // Arrange
        when(
          () => mockRepository.registerEmployee(any()),
        ).thenAnswer((_) async => successResponse);

        // Act
        final result = await useCase.call(testEmployee);

        // Assert
        verify(() => mockRepository.registerEmployee(testEmployee)).called(1);
        expect(result.success, isTrue);
      },
    );

    test('should return success response on successful registration', () async {
      // Arrange
      when(
        () => mockRepository.registerEmployee(any()),
      ).thenAnswer((_) async => successResponse);

      // Act
      final result = await useCase.call(testEmployee);

      // Assert
      expect(result.success, isTrue);
      expect(result.code, equals('REG_SUCCESS'));
      expect(result.message, equals('Registration completed successfully'));
    });

    test('should return error response on failed registration', () async {
      // Arrange
      final errorResponse = RegisterResponseModel(
        success: false,
        code: 'EMAIL_EXISTS',
        message: 'Email already registered',
      );

      when(
        () => mockRepository.registerEmployee(any()),
      ).thenAnswer((_) async => errorResponse);

      // Act
      final result = await useCase.call(testEmployee);

      // Assert
      expect(result.success, isFalse);
      expect(result.code, equals('EMAIL_EXISTS'));
    });

    test('should propagate exception when repository throws', () async {
      // Arrange
      when(
        () => mockRepository.registerEmployee(any()),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => useCase.call(testEmployee), throwsA(isA<Exception>()));
    });
  });
}
