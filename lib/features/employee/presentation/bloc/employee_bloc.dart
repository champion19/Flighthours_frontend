import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/change_password_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/delete_employee_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/get_employee_airline_routes_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/get_employee_airline_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/get_employee_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/update_employee_airline_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/update_employee_use_case.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_event.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_state.dart';

/// BLoC for managing employee-related state
///
/// Supports dependency injection for testing:
/// - [getEmployeeUseCase] for fetching employee info
/// - [updateEmployeeUseCase] for updating employee info
/// - [changePasswordUseCase] for changing password
/// - [deleteEmployeeUseCase] for deleting account
/// - [getEmployeeAirlineUseCase] for fetching airline association
/// - [updateEmployeeAirlineUseCase] for updating airline association
/// - [getEmployeeAirlineRoutesUseCase] for fetching airline routes
class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GetEmployeeUseCase _getEmployeeUseCase;
  final UpdateEmployeeUseCase _updateEmployeeUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final DeleteEmployeeUseCase _deleteEmployeeUseCase;
  final GetEmployeeAirlineUseCase _getEmployeeAirlineUseCase;
  final UpdateEmployeeAirlineUseCase _updateEmployeeAirlineUseCase;
  final GetEmployeeAirlineRoutesUseCase _getEmployeeAirlineRoutesUseCase;

  EmployeeBloc({
    GetEmployeeUseCase? getEmployeeUseCase,
    UpdateEmployeeUseCase? updateEmployeeUseCase,
    ChangePasswordUseCase? changePasswordUseCase,
    DeleteEmployeeUseCase? deleteEmployeeUseCase,
    GetEmployeeAirlineUseCase? getEmployeeAirlineUseCase,
    UpdateEmployeeAirlineUseCase? updateEmployeeAirlineUseCase,
    GetEmployeeAirlineRoutesUseCase? getEmployeeAirlineRoutesUseCase,
  }) : _getEmployeeUseCase =
           getEmployeeUseCase ?? InjectorApp.resolve<GetEmployeeUseCase>(),
       _updateEmployeeUseCase =
           updateEmployeeUseCase ??
           InjectorApp.resolve<UpdateEmployeeUseCase>(),
       _changePasswordUseCase =
           changePasswordUseCase ??
           InjectorApp.resolve<ChangePasswordUseCase>(),
       _deleteEmployeeUseCase =
           deleteEmployeeUseCase ??
           InjectorApp.resolve<DeleteEmployeeUseCase>(),
       _getEmployeeAirlineUseCase =
           getEmployeeAirlineUseCase ??
           InjectorApp.resolve<GetEmployeeAirlineUseCase>(),
       _updateEmployeeAirlineUseCase =
           updateEmployeeAirlineUseCase ??
           InjectorApp.resolve<UpdateEmployeeAirlineUseCase>(),
       _getEmployeeAirlineRoutesUseCase =
           getEmployeeAirlineRoutesUseCase ??
           InjectorApp.resolve<GetEmployeeAirlineRoutesUseCase>(),
       super(EmployeeInitial()) {
    on<LoadCurrentEmployee>(_onLoadCurrentEmployee);
    on<LoadEmployeeAirline>(_onLoadEmployeeAirline);
    on<LoadEmployeeAirlineRoutes>(_onLoadEmployeeAirlineRoutes);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<UpdateEmployeeAirline>(_onUpdateEmployeeAirline);
    on<ChangePassword>(_onChangePassword);
    on<DeleteEmployee>(_onDeleteEmployee);
    on<ResetEmployeeState>((event, emit) => emit(EmployeeInitial()));
  }

  /// Loads the current employee's information
  /// Uses /employees endpoint - no employeeId needed, extracted from JWT
  Future<void> _onLoadCurrentEmployee(
    LoadCurrentEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());

    try {
      final response = await _getEmployeeUseCase.call();

      if (response.success) {
        emit(EmployeeDetailSuccess(response));
      } else {
        emit(
          EmployeeError(
            message: response.message,
            code: response.code,
            success: response.success,
          ),
        );
      }
    } catch (e) {
      emit(EmployeeError(message: e.toString()));
    }
  }

  /// Loads the employee's airline association
  /// Uses GET /employees/airline endpoint
  Future<void> _onLoadEmployeeAirline(
    LoadEmployeeAirline event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeAirlineLoading());

    try {
      final response = await _getEmployeeAirlineUseCase.call();

      if (response.success) {
        emit(EmployeeAirlineSuccess(response));
      } else {
        // Don't emit error - the employee might not have an airline yet
        // Just emit success with null data
        emit(EmployeeAirlineSuccess(response));
      }
    } catch (e) {
      emit(EmployeeError(message: e.toString()));
    }
  }

  /// Loads the airline routes for the employee's airline
  /// Uses GET /employees/airline-routes endpoint
  Future<void> _onLoadEmployeeAirlineRoutes(
    LoadEmployeeAirlineRoutes event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeAirlineRoutesLoading());

    try {
      final response = await _getEmployeeAirlineRoutesUseCase.call();

      if (response.success) {
        emit(EmployeeAirlineRoutesSuccess(response));
      } else {
        emit(
          EmployeeError(
            message: response.message,
            code: response.code,
            success: response.success,
          ),
        );
      }
    } catch (e) {
      emit(EmployeeError(message: e.toString()));
    }
  }

  Future<void> _onUpdateEmployee(
    UpdateEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeUpdating());

    try {
      final response = await _updateEmployeeUseCase.call(event.request);

      if (response.success) {
        emit(EmployeeUpdateSuccess(response));
      } else {
        emit(
          EmployeeError(
            message: response.message,
            code: response.code,
            success: response.success,
          ),
        );
      }
    } catch (e) {
      emit(EmployeeError(message: e.toString()));
    }
  }

  /// Updates the employee's airline association
  Future<void> _onUpdateEmployeeAirline(
    UpdateEmployeeAirline event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeUpdating());

    try {
      final response = await _updateEmployeeAirlineUseCase.call(event.request);

      if (response.success) {
        emit(EmployeeAirlineUpdateSuccess(response));
      } else {
        emit(
          EmployeeError(
            message: response.message,
            code: response.code,
            success: response.success,
          ),
        );
      }
    } catch (e) {
      emit(EmployeeError(message: e.toString()));
    }
  }

  /// Handles password change request
  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(PasswordChanging());

    try {
      final response = await _changePasswordUseCase.call(event.request);

      if (response.success) {
        emit(PasswordChangeSuccess(response));
      } else {
        emit(
          EmployeeError(
            message: response.message,
            code: response.code,
            success: response.success,
          ),
        );
      }
    } catch (e) {
      emit(EmployeeError(message: e.toString()));
    }
  }

  /// Handles account deletion request
  Future<void> _onDeleteEmployee(
    DeleteEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeDeleting());

    try {
      final response = await _deleteEmployeeUseCase.call();

      if (response.success) {
        emit(EmployeeDeleteSuccess(response));
      } else {
        emit(
          EmployeeError(
            message: response.message,
            code: response.code,
            success: response.success,
          ),
        );
      }
    } catch (e) {
      emit(EmployeeError(message: e.toString()));
    }
  }
}
