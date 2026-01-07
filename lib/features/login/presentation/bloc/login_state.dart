part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

/// State when syncing pilot data after login
class LoginSyncingPilotData extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginEntity loginResult;
  const LoginSuccess(this.loginResult);

  @override
  List<Object?> get props => [loginResult];
}

/// State when login fails due to email not being verified
/// The backend automatically resends verification email in this case
class LoginEmailNotVerified extends LoginState {
  final String message;
  final String code;

  const LoginEmailNotVerified({required this.message, required this.code});

  @override
  List<Object?> get props => [message, code];
}

class LoginError extends LoginState {
  final String message;
  final String code;

  const LoginError({required this.message, required this.code});

  @override
  List<Object?> get props => [message, code];
}
