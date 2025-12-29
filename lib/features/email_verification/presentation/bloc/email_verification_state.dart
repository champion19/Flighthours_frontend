part of 'email_verification_bloc.dart';

sealed class EmailVerificationState extends Equatable {
  const EmailVerificationState();

  @override
  List<Object> get props => [];
}

final class EmailVerificationInitial extends EmailVerificationState {}

final class EmailVerificationLoading extends EmailVerificationState {}

final class EmailVerificationSuccess extends EmailVerificationState {
  final EmailEntity result;

  const EmailVerificationSuccess({required this.result});

  @override
  List<Object> get props => [result];
}

final class EmailVerificationError extends EmailVerificationState {
  final String message;

  const EmailVerificationError({required this.message});

  @override
  List<Object> get props => [message];
}
