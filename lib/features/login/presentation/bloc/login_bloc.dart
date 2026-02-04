import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/core/services/session_service.dart';
import 'package:flight_hours_app/features/employee/data/datasources/employee_remote_data_source.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/update_employee_use_case.dart';
import 'package:flight_hours_app/features/login/data/datasources/login_datasource.dart';
import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';
import 'package:flight_hours_app/features/login/domain/usecases/login_use_case.dart';
import 'package:flutter/foundation.dart';

part 'login_event.dart';
part 'login_state.dart';

/// BLoC for managing login state
///
/// Supports dependency injection for testing:
/// - [loginUseCase] for handling login operations
/// - [updateEmployeeUseCase] for updating employee data after login
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;
  final UpdateEmployeeUseCase _updateEmployeeUseCase;

  LoginBloc({
    LoginUseCase? loginUseCase,
    UpdateEmployeeUseCase? updateEmployeeUseCase,
  }) : _loginUseCase = loginUseCase ?? InjectorApp.resolve<LoginUseCase>(),
       _updateEmployeeUseCase =
           updateEmployeeUseCase ??
           InjectorApp.resolve<UpdateEmployeeUseCase>(),
       super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final loginResult = await _loginUseCase.call(event.email, event.password);

      // Save session data for use throughout the app (without role for now)
      await SessionService().setSession(
        employeeId: loginResult.employeeId ?? '',
        accessToken: loginResult.accessToken,
        refreshToken: loginResult.refreshToken,
        email: loginResult.email,
        name: loginResult.name,
      );

      // Fetch employee data to get the role
      String userRole = 'pilot'; // Default role
      try {
        debugPrint('📋 Fetching employee data to determine role...');
        final employeeDataSource = EmployeeRemoteDataSourceImpl();
        final employeeResponse = await employeeDataSource.getCurrentEmployee();

        if (employeeResponse.success && employeeResponse.data != null) {
          userRole = employeeResponse.data!.role ?? 'pilot';
          debugPrint('✅ User role determined: $userRole');

          // Update session with role
          await SessionService().setSession(
            employeeId: loginResult.employeeId ?? '',
            accessToken: loginResult.accessToken,
            refreshToken: loginResult.refreshToken,
            email: loginResult.email,
            name: employeeResponse.data!.name,
            role: userRole,
          );
        }
      } catch (roleError) {
        debugPrint(
          '⚠️ Could not fetch user role, defaulting to pilot: $roleError',
        );
      }

      // Check if there's pending pilot data from registration
      final hasPendingData = await SessionService().hasPendingPilotData();

      if (hasPendingData) {
        debugPrint('📦 Found pending pilot data, sending to backend...');
        emit(LoginSyncingPilotData());

        try {
          final pendingData = await SessionService().getPendingPilotData();

          if (pendingData != null) {
            debugPrint('📤 Pending data: $pendingData');

            // 1. Update basic employee data (PUT /employees)
            final updateRequest = EmployeeUpdateRequest(
              name: pendingData['name'],
              identificationNumber: pendingData['identificationNumber'],
            );

            debugPrint('📤 Sending PUT /employees: ${updateRequest.toJson()}');
            final updateResponse = await _updateEmployeeUseCase.call(
              updateRequest,
            );

            if (updateResponse.success) {
              debugPrint('✅ Basic employee data synced successfully');
              // Clear the pending data since it's been synced
              await SessionService().clearPendingPilotData();
            } else {
              debugPrint(
                '⚠️ Failed to sync pilot data: ${updateResponse.message}',
              );
              // Don't clear pending data - it can be retried later from profile
            }

            // Note: Airline association (bp, airline, dates) will be updated
            // from the profile page using PUT /employees/airline
          }
        } catch (updateError) {
          // Log but don't fail the login - user can update later from profile
          debugPrint('⚠️ Failed to sync pilot data: $updateError');
          // Don't clear pending data - it can be retried later
        }
      }

      emit(LoginSuccess(loginResult, role: userRole));
    } on LoginException catch (e) {
      if (e.isEmailNotVerified) {
        // Special case: email not verified
        emit(LoginEmailNotVerified(message: e.message, code: e.code));
      } else {
        // Other login errors
        emit(LoginError(message: e.message, code: e.code));
      }
    } catch (e) {
      emit(LoginError(message: e.toString(), code: 'UNKNOWN_ERROR'));
    }
  }
}
