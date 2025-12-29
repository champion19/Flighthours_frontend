import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/reset_password/data/datasources/reset_password_datasource.dart';
import 'package:flight_hours_app/features/reset_password/domain/entities/reset_password_entity.dart';
import 'package:flight_hours_app/features/reset_password/domain/usecases/reset_password_use_case.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    final resetPasswordUseCase = InjectorApp.resolve<ResetPasswordUseCase>();
    on<ResetPasswordSubmitted>(
      (event, emit) =>
          _onResetPasswordSubmitted(event, emit, resetPasswordUseCase),
    );
  }

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
    ResetPasswordUseCase resetPasswordUseCase,
  ) async {
    emit(ResetPasswordLoading());

    try {
      final result = await resetPasswordUseCase.call(event.email);
      emit(ResetPasswordSuccess(result));
    } on ResetPasswordException catch (e) {
      emit(ResetPasswordError(message: e.message, code: e.code));
    } catch (e) {
      emit(ResetPasswordError(message: e.toString(), code: 'UNKNOWN_ERROR'));
    }
  }
}
