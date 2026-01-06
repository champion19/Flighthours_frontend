import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/employee/data/models/change_password_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';

/// Base class for all employee events
abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load current logged-in employee's information
/// Uses the /employees/me endpoint - ID is extracted from JWT token
class LoadCurrentEmployee extends EmployeeEvent {}

/// Event to update employee information
/// The employee ID is extracted from the JWT token by the backend
class UpdateEmployee extends EmployeeEvent {
  final EmployeeUpdateRequest request;

  const UpdateEmployee({required this.request});

  @override
  List<Object?> get props => [request];
}

/// Event to change the employee's password
/// Uses the /auth/change-password endpoint with Bearer token
class ChangePassword extends EmployeeEvent {
  final ChangePasswordRequest request;

  const ChangePassword({required this.request});

  @override
  List<Object?> get props => [request];
}

/// Event to delete the current employee's account
/// Uses DELETE /employees/me endpoint - ID is extracted from JWT token
class DeleteEmployee extends EmployeeEvent {}

/// Event to reset the state (clear results)
class ResetEmployeeState extends EmployeeEvent {}
