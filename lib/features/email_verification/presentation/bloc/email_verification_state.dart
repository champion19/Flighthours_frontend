part of 'email_verification_bloc.dart';

sealed class EmailVerificationState extends Equatable {
  const EmailVerificationState();
  
  @override
  List<Object> get props => [];
}

final class EmailVerificationInitial extends EmailVerificationState {}
