import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/core/services/session_service.dart';
import 'package:flight_hours_app/features/employee/data/datasources/employee_remote_data_source.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_update_model.dart';
import 'package:flight_hours_app/features/employee/domain/usecases/update_employee_use_case.dart';
import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';
import 'package:flight_hours_app/features/login/domain/usecases/login_use_case.dart';

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

    final result = await _loginUseCase.call(event.email, event.password);

    await result.fold(
      (failure) async {
        // Check for email not verified error
        if (failure.code == 'MOD_KC_LOGIN_EMAIL_NOT_VERIFIED_ERR_00001') {
          emit(
            LoginEmailNotVerified(
              message: failure.message,
              code: failure.code ?? 'EMAIL_NOT_VERIFIED',
            ),
          );
        } else {
          emit(
            LoginError(
              message: failure.message,
              code: failure.code ?? 'UNKNOWN_ERROR',
            ),
          );
        }
      },
      (loginResult) async {
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
          final employeeDataSource = EmployeeRemoteDataSourceImpl();
          final employeeResponse =
              await employeeDataSource.getCurrentEmployee();

          if (employeeResponse.success && employeeResponse.data != null) {
            userRole = employeeResponse.data!.role ?? 'pilot';

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
        } catch (_) {
          // Could not fetch role, proceed with default
        }

        // Check if there's pending pilot data from registration
        final hasPendingData = await SessionService().hasPendingPilotData();

        if (hasPendingData) {
          emit(LoginSyncingPilotData());

          try {
            final pendingData = await SessionService().getPendingPilotData();

            if (pendingData != null) {
              final updateRequest = EmployeeUpdateRequest(
                name: pendingData['name'],
                identificationNumber: pendingData['identificationNumber'],
              );

              final updateResult = await _updateEmployeeUseCase.call(
                updateRequest,
              );

              updateResult.fold(
                (_) {}, // Don't fail the login on update error
                (response) async {
                  if (response.success) {
                    await SessionService().clearPendingPilotData();
                  }
                },
              );
            }
          } catch (_) {
            // Don't fail the login — user can update later from profile
          }
        }

        emit(LoginSuccess(loginResult, role: userRole));
      },
    );
  }
}
