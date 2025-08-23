import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'email_verification_event.dart';
part 'email_verification_state.dart';

class EmailVerificationBloc extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  EmailVerificationBloc() : super(EmailVerificationInitial()) {
    on<EmailVerificationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
