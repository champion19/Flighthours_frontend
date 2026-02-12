import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';
import 'package:flight_hours_app/features/reset_password/domain/usecases/reset_password_use_case.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

/// BLoC for managing password reset state
class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordBloc({ResetPasswordUseCase? resetPasswordUseCase})
    : _resetPasswordUseCase =
          resetPasswordUseCase ?? InjectorApp.resolve<ResetPasswordUseCase>(),
      super(ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(ResetPasswordLoading());

    final result = await _resetPasswordUseCase.call(event.email);
    result.fold(
      (failure) => emit(
        ResetPasswordError(
          message: failure.message,
          code: failure.code ?? 'UNKNOWN_ERROR',
        ),
      ),
      (entity) => emit(ResetPasswordSuccess(entity)),
    );
  }
}
