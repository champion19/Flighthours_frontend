part of 'email_verification_bloc.dart';

sealed class EmailVerificationEvent extends Equatable {
  const EmailVerificationEvent();

  @override
  List<Object> get props => [];
}

class VerifyEmailEvent extends EmailVerificationEvent {
  final String email;
  const VerifyEmailEvent({required this.email});
  @override
  List<Object> get props => [email];
}
