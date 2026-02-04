import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/register/data/datasources/register_datasource.dart';
import 'package:flight_hours_app/features/register/data/models/register_response_model.dart';
import 'package:flight_hours_app/features/register/data/repositories/register_repository_impl.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';

class MockRegisterDatasource extends Mock implements RegisterDatasource {}

class FakeEmployeeEntityRegister extends Fake
    implements EmployeeEntityRegister {}

void main() {
  late MockRegisterDatasource mockDatasource;
  late RegisterRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeEmployeeEntityRegister());
  });

  setUp(() {
    mockDatasource = MockRegisterDatasource();
    repository = RegisterRepositoryImpl(mockDatasource);
  });

  group('RegisterRepositoryImpl', () {
    group('registerEmployee', () {
      test('should return RegisterResponseModel from datasource', () async {
        // Arrange
        final employee = EmployeeEntityRegister(
          id: '1',
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          idNumber: '12345678',
          fechaInicio: '2024-01-01',
          fechaFin: '2025-01-01',
        );
        final response = RegisterResponseModel(
          success: true,
          code: 'REGISTER_SUCCESS',
          message: 'Registration successful',
        );
        when(
          () => mockDatasource.registerEmployee(any()),
        ).thenAnswer((_) async => response);

        // Act
        final result = await repository.registerEmployee(employee);

        // Assert
        expect(result, isA<RegisterResponseModel>());
        expect(result.success, isTrue);
        verify(() => mockDatasource.registerEmployee(employee)).called(1);
      });

      test('should propagate exception from datasource', () async {
        // Arrange
        final employee = EmployeeEntityRegister(
          id: '1',
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          idNumber: '12345678',
          fechaInicio: '2024-01-01',
          fechaFin: '2025-01-01',
        );
        when(
          () => mockDatasource.registerEmployee(any()),
        ).thenThrow(Exception('Registration failed'));

        // Act & Assert
        expect(
          () => repository.registerEmployee(employee),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
