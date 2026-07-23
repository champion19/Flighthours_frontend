import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/airline_route/domain/usecases/resolve_airline_route_use_case.dart';
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
  final GetEmployeeUseCase _getEmployeeUseCase;
  final UpdateEmployeeUseCase _updateEmployeeUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final DeleteEmployeeUseCase _deleteEmployeeUseCase;
  final GetEmployeeAirlineUseCase _getEmployeeAirlineUseCase;
  final UpdateEmployeeAirlineUseCase _updateEmployeeAirlineUseCase;
  final GetEmployeeAirlineRoutesUseCase _getEmployeeAirlineRoutesUseCase;
  final ResolveAirlineRouteUseCase _resolveAirlineRouteUseCase;

  EmployeeBloc({
    GetEmployeeUseCase? getEmployeeUseCase,
    UpdateEmployeeUseCase? updateEmployeeUseCase,
    ChangePasswordUseCase? changePasswordUseCase,
    DeleteEmployeeUseCase? deleteEmployeeUseCase,
    GetEmployeeAirlineUseCase? getEmployeeAirlineUseCase,
    UpdateEmployeeAirlineUseCase? updateEmployeeAirlineUseCase,
    GetEmployeeAirlineRoutesUseCase? getEmployeeAirlineRoutesUseCase,
    ResolveAirlineRouteUseCase? resolveAirlineRouteUseCase,
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
       _resolveAirlineRouteUseCase =
           resolveAirlineRouteUseCase ??
           InjectorApp.resolve<ResolveAirlineRouteUseCase>(),
       super(EmployeeInitial()) {
    on<LoadCurrentEmployee>(_onLoadCurrentEmployee);
    on<LoadEmployeeAirline>(_onLoadEmployeeAirline);
    on<LoadEmployeeAirlineRoutes>(_onLoadEmployeeAirlineRoutes);
    on<ResolveAirlineRoute>(_onResolveAirlineRoute);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<UpdateEmployeeAirline>(_onUpdateEmployeeAirline);
    on<ChangePassword>(_onChangePassword);
    on<DeleteEmployee>(_onDeleteEmployee);
    on<ResetEmployeeState>((event, emit) => emit(EmployeeInitial()));
  }

  Future<void> _onLoadCurrentEmployee(
    LoadCurrentEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());

    final result = await _getEmployeeUseCase.call();
    result.fold(
      (failure) => emit(
        EmployeeError(
          message: failure.message,
          code: failure.code,
          success: false,
        ),
      ),
      (response) {
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
      },
    );
  }

  Future<void> _onLoadEmployeeAirline(
    LoadEmployeeAirline event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeAirlineLoading());

    final result = await _getEmployeeAirlineUseCase.call();
    result.fold(
      (failure) => emit(EmployeeError(message: failure.message)),
      (response) => emit(EmployeeAirlineSuccess(response)),
    );
  }

  Future<void> _onLoadEmployeeAirlineRoutes(
    LoadEmployeeAirlineRoutes event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeAirlineRoutesLoading());

    final result = await _getEmployeeAirlineRoutesUseCase.call();
    result.fold(
      (failure) => emit(
        EmployeeError(
          message: failure.message,
          code: failure.code,
          success: false,
        ),
      ),
      (response) {
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
      },
    );
  }

  Future<void> _onResolveAirlineRoute(
    ResolveAirlineRoute event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(AirlineRouteResolving());

    final result = await _resolveAirlineRouteUseCase.call(
      originAirportId: event.originAirportId,
      destinationAirportId: event.destinationAirportId,
    );
    result.fold(
      (failure) => emit(
        EmployeeError(
          message: failure.message,
          code: failure.code,
          success: false,
          statusCode: failure.statusCode,
        ),
      ),
      (airlineRoute) => emit(AirlineRouteResolved(airlineRoute)),
    );
  }

  Future<void> _onUpdateEmployee(
    UpdateEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeUpdating());

    final result = await _updateEmployeeUseCase.call(event.request);
    result.fold(
      (failure) => emit(
        EmployeeError(
          message: failure.message,
          code: failure.code,
          success: false,
        ),
      ),
      (response) {
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
      },
    );
  }

  Future<void> _onUpdateEmployeeAirline(
    UpdateEmployeeAirline event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeUpdating());

    final result = await _updateEmployeeAirlineUseCase.call(event.request);
    result.fold(
      (failure) => emit(
        EmployeeError(
          message: failure.message,
          code: failure.code,
          success: false,
        ),
      ),
      (response) {
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
      },
    );
  }

  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(PasswordChanging());

    final result = await _changePasswordUseCase.call(event.request);
    result.fold(
      (failure) => emit(
        EmployeeError(
          message: failure.message,
          code: failure.code,
          success: false,
        ),
      ),
      (response) {
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
      },
    );
  }

  Future<void> _onDeleteEmployee(
    DeleteEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeDeleting());

    final result = await _deleteEmployeeUseCase.call();
    result.fold(
      (failure) => emit(
        EmployeeError(
          message: failure.message,
          code: failure.code,
          success: false,
        ),
      ),
      (response) {
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
      },
    );
  }
}
