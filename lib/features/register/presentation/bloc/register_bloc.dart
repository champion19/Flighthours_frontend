import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/core/services/session_service.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';
import 'package:flight_hours_app/features/register/domain/usecases/register_use_case.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_event.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_state.dart';
import 'package:flutter/foundation.dart';

/// BLoC for managing registration state
///
/// Supports dependency injection for testing:
/// - [registerUseCase] for handling registration operations
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterBloc({RegisterUseCase? registerUseCase})
    : _registerUseCase =
          registerUseCase ?? InjectorApp.resolve<RegisterUseCase>(),
      super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<EnterPersonalInformation>(_onEnterPersonalInformation);
    on<EnterPilotInformation>(_onEnterPilotInformation);
    on<CompleteRegistrationFlow>(_onCompleteRegistrationFlow);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<VerificationCodeSubmitted>(_onVerificationCodeSubmitted);
    on<PasswordResetSubmitted>(_onPasswordResetSubmitted);
    on<StartVerification>(_onStartVerification);
  }

  Future<void> _onStartVerification(
    StartVerification event,
    Emitter<RegisterState> emit,
  ) async {}

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      RegisterLoading(
        employee: state.employee ?? EmployeeEntityRegister.empty(),
      ),
    );

    try {
      final response = await _registerUseCase.call(event.employment);
      emit(
        RegisterSuccess(
          employee: event.employment,
          message: response.message,
          code: response.code,
        ),
      );
    } catch (e) {
      emit(
        RegisterError(
          message: e.toString(),
          employee: state.employee ?? EmployeeEntityRegister.empty(),
        ),
      );
    }
  }

  Future<void> _onEnterPersonalInformation(
    EnterPersonalInformation event,
    Emitter<RegisterState> emit,
  ) async {
    try {
      emit(PersonalInfoCompleted(employee: event.employment));
    } catch (e) {
      emit(
        RegisterError(
          message: e.toString(),
          employee: state.employee ?? EmployeeEntityRegister.empty(),
        ),
      );
    }
  }

  Future<void> _onEnterPilotInformation(
    EnterPilotInformation event,
    Emitter<RegisterState> emit,
  ) async {
    final updatedEmployee = (state.employee ?? EmployeeEntityRegister.empty())
        .copyWith(
          bp: event.employment.bp,
          fechaInicio: event.employment.fechaInicio,
          fechaFin: event.employment.fechaFin,
          vigente: event.employment.vigente,
          airline: event.employment.airline,
        );
    emit(PilotInfoCompleted(employee: updatedEmployee));
  }

  /// Handles the complete registration flow:
  /// 1. Save pilot data (bp, airline, active) to secure storage
  /// 2. POST /register with basic data only
  /// 3. After login, PUT /employees/me with pilot data
  Future<void> _onCompleteRegistrationFlow(
    CompleteRegistrationFlow event,
    Emitter<RegisterState> emit,
  ) async {
    final employee = event.employee;

    try {
      // Step 1: Save pilot data to secure storage for later
      debugPrint('📦 Step 1: Saving pilot data for later...');
      emit(
        RegistrationFlowInProgress(
          employee: employee,
          currentStep: '1/2',
          stepDescription: 'Saving your pilot information...',
        ),
      );

      await SessionService().setPendingPilotData(
        name: employee.name,
        identificationNumber: employee.idNumber,
        bp: employee.bp,
        airlineId: employee.airline,
        startDate: employee.fechaInicio,
        endDate: employee.fechaFin,
        active: employee.vigente ?? false,
        role: employee.role ?? 'pilot',
      );
      debugPrint('✅ Employee data saved to secure storage');

      // Step 2: Register with basic data only
      debugPrint('📝 Step 2: Registering user...');
      emit(
        RegistrationFlowInProgress(
          employee: employee,
          currentStep: '2/2',
          stepDescription: 'Creating your account...',
        ),
      );

      final response = await _registerUseCase.call(employee);
      debugPrint('✅ Registration successful');

      // Registration complete - pilot data will be sent after login
      emit(
        RegistrationFlowComplete(
          employee: employee,
          message:
              response.message.isNotEmpty
                  ? response.message
                  : 'Account created! Please verify your email to continue.',
        ),
      );
    } catch (e) {
      debugPrint('❌ Registration error: $e');
      // Clear pending data if registration fails
      await SessionService().clearPendingPilotData();
      emit(RegisterError(message: e.toString(), employee: employee));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      RegisterLoading(
        employee: state.employee ?? EmployeeEntityRegister.empty(),
      ),
    );
    try {
      // Simulación de envío de código
      await Future.delayed(const Duration(seconds: 1));
      debugPrint('Enviando código de recuperación a ${event.email}');
      emit(RecoveryCodeSent());
    } catch (e) {
      emit(RecoveryError(message: e.toString()));
    }
  }

  Future<void> _onVerificationCodeSubmitted(
    VerificationCodeSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      RegisterLoading(
        employee: state.employee ?? EmployeeEntityRegister.empty(),
      ),
    );
    try {
      // Simulación de verificación de código
      await Future.delayed(const Duration(seconds: 1));
      if (event.code == '1234') {
        emit(RecoveryCodeVerified());
      } else {
        emit(const RecoveryError(message: 'Código de verificación incorrecto'));
      }
    } catch (e) {
      emit(RecoveryError(message: e.toString()));
    }
  }

  Future<void> _onPasswordResetSubmitted(
    PasswordResetSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      RegisterLoading(
        employee: state.employee ?? EmployeeEntityRegister.empty(),
      ),
    );
    try {
      // Simulación de reseteo de contraseña
      await Future.delayed(const Duration(seconds: 1));
      debugPrint('Contraseña actualizada a: ${event.newPassword}');
      emit(PasswordResetSuccess());
    } catch (e) {
      emit(RecoveryError(message: e.toString()));
    }
  }
}
