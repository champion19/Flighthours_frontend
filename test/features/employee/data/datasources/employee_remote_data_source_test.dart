import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/employee/data/datasources/employee_remote_data_source.dart';
import 'package:flight_hours_app/features/employee/data/models/change_password_model.dart';
import 'package:flight_hours_app/features/employee/data/models/delete_employee_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_routes_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_response_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late EmployeeRemoteDataSourceImpl datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = EmployeeRemoteDataSourceImpl(dio: mockDio);
  });

  group('EmployeeRemoteDataSourceImpl', () {
    group('getCurrentEmployee', () {
      test('should return EmployeeResponseModel on success', () async {
        // Arrange
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'code': 'OK',
              'message': 'Employee retrieved',
              'data': {
                'id': 'emp1',
                'name': 'John Doe',
                'email': 'john@example.com',
              },
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/employees'),
          ),
        );

        // Act
        final result = await datasource.getCurrentEmployee();

        // Assert
        expect(result, isA<EmployeeResponseModel>());
        expect(result.success, isTrue);
      });

      test('should return error response on DioException', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'success': false, 'code': 'ERR', 'message': 'Not found'},
              statusCode: 404,
              requestOptions: RequestOptions(path: '/employees'),
            ),
            requestOptions: RequestOptions(path: '/employees'),
          ),
        );

        // Act
        final result = await datasource.getCurrentEmployee();

        // Assert
        expect(result.success, isFalse);
      });

      test('should rethrow DioException without response', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: '/employees'),
          ),
        );

        // Act & Assert
        expect(
          () => datasource.getCurrentEmployee(),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('updateCurrentEmployee', () {
      test('should return EmployeeUpdateResponseModel on success', () async {
        // Arrange
        when(() => mockDio.put(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: {'success': true, 'code': 'OK', 'message': 'Updated'},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/employees'),
          ),
        );

        final request = EmployeeUpdateRequest(
          name: 'New Name',
          identificationNumber: '123456789',
        );

        // Act
        final result = await datasource.updateCurrentEmployee(request);

        // Assert
        expect(result, isA<EmployeeUpdateResponseModel>());
        expect(result.success, isTrue);
      });

      test('should return error response on DioException', () async {
        // Arrange
        when(() => mockDio.put(any(), data: any(named: 'data'))).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'success': false, 'code': 'ERR', 'message': 'Error'},
              statusCode: 400,
              requestOptions: RequestOptions(path: '/employees'),
            ),
            requestOptions: RequestOptions(path: '/employees'),
          ),
        );

        final request = EmployeeUpdateRequest(
          name: 'New Name',
          identificationNumber: '123456789',
        );

        // Act
        final result = await datasource.updateCurrentEmployee(request);

        // Assert
        expect(result.success, isFalse);
      });
    });

    group('changePassword', () {
      test('should return ChangePasswordResponseModel on success', () async {
        // Arrange
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'code': 'OK',
              'message': 'Password changed',
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/change-password'),
          ),
        );

        final request = ChangePasswordRequest(
          email: 'test@example.com',
          currentPassword: 'oldPass',
          newPassword: 'newPass',
          confirmPassword: 'newPass',
        );

        // Act
        final result = await datasource.changePassword(request);

        // Assert
        expect(result, isA<ChangePasswordResponseModel>());
        expect(result.success, isTrue);
      });

      test('should return error response on DioException', () async {
        // Arrange
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {
                'success': false,
                'code': 'ERR',
                'message': 'Wrong password',
              },
              statusCode: 401,
              requestOptions: RequestOptions(path: '/auth/change-password'),
            ),
            requestOptions: RequestOptions(path: '/auth/change-password'),
          ),
        );

        final request = ChangePasswordRequest(
          email: 'test@example.com',
          currentPassword: 'wrongPass',
          newPassword: 'newPass',
          confirmPassword: 'newPass',
        );

        // Act
        final result = await datasource.changePassword(request);

        // Assert
        expect(result.success, isFalse);
      });
    });

    group('deleteCurrentEmployee', () {
      test('should return DeleteEmployeeResponseModel on success', () async {
        // Arrange
        when(() => mockDio.delete(any())).thenAnswer(
          (_) async => Response(
            data: {'success': true, 'code': 'OK', 'message': 'Deleted'},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/employees'),
          ),
        );

        // Act
        final result = await datasource.deleteCurrentEmployee();

        // Assert
        expect(result, isA<DeleteEmployeeResponseModel>());
        expect(result.success, isTrue);
      });

      test('should return error response on DioException', () async {
        // Arrange
        when(() => mockDio.delete(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'success': false, 'code': 'ERR', 'message': 'Error'},
              statusCode: 400,
              requestOptions: RequestOptions(path: '/employees'),
            ),
            requestOptions: RequestOptions(path: '/employees'),
          ),
        );

        // Act
        final result = await datasource.deleteCurrentEmployee();

        // Assert
        expect(result.success, isFalse);
      });
    });

    group('getEmployeeAirline', () {
      test('should return EmployeeAirlineResponseModel on success', () async {
        // Arrange
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {
              'success': true,
              'code': 'OK',
              'message': 'Retrieved',
              'data': {'airline_id': 'a1', 'bp': 'BP001'},
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/employees/airline'),
          ),
        );

        // Act
        final result = await datasource.getEmployeeAirline();

        // Assert
        expect(result, isA<EmployeeAirlineResponseModel>());
        expect(result.success, isTrue);
      });

      test('should return error response on DioException', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'success': false, 'code': 'ERR', 'message': 'Not found'},
              statusCode: 404,
              requestOptions: RequestOptions(path: '/employees/airline'),
            ),
            requestOptions: RequestOptions(path: '/employees/airline'),
          ),
        );

        // Act
        final result = await datasource.getEmployeeAirline();

        // Assert
        expect(result.success, isFalse);
      });
    });

    group('updateEmployeeAirline', () {
      test('should return EmployeeAirlineResponseModel on success', () async {
        // Arrange
        when(() => mockDio.put(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: {'success': true, 'code': 'OK', 'message': 'Updated'},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/employees/airline'),
          ),
        );

        final request = EmployeeAirlineUpdateRequest(
          airlineId: 'a1',
          bp: 'BP002',
          startDate: '2024-01-01',
          endDate: '2025-01-01',
        );

        // Act
        final result = await datasource.updateEmployeeAirline(request);

        // Assert
        expect(result, isA<EmployeeAirlineResponseModel>());
        expect(result.success, isTrue);
      });

      test('should return error response on DioException', () async {
        // Arrange
        when(() => mockDio.put(any(), data: any(named: 'data'))).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'success': false, 'code': 'ERR', 'message': 'Error'},
              statusCode: 400,
              requestOptions: RequestOptions(path: '/employees/airline'),
            ),
            requestOptions: RequestOptions(path: '/employees/airline'),
          ),
        );

        final request = EmployeeAirlineUpdateRequest(
          airlineId: 'a1',
          bp: 'BP002',
          startDate: '2024-01-01',
          endDate: '2025-01-01',
        );

        // Act
        final result = await datasource.updateEmployeeAirline(request);

        // Assert
        expect(result.success, isFalse);
      });
    });

    group('getEmployeeAirlineRoutes', () {
      test(
        'should return EmployeeAirlineRoutesResponseModel on success',
        () async {
          // Arrange
          when(() => mockDio.get(any())).thenAnswer(
            (_) async => Response(
              data: {
                'success': true,
                'code': 'OK',
                'message': 'Routes retrieved',
                'data': [],
              },
              statusCode: 200,
              requestOptions: RequestOptions(path: '/employees/airline-routes'),
            ),
          );

          // Act
          final result = await datasource.getEmployeeAirlineRoutes();

          // Assert
          expect(result, isA<EmployeeAirlineRoutesResponseModel>());
          expect(result.success, isTrue);
        },
      );

      test('should return error response on DioException', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              data: {'success': false, 'code': 'ERR', 'message': 'Not found'},
              statusCode: 404,
              requestOptions: RequestOptions(path: '/employees/airline-routes'),
            ),
            requestOptions: RequestOptions(path: '/employees/airline-routes'),
          ),
        );

        // Act
        final result = await datasource.getEmployeeAirlineRoutes();

        // Assert
        expect(result.success, isFalse);
      });
    });
  });
}
