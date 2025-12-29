import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/login/data/datasources/login_datasource.dart';
import 'package:flight_hours_app/features/login/domain/entities/login_entity.dart';
import 'package:flight_hours_app/features/login/domain/usecases/login_use_case.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    final loginUseCase = InjectorApp.resolve<LoginUseCase>();
    on<LoginSubmitted>(
      (event, emit) => _onLoginSubmitted(event, emit, loginUseCase),
    );
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
    LoginUseCase loginUseCase,
  ) async {
    emit(LoginLoading());

    try {
      final loginResult = await loginUseCase.call(event.email, event.password);
      emit(LoginSuccess(loginResult));
    } on LoginException catch (e) {
      if (e.isEmailNotVerified) {
        // Special case: email not verified
        emit(LoginEmailNotVerified(message: e.message, code: e.code));
      } else {
        // Other login errors
        emit(LoginError(message: e.message, code: e.code));
      }
    } catch (e) {
      emit(LoginError(message: e.toString(), code: 'UNKNOWN_ERROR'));
    }
  }
}
