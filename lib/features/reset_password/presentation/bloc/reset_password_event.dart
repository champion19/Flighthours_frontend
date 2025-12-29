part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String email;

  const ResetPasswordSubmitted({required this.email});

  @override
  List<Object> get props => [email];
}
