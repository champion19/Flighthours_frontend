import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/employee/data/models/change_password_model.dart';
import 'package:flight_hours_app/features/employee/data/models/delete_employee_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_response_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';

/// Abstract interface for employee remote data operations
abstract class EmployeeRemoteDataSource {
  /// Fetches the current employee's information
  /// Uses /employees/me endpoint - ID is extracted from JWT token
  Future<EmployeeResponseModel> getCurrentEmployee();

  /// Updates the current employee's information
  /// Uses /employees/me endpoint - ID is extracted from JWT token
  Future<EmployeeUpdateResponseModel> updateCurrentEmployee(
    EmployeeUpdateRequest request,
  );

  /// Changes the current employee's password
  /// Uses /auth/change-password endpoint with Bearer token
  Future<ChangePasswordResponseModel> changePassword(
    ChangePasswordRequest request,
  );

  /// Deletes the current employee's account
  /// Uses DELETE /employees/me endpoint - ID is extracted from JWT token
  Future<DeleteEmployeeResponseModel> deleteCurrentEmployee();
}

/// Implementation of the employee remote data source using Dio
///
/// Migrated from http package to Dio for:
/// - Automatic Bearer token injection via interceptor
/// - Automatic refresh token handling on 401 errors
/// - Better error handling and logging
/// - Automatic JSON parsing (Map instead of String)
class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final Dio _dio;

  /// Creates an instance with the default DioClient
  ///
  /// Optionally accepts a custom Dio instance for testing
  EmployeeRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? DioClient().client;

  @override
  Future<EmployeeResponseModel> getCurrentEmployee() async {
    try {
      final response = await _dio.get('/employees/me');
      // Dio already parses JSON to Map automatically
      return EmployeeResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      // If server responded with error, parse the structured error response
      if (e.response != null) {
        return EmployeeResponseModel.fromMap(e.response!.data);
      }
      // Connection error or other - rethrow for higher level handling
      rethrow;
    }
  }

  @override
  Future<EmployeeUpdateResponseModel> updateCurrentEmployee(
    EmployeeUpdateRequest request,
  ) async {
    try {
      final response = await _dio.put(
        '/employees/me',
        data:
            request.toMap(), // Dio accepts Map directly, no need for jsonEncode
      );
      return EmployeeUpdateResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return EmployeeUpdateResponseModel.fromMap(e.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<ChangePasswordResponseModel> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/change-password',
        data: request.toMap(),
      );
      return ChangePasswordResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return ChangePasswordResponseModel.fromMap(e.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<DeleteEmployeeResponseModel> deleteCurrentEmployee() async {
    try {
      final response = await _dio.delete('/employees/me');
      return DeleteEmployeeResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return DeleteEmployeeResponseModel.fromMap(e.response!.data);
      }
      rethrow;
    }
  }
}
