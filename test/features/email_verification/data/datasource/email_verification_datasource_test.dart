import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/email_verification/data/datasource/email_verifcation_datasource.dart';
import 'package:flight_hours_app/features/email_verification/data/models/email_verification_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late EmailVerificationDatasource datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = EmailVerificationDatasource(dio: mockDio);
  });

  group('EmailVerificationDatasource', () {
    group('verifyEmail', () {
      test('should return EmailVerificationModel on success', () async {
        // Arrange
        const email = 'test@example.com';
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: {'emailconfirmed': true},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/verify-email'),
          ),
        );

        // Act
        final result = await datasource.verifyEmail(email);

        // Assert
        expect(result, isA<EmailVerificationModel>());
        verify(
          () => mockDio.post('/auth/verify-email', data: {'email': email}),
        ).called(1);
      });

      test('should throw Exception on DioException with response', () async {
        // Arrange
        const email = 'test@example.com';
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'error': 'Invalid email'},
              statusCode: 400,
              requestOptions: RequestOptions(path: '/auth/verify-email'),
            ),
            requestOptions: RequestOptions(path: '/auth/verify-email'),
          ),
        );

        // Act & Assert
        expect(
          () => datasource.verifyEmail(email),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to verify email'),
            ),
          ),
        );
      });

      test('should throw Exception on DioException without response', () async {
        // Arrange
        const email = 'test@example.com';
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
          DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: '/auth/verify-email'),
          ),
        );

        // Act & Assert
        expect(
          () => datasource.verifyEmail(email),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Connection error'),
            ),
          ),
        );
      });
    });
  });
}
