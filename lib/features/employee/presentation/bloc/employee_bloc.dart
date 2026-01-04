import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/change_password_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/delete_employee_use_case.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/get_employee_use_case.dart';
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

    on<LoadCurrentEmployee>(
      (event, emit) => _onLoadCurrentEmployee(emit, getEmployeeUseCase),
    );

    on<UpdateEmployee>(
      (event, emit) => _onUpdateEmployee(event, emit, updateEmployeeUseCase),
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
  /// Uses /employees/me endpoint - no employeeId needed, extracted from JWT
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
