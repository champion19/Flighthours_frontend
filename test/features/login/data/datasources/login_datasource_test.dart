import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/login/data/datasources/login_datasource.dart';
import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late LoginDatasource datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = LoginDatasource(dio: mockDio);
  });

  group('LoginDatasource', () {
    group('loginEmployee', () {
      test('should return LoginEntity on successful login', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'code': 'LOGIN_SUCCESS',
              'message': 'Login successful',
              'data': {
                'access_token': 'access_token_123',
                'refresh_token': 'refresh_token_456',
                'expires_in': 3600,
                'token_type': 'Bearer',
                'employee_id': 'emp_123',
              },
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/login'),
          ),
        );

        // Act
        final result = await datasource.loginEmployee(email, password);

        // Assert
        expect(result, isA<LoginEntity>());
        expect(result.accessToken, equals('access_token_123'));
        expect(result.refreshToken, equals('refresh_token_456'));
        expect(result.employeeId, equals('emp_123'));
        expect(result.email, equals(email));
        verify(
          () => mockDio.post(
            '/login',
            data: {'email': email, 'password': password},
          ),
        ).called(1);
      });

      test('should throw LoginException when response data is null', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'code': 'LOGIN_SUCCESS',
              'message': 'Login successful',
              'data': null,
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/login'),
          ),
        );

        // Act & Assert
        expect(
          () => datasource.loginEmployee(email, password),
          throwsA(
            isA<LoginException>().having(
              (e) => e.code,
              'code',
              equals('INVALID_RESPONSE'),
            ),
          ),
        );
      });

      test('should throw LoginException on failed response', () async {
        // Arrange
        const email = 'invalid@example.com';
        const password = 'wrongpass';
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: {
              'success': false,
              'code': 'INVALID_CREDENTIALS',
              'message': 'Invalid email or password',
            },
            statusCode: 401,
            requestOptions: RequestOptions(path: '/login'),
          ),
        );

        // Act & Assert
        expect(
          () => datasource.loginEmployee(email, password),
          throwsA(isA<LoginException>()),
        );
      });

      test(
        'should throw LoginException on DioException with response',
        () async {
          // Arrange
          const email = 'test@example.com';
          const password = 'password123';
          when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
            DioException(
              type: DioExceptionType.badResponse,
              response: Response(
                data: {
                  'success': false,
                  'code': 'MOD_KC_LOGIN_EMAIL_NOT_VERIFIED_ERR_00001',
                  'message': 'Email not verified',
                },
                statusCode: 401,
                requestOptions: RequestOptions(path: '/login'),
              ),
              requestOptions: RequestOptions(path: '/login'),
            ),
          );

          // Act & Assert
          expect(
            () => datasource.loginEmployee(email, password),
            throwsA(
              isA<LoginException>().having(
                (e) => e.isEmailNotVerified,
                'isEmailNotVerified',
                isTrue,
              ),
            ),
          );
        },
      );

      test('should throw LoginException on connection timeout', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
          DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: '/login'),
          ),
        );

        // Act & Assert
        expect(
          () => datasource.loginEmployee(email, password),
          throwsA(
            isA<LoginException>().having(
              (e) => e.code,
              'code',
              equals('CONNECTION_ERROR'),
            ),
          ),
        );
      });

      test('should throw LoginException on connection error', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
          DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: '/login'),
          ),
        );

        // Act & Assert
        expect(
          () => datasource.loginEmployee(email, password),
          throwsA(
            isA<LoginException>().having(
              (e) => e.code,
              'code',
              equals('CONNECTION_ERROR'),
            ),
          ),
        );
      });

      test('should throw LoginException on unexpected error', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        when(
          () => mockDio.post(any(), data: any(named: 'data')),
        ).thenThrow(Exception('Unexpected error'));

        // Act & Assert
        expect(
          () => datasource.loginEmployee(email, password),
          throwsA(
            isA<LoginException>().having(
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
