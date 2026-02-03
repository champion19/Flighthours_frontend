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
class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeInitial()) {
    final getEmployeeUseCase = InjectorApp.resolve<GetEmployeeUseCase>();
    final updateEmployeeUseCase = InjectorApp.resolve<UpdateEmployeeUseCase>();
    final changePasswordUseCase = InjectorApp.resolve<ChangePasswordUseCase>();
    final deleteEmployeeUseCase = InjectorApp.resolve<DeleteEmployeeUseCase>();
    final getEmployeeAirlineUseCase =
        InjectorApp.resolve<GetEmployeeAirlineUseCase>();
    final updateEmployeeAirlineUseCase =
        InjectorApp.resolve<UpdateEmployeeAirlineUseCase>();
    final getEmployeeAirlineRoutesUseCase =
        InjectorApp.resolve<GetEmployeeAirlineRoutesUseCase>();

    on<LoadCurrentEmployee>(
      (event, emit) => _onLoadCurrentEmployee(emit, getEmployeeUseCase),
    );

    on<LoadEmployeeAirline>(
      (event, emit) => _onLoadEmployeeAirline(emit, getEmployeeAirlineUseCase),
    );

    on<LoadEmployeeAirlineRoutes>(
      (event, emit) =>
          _onLoadEmployeeAirlineRoutes(emit, getEmployeeAirlineRoutesUseCase),
    );

    on<UpdateEmployee>(
      (event, emit) => _onUpdateEmployee(event, emit, updateEmployeeUseCase),
    );

    on<UpdateEmployeeAirline>(
      (event, emit) =>
          _onUpdateEmployeeAirline(event, emit, updateEmployeeAirlineUseCase),
    );

    on<ChangePassword>(
      (event, emit) => _onChangePassword(event, emit, changePasswordUseCase),
    );

    on<DeleteEmployee>(
      (event, emit) => _onDeleteEmployee(emit, deleteEmployeeUseCase),
    );

    on<ResetEmployeeState>((event, emit) => emit(EmployeeInitial()));
  }

  /// Loads the current employee's information
  /// Uses /employees endpoint - no employeeId needed, extracted from JWT
  Future<void> _onLoadCurrentEmployee(
    Emitter<EmployeeState> emit,
    GetEmployeeUseCase getEmployeeUseCase,
  ) async {
    emit(EmployeeLoading());

    try {
      final response = await getEmployeeUseCase.call();

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
    Emitter<EmployeeState> emit,
    GetEmployeeAirlineUseCase getEmployeeAirlineUseCase,
  ) async {
    emit(EmployeeAirlineLoading());

    try {
      final response = await getEmployeeAirlineUseCase.call();

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
    Emitter<EmployeeState> emit,
    GetEmployeeAirlineRoutesUseCase getEmployeeAirlineRoutesUseCase,
  ) async {
    emit(EmployeeAirlineRoutesLoading());

    try {
      final response = await getEmployeeAirlineRoutesUseCase.call();

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
    UpdateEmployeeUseCase updateEmployeeUseCase,
  ) async {
    emit(EmployeeUpdating());

    try {
      final response = await updateEmployeeUseCase.call(event.request);

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
    UpdateEmployeeAirlineUseCase updateEmployeeAirlineUseCase,
  ) async {
    emit(EmployeeUpdating());

    try {
      final response = await updateEmployeeAirlineUseCase.call(event.request);

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
    ChangePasswordUseCase changePasswordUseCase,
  ) async {
    emit(PasswordChanging());

    try {
      final response = await changePasswordUseCase.call(event.request);

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
    Emitter<EmployeeState> emit,
    DeleteEmployeeUseCase deleteEmployeeUseCase,
  ) async {
    emit(EmployeeDeleting());

    try {
      final response = await deleteEmployeeUseCase.call();

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
