import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
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
        ).thenAnswer((_) async => Right(successResponse));

        // Act
        final result = await useCase.call(testEmployee);

        // Assert
        verify(() => mockRepository.registerEmployee(testEmployee)).called(1);
        expect(result, isA<Right>());
      },
    );

    test('should return Right with success response on registration', () async {
      // Arrange
      when(
        () => mockRepository.registerEmployee(any()),
      ).thenAnswer((_) async => Right(successResponse));

      // Act
      final result = await useCase.call(testEmployee);

      // Assert
      result.fold((failure) => fail('Expected Right'), (response) {
        expect(response.success, isTrue);
        expect(response.code, equals('REG_SUCCESS'));
        expect(response.message, equals('Registration completed successfully'));
      });
    });

    test('should return Left on failed registration', () async {
      // Arrange
      when(() => mockRepository.registerEmployee(any())).thenAnswer(
        (_) async => const Left(
          Failure(message: 'Email already registered', code: 'EMAIL_EXISTS'),
        ),
      );

      // Act
      final result = await useCase.call(testEmployee);

      // Assert
      result.fold((failure) {
        expect(failure.code, equals('EMAIL_EXISTS'));
      }, (data) => fail('Expected Left'));
    });

    test('should return Left when repository fails', () async {
      // Arrange
      when(
        () => mockRepository.registerEmployee(any()),
      ).thenAnswer((_) async => const Left(Failure(message: 'Network error')));

      // Act
      final result = await useCase.call(testEmployee);

      // Assert
      expect(result, isA<Left>());
    });
  });
}
