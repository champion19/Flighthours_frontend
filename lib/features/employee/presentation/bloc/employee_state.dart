import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/employee/data/models/change_password_model.dart';
import 'package:flight_hours_app/features/employee/data/models/delete_employee_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_routes_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_response_model.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';

/// Base class for all employee states
abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no data loaded yet
class EmployeeInitial extends EmployeeState {}

/// Loading state while fetching data
class EmployeeLoading extends EmployeeState {}

/// Updating state while saving changes
class EmployeeUpdating extends EmployeeState {}

/// Changing password state
class PasswordChanging extends EmployeeState {}

/// Deleting account state
class EmployeeDeleting extends EmployeeState {}

/// Loading airline data state
class EmployeeAirlineLoading extends EmployeeState {}

/// Success state for fetching employee information
class EmployeeDetailSuccess extends EmployeeState {
  final EmployeeResponseModel response;

  const EmployeeDetailSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

/// Success state for fetching employee airline association
class EmployeeAirlineSuccess extends EmployeeState {
  final EmployeeAirlineResponseModel response;

  const EmployeeAirlineSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

/// Success state for updating employee information
class EmployeeUpdateSuccess extends EmployeeState {
  final EmployeeUpdateResponseModel response;

  const EmployeeUpdateSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

/// Success state for updating employee airline association
class EmployeeAirlineUpdateSuccess extends EmployeeState {
  final EmployeeAirlineResponseModel response;

  const EmployeeAirlineUpdateSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

/// Success state for changing password
class PasswordChangeSuccess extends EmployeeState {
  final ChangePasswordResponseModel response;

  const PasswordChangeSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

/// Success state for deleting account
class EmployeeDeleteSuccess extends EmployeeState {
  final DeleteEmployeeResponseModel response;

  const EmployeeDeleteSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

/// Success state for loading employee airline routes
class EmployeeAirlineRoutesSuccess extends EmployeeState {
  final EmployeeAirlineRoutesResponseModel response;

  const EmployeeAirlineRoutesSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

/// Loading state for airline routes
class EmployeeAirlineRoutesLoading extends EmployeeState {}

/// Error state with error details
class EmployeeError extends EmployeeState {
  final String message;
  final String? code;
  final bool success;

  const EmployeeError({required this.message, this.code, this.success = false});

  @override
  List<Object?> get props => [message, code, success];
}
