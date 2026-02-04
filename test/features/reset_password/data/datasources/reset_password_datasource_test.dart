import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/reset_password/data/datasources/reset_password_datasource.dart';
import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late ResetPasswordDatasource datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = ResetPasswordDatasource(dio: mockDio);
  });

  group('ResetPasswordDatasource', () {
    group('requestPasswordReset', () {
      test('should return ResetPasswordEntity on successful request', () async {
        // Arrange
        const email = 'test@example.com';
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'code': 'PWD_RESET_SUCCESS',
              'message': 'Reset email sent successfully',
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/password-reset'),
          ),
        );

        // Act
        final result = await datasource.requestPasswordReset(email);

        // Assert
        expect(result, isA<ResetPasswordEntity>());
        expect(result.success, isTrue);
        expect(result.code, equals('PWD_RESET_SUCCESS'));
        verify(
          () => mockDio.post('/auth/password-reset', data: {'email': email}),
        ).called(1);
      });

      test('should throw ResetPasswordException on failed response', () async {
        // Arrange
        const email = 'invalid@example.com';
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: {
              'success': false,
              'code': 'USER_NOT_FOUND',
              'message': 'User not found',
            },
            statusCode: 400,
            requestOptions: RequestOptions(path: '/auth/password-reset'),
          ),
        );

        // Act & Assert
        expect(
          () => datasource.requestPasswordReset(email),
          throwsA(isA<ResetPasswordException>()),
        );
      });

      test(
        'should throw ResetPasswordException on DioException with response',
        () async {
          // Arrange
          const email = 'test@example.com';
          when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
            DioException(
              type: DioExceptionType.badResponse,
              response: Response(
                data: {
                  'success': false,
                  'code': 'SERVER_ERROR',
                  'message': 'Internal server error',
                },
                statusCode: 500,
                requestOptions: RequestOptions(path: '/auth/password-reset'),
              ),
              requestOptions: RequestOptions(path: '/auth/password-reset'),
            ),
          );

          // Act & Assert
          expect(
            () => datasource.requestPasswordReset(email),
            throwsA(isA<ResetPasswordException>()),
          );
        },
      );

      test(
        'should throw ResetPasswordException on connection timeout',
        () async {
          // Arrange
          const email = 'test@example.com';
          when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
            DioException(
              type: DioExceptionType.connectionTimeout,
              requestOptions: RequestOptions(path: '/auth/password-reset'),
            ),
          );

          // Act & Assert
          expect(
            () => datasource.requestPasswordReset(email),
            throwsA(
              isA<ResetPasswordException>().having(
                (e) => e.code,
                'code',
                equals('CONNECTION_ERROR'),
              ),
            ),
          );
        },
      );

      test('should throw ResetPasswordException on connection error', () async {
        // Arrange
        const email = 'test@example.com';
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
          DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: '/auth/password-reset'),
          ),
        );

        // Act & Assert
        expect(
          () => datasource.requestPasswordReset(email),
          throwsA(
            isA<ResetPasswordException>().having(
              (e) => e.message,
              'message',
              contains('Connection error'),
            ),
          ),
        );
      });

      test('should throw ResetPasswordException on unexpected error', () async {
        // Arrange
        const email = 'test@example.com';
        when(
          () => mockDio.post(any(), data: any(named: 'data')),
        ).thenThrow(Exception('Unexpected error'));

        // Act & Assert
        expect(
          () => datasource.requestPasswordReset(email),
          throwsA(
            isA<ResetPasswordException>().having(
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
