part of 'reset_password_bloc.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final ResetPasswordEntity result;

  const ResetPasswordSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class ResetPasswordError extends ResetPasswordState {
  final String message;
  final String code;

  const ResetPasswordError({required this.message, required this.code});

  @override
  List<Object?> get props => [message, code];
}
