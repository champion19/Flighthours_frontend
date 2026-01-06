import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/email_verification/domain/entities/EmailEntity.dart';
import 'package:flight_hours_app/features/email_verification/domain/usecases/email_verification_use_case.dart';

part 'email_verification_event.dart';
part 'email_verification_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  EmailVerificationBloc() : super(EmailVerificationInitial()) {
    final emailVerificationUseCase =
        InjectorApp.resolve<EmailVerificationUseCase>();

    on<VerifyEmailEvent>(
      (event, emit) => _onVerifyEmail(event, emit, emailVerificationUseCase),
    );
  }
}

Future<void> _onVerifyEmail(
  VerifyEmailEvent event,
  Emitter<EmailVerificationState> emit,
  EmailVerificationUseCase emailVerificationUseCase,
) async {
  emit(EmailVerificationLoading());
  try {
    final result = await emailVerificationUseCase.call(event.email);
    if (result.emailconfirmed) {
      emit(EmailVerificationSuccess(result: result));
    } else {
      emit(
        const EmailVerificationError(message: 'El correo no está verificado'),
      );
    }
  } catch (e) {
    emit(EmailVerificationError(message: e.toString()));
  }
}
