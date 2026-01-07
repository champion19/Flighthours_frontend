import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/core/services/session_service.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/update_employee_use_case.dart';
import 'package:flight_hours_app/features/login/data/datasources/login_datasource.dart';
import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';
import 'package:flight_hours_app/features/login/domain/usecases/login_use_case.dart';
import 'package:flutter/foundation.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    final loginUseCase = InjectorApp.resolve<LoginUseCase>();
    final updateEmployeeUseCase = InjectorApp.resolve<UpdateEmployeeUseCase>();

    on<LoginSubmitted>(
      (event, emit) =>
          _onLoginSubmitted(event, emit, loginUseCase, updateEmployeeUseCase),
    );
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
    LoginUseCase loginUseCase,
    UpdateEmployeeUseCase updateEmployeeUseCase,
  ) async {
    emit(LoginLoading());

    try {
      final loginResult = await loginUseCase.call(event.email, event.password);

      // Save session data for use throughout the app
      await SessionService().setSession(
        employeeId: loginResult.employeeId ?? '',
        accessToken: loginResult.accessToken,
        refreshToken: loginResult.refreshToken,
        email: loginResult.email,
        name: loginResult.name,
      );

      // Check if there's pending pilot data from registration
      final hasPendingData = await SessionService().hasPendingPilotData();

      if (hasPendingData) {
        debugPrint('📦 Found pending pilot data, sending to backend...');
        emit(LoginSyncingPilotData());

        try {
          final pendingData = await SessionService().getPendingPilotData();

          if (pendingData != null) {
            debugPrint('📤 Pending data: $pendingData');

            // Create update request with ALL employee data
            // PUT /employees/me requires: name, airline, identificationNumber, bp, startDate, endDate, active, role
            final updateRequest = EmployeeUpdateRequest(
              name: pendingData['name'],
              identificationNumber: pendingData['identificationNumber'],
              bp: pendingData['bp'],
              airline: pendingData['airlineId'],
              startDate: pendingData['startDate'],
              endDate: pendingData['endDate'],
              active: pendingData['active'],
              role: pendingData['role'],
            );

            debugPrint(
              '📤 Sending PUT /employees/me: ${updateRequest.toJson()}',
            );
            final updateResponse = await updateEmployeeUseCase.call(
              updateRequest,
            );

            if (updateResponse.success) {
              debugPrint('✅ Pilot data synced successfully');
              // Clear the pending data since it's been synced
              await SessionService().clearPendingPilotData();
            } else {
              debugPrint(
                '⚠️ Failed to sync pilot data: ${updateResponse.message}',
              );
              // Don't clear pending data - it can be retried later from profile
            }
          }
        } catch (updateError) {
          // Log but don't fail the login - user can update later from profile
          debugPrint('⚠️ Failed to sync pilot data: $updateError');
          // Don't clear pending data - it can be retried later
        }
      }

      emit(LoginSuccess(loginResult));
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
