import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/register/data/datasources/register_datasource.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';

class MockDio extends Mock implements Dio {}

class MockEmployeeEntityRegister extends Mock
    implements EmployeeEntityRegister {}

void main() {
  group('RegisterException', () {
    test('should create with required fields', () {
      final exception = RegisterException(
        message: 'Registration failed',
        code: 'REG_ERR_001',
        statusCode: 409,
      );

      expect(exception.message, equals('Registration failed'));
      expect(exception.code, equals('REG_ERR_001'));
      expect(exception.statusCode, equals(409));
    });

    test('toString should return message', () {
      final exception = RegisterException(
        message: 'Duplicate email',
        code: 'DUPLICATE',
        statusCode: 409,
      );

      expect(exception.toString(), equals('Duplicate email'));
    });
  });

  group('RegisterDatasource', () {
    late MockDio mockDio;
    late RegisterDatasource datasource;

    setUp(() {
      mockDio = MockDio();
      datasource = RegisterDatasource(dio: mockDio);
    });

    EmployeeEntityRegister createTestEmployee() {
      return EmployeeEntityRegister(
        id: '',
        name: 'Test User',
        email: 'test@example.com',
        password: 'Password123!',
        idNumber: '123456789',
        fechaInicio: '2024-01-01T00:00:00.000Z',
        fechaFin: '2025-01-01T00:00:00.000Z',
      );
    }

    group('registerEmployee', () {
      test(
        'should return RegisterResponseModel on successful registration',
        () async {
          // Arrange
          final employee = createTestEmployee();
          when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
            (_) async => Response(
              data: {
                'success': true,
                'code': 'REGISTER_SUCCESS',
                'message': 'Usuario registrado exitosamente',
              },
              statusCode: 201,
              requestOptions: RequestOptions(path: '/register'),
            ),
          );

          // Act
          final result = await datasource.registerEmployee(employee);

          // Assert
          expect(result.success, isTrue);
          expect(result.code, equals('REGISTER_SUCCESS'));
          verify(
            () => mockDio.post('/register', data: any(named: 'data')),
          ).called(1);
        },
      );

      test('should throw RegisterException on non-success response', () async {
        // Arrange
        final employee = createTestEmployee();
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: {
              'success': false,
              'code': 'DUPLICATE_EMAIL',
              'message': 'Email already exists',
            },
            statusCode: 409,
            requestOptions: RequestOptions(path: '/register'),
          ),
        );

        // Act & Assert
        expect(
          () => datasource.registerEmployee(employee),
          throwsA(isA<RegisterException>()),
        );
      });

      test(
        'should throw RegisterException on DioException with response',
        () async {
          // Arrange
          final employee = createTestEmployee();
          when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
            DioException(
              type: DioExceptionType.badResponse,
              response: Response(
                data: {
                  'success': false,
                  'code': 'VALIDATION_ERROR',
                  'message': 'Invalid data',
                },
                statusCode: 400,
                requestOptions: RequestOptions(path: '/register'),
              ),
              requestOptions: RequestOptions(path: '/register'),
            ),
          );

          // Act & Assert
          expect(
            () => datasource.registerEmployee(employee),
            throwsA(
              isA<RegisterException>().having(
                (e) => e.code,
                'code',
                equals('VALIDATION_ERROR'),
              ),
            ),
          );
        },
      );

      test('should throw RegisterException on connection timeout', () async {
        // Arrange
        final employee = createTestEmployee();
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
          DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: '/register'),
          ),
        );

        // Act & Assert
        expect(
          () => datasource.registerEmployee(employee),
          throwsA(
            isA<RegisterException>().having(
              (e) => e.code,
              'code',
              equals('CONNECTION_ERROR'),
            ),
          ),
        );
      });

      test('should throw RegisterException on connection error', () async {
        // Arrange
        final employee = createTestEmployee();
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
          DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: '/register'),
          ),
        );

        // Act & Assert
        expect(
          () => datasource.registerEmployee(employee),
          throwsA(
            isA<RegisterException>().having(
              (e) => e.message,
              'message',
              contains('conexión'),
            ),
          ),
        );
      });

      test('should throw RegisterException on unexpected error', () async {
        // Arrange
        final employee = createTestEmployee();
        when(
          () => mockDio.post(any(), data: any(named: 'data')),
        ).thenThrow(Exception('Unexpected error'));

        // Act & Assert
        expect(
          () => datasource.registerEmployee(employee),
          throwsA(
            isA<RegisterException>().having(
              (e) => e.code,
              'code',
              equals('UNEXPECTED_ERROR'),
            ),
          ),
        );
      });
    });
  });
}
