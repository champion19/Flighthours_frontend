import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';

class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class StartVerification extends RegisterEvent {
  final String email;
  const StartVerification(this.email);

  @override
  List<Object> get props => [email];
}

class RegisterSubmitted extends RegisterEvent {
  final EmployeeEntityRegister employment;

  const RegisterSubmitted({required this.employment});

  @override
  List<Object> get props => [employment];
}

class EnterPersonalInformation extends RegisterEvent {
  final EmployeeEntityRegister employment;

  const EnterPersonalInformation({required this.employment});

  @override
  List<Object> get props => [employment];
}

class EnterPilotInformation extends RegisterEvent {
  final EmployeeEntityRegister employment;

  const EnterPilotInformation({required this.employment});

  @override
  List<Object> get props => [employment];
}

class ForgotPasswordRequested extends RegisterEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class VerificationCodeSubmitted extends RegisterEvent {
  final String code;

  const VerificationCodeSubmitted({required this.code});

  @override
  List<Object> get props => [code];
}

class PasswordResetSubmitted extends RegisterEvent {
  final String newPassword;

  const PasswordResetSubmitted({required this.newPassword});

  @override
  List<Object> get props => [newPassword];
}
