import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/login/domain/entities/EmployeeEntity.dart';
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
        final employee = await loginUseCase.call(event.email, event.password);
        emit(LoginSuccess(employee));
      } catch (e) {
        emit(LoginError(e.toString()));
      }
    }
  }

