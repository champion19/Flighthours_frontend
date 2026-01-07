import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';

abstract class RegisterState extends Equatable {
  final EmployeeEntityRegister? employee;

  const RegisterState({this.employee});

  @override
  List<Object?> get props => [employee];
}

class RegisterInitial extends RegisterState {
  RegisterInitial() : super(employee: EmployeeEntityRegister.empty());
}

class RegisterLoading extends RegisterState {
  const RegisterLoading({required EmployeeEntityRegister employee})
    : super(employee: employee);
}

class RegisterSuccess extends RegisterState {
  final String message;
  final String code;

  const RegisterSuccess({
    required EmployeeEntityRegister employee,
    required this.message,
    required this.code,
  }) : super(employee: employee);

  @override
  List<Object?> get props => [employee, message, code];
}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError({
    required this.message,
    required EmployeeEntityRegister employee,
  }) : super(employee: employee);

  @override
  List<Object?> get props => [message, employee];
}

class PersonalInfoCompleted extends RegisterState {
  const PersonalInfoCompleted({required EmployeeEntityRegister employee})
    : super(employee: employee);
}

class PilotInfoCompleted extends RegisterState {
  const PilotInfoCompleted({required EmployeeEntityRegister employee})
    : super(employee: employee);
}

class RecoveryCodeSent extends RegisterState {
  RecoveryCodeSent() : super(employee: EmployeeEntityRegister.empty());
}

class RecoveryCodeVerified extends RegisterState {
  RecoveryCodeVerified() : super(employee: EmployeeEntityRegister.empty());
}

class PasswordResetSuccess extends RegisterState {
  PasswordResetSuccess() : super(employee: EmployeeEntityRegister.empty());
}

class RecoveryError extends RegisterState {
  final String message;

  const RecoveryError({required this.message}) : super();

  @override
  List<Object> get props => [message];
}

/// State during the complete registration flow
/// Shows progress through: Register -> Login -> Update Profile
class RegistrationFlowInProgress extends RegisterState {
  final String currentStep;
  final String stepDescription;

  const RegistrationFlowInProgress({
    required EmployeeEntityRegister employee,
    required this.currentStep,
    required this.stepDescription,
  }) : super(employee: employee);

  @override
  List<Object?> get props => [employee, currentStep, stepDescription];
}

/// State when the complete registration flow finishes successfully
class RegistrationFlowComplete extends RegisterState {
  final String message;

  const RegistrationFlowComplete({
    required EmployeeEntityRegister employee,
    required this.message,
  }) : super(employee: employee);

  @override
  List<Object?> get props => [employee, message];
}
