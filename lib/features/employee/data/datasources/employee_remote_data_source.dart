import 'package:flight_hours_app/core/config/config.dart';
import 'package:flight_hours_app/core/services/session_service.dart';
import 'package:flight_hours_app/features/employee/data/models/change_password_model.dart';
import 'package:flight_hours_app/features/employee/data/models/delete_employee_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_response_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';
import 'package:http/http.dart' as http;

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

/// Implementation of the employee remote data source
class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  /// Gets the authorization headers including the Bearer token
  Map<String, String> _getHeaders() {
    final token = SessionService().accessToken;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<EmployeeResponseModel> getCurrentEmployee() async {
    final response = await http.get(
      Uri.parse("${Config.baseUrl}/employees/me"),
      headers: _getHeaders(),
    );

    // Parse the response regardless of status code
    // The backend always returns the structured response
    return EmployeeResponseModel.fromJson(response.body);
  }

  @override
  Future<EmployeeUpdateResponseModel> updateCurrentEmployee(
    EmployeeUpdateRequest request,
  ) async {
    final response = await http.put(
      Uri.parse("${Config.baseUrl}/employees/me"),
      headers: _getHeaders(),
      body: request.toJson(),
    );

    // Parse the response regardless of status code
    return EmployeeUpdateResponseModel.fromJson(response.body);
  }

  @override
  Future<ChangePasswordResponseModel> changePassword(
    ChangePasswordRequest request,
  ) async {
    final response = await http.post(
      Uri.parse("${Config.baseUrl}/auth/change-password"),
      headers: _getHeaders(),
      body: request.toJson(),
    );

    // Parse the response regardless of status code
    return ChangePasswordResponseModel.fromJson(response.body);
  }

  @override
  Future<DeleteEmployeeResponseModel> deleteCurrentEmployee() async {
    final response = await http.delete(
      Uri.parse("${Config.baseUrl}/employees/me"),
      headers: _getHeaders(),
    );

    // Parse the response regardless of status code
    return DeleteEmployeeResponseModel.fromJson(response.body);
  }
}
