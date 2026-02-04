import 'package:flight_hours_app/features/employee/data/models/change_password_model.dart';
import 'package:flight_hours_app/features/employee/data/models/delete_employee_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_routes_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_response_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';

/// Abstract repository interface for employee operations
abstract class EmployeeRepository {
  /// Fetches the current employee's information
  /// Uses the /employees endpoint - ID is extracted from JWT token
  Future<EmployeeResponseModel> getCurrentEmployee();

  /// Updates the current employee's information
  /// Uses the /employees endpoint - ID is extracted from JWT token
  Future<EmployeeUpdateResponseModel> updateCurrentEmployee(
    EmployeeUpdateRequest request,
  );

  /// Changes the current employee's password
  /// Uses the /auth/change-password endpoint with Bearer token
  Future<ChangePasswordResponseModel> changePassword(
    ChangePasswordRequest request,
  );

  /// Deletes the current employee's account
  /// Uses DELETE /employees endpoint - ID is extracted from JWT token
  Future<DeleteEmployeeResponseModel> deleteCurrentEmployee();

  /// Fetches the current employee's airline association
  /// Uses GET /employees/airline endpoint
  Future<EmployeeAirlineResponseModel> getEmployeeAirline();

  /// Updates the current employee's airline association
  /// Uses PUT /employees/airline endpoint
  Future<EmployeeAirlineResponseModel> updateEmployeeAirline(
    EmployeeAirlineUpdateRequest request,
  );

  /// Fetches the airline routes for the employee's airline
  /// Uses GET /employees/airline-routes endpoint
  Future<EmployeeAirlineRoutesResponseModel> getEmployeeAirlineRoutes();
}
