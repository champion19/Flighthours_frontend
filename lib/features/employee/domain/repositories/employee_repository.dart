import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/employee/data/models/change_password_model.dart';
import 'package:flight_hours_app/features/employee/data/models/delete_employee_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_routes_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_response_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';

/// Abstract repository interface for employee operations
abstract class EmployeeRepository {
  /// Fetches the current employee's information
  Future<Either<Failure, EmployeeResponseModel>> getCurrentEmployee();

  /// Updates the current employee's information
  Future<Either<Failure, EmployeeUpdateResponseModel>> updateCurrentEmployee(
    EmployeeUpdateRequest request,
  );

  /// Changes the current employee's password
  Future<Either<Failure, ChangePasswordResponseModel>> changePassword(
    ChangePasswordRequest request,
  );

  /// Deletes the current employee's account
  Future<Either<Failure, DeleteEmployeeResponseModel>> deleteCurrentEmployee();

  /// Fetches the current employee's airline association
  Future<Either<Failure, EmployeeAirlineResponseModel>> getEmployeeAirline();

  /// Updates the current employee's airline association
  Future<Either<Failure, EmployeeAirlineResponseModel>> updateEmployeeAirline(
    EmployeeAirlineUpdateRequest request,
  );

  /// Fetches the airline routes for the employee's airline
  Future<Either<Failure, EmployeeAirlineRoutesResponseModel>>
  getEmployeeAirlineRoutes();
}
