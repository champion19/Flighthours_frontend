import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/reset_password/data/datasources/reset_password_datasource.dart';
import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';
import 'package:flight_hours_app/features/reset_password/domain/usecases/reset_password_use_case.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

/// BLoC for managing password reset state
///
/// Supports dependency injection for testing:
/// - [resetPasswordUseCase] for handling password reset operations
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

    try {
      final result = await _resetPasswordUseCase.call(event.email);
      emit(ResetPasswordSuccess(result));
    } on ResetPasswordException catch (e) {
      emit(ResetPasswordError(message: e.message, code: e.code));
    } catch (e) {
      emit(ResetPasswordError(message: e.toString(), code: 'UNKNOWN_ERROR'));
    }
  }
}
