import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/email_verification/domain/entities/EmailEntity.dart';
import 'package:flight_hours_app/features/email_verification/domain/usecases/email_verification_use_case.dart';

part 'email_verification_event.dart';
part 'email_verification_state.dart';

/// BLoC for managing email verification state
///
/// Supports dependency injection for testing:
/// - [emailVerificationUseCase] for handling email verification operations
class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  final EmailVerificationUseCase _emailVerificationUseCase;

  EmailVerificationBloc({EmailVerificationUseCase? emailVerificationUseCase})
    : _emailVerificationUseCase =
          emailVerificationUseCase ??
          InjectorApp.resolve<EmailVerificationUseCase>(),
      super(EmailVerificationInitial()) {
    on<VerifyEmailEvent>(_onVerifyEmail);
  }

  Future<void> _onVerifyEmail(
    VerifyEmailEvent event,
    Emitter<EmailVerificationState> emit,
  ) async {
    emit(EmailVerificationLoading());
    try {
      final result = await _emailVerificationUseCase.call(event.email);
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
}
