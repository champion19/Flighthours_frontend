
import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/list_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_event.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_state.dart';

class AirlineBloc extends Bloc<AirlineEvent, AirlineState> {
  AirlineBloc() : super(AirlineInitial()) {
    final listAirlineUseCase = InjectorApp.resolve<ListAirlineUseCase>();
    on<FetchAirlines>(
      (event, emit) => _onFetchAirlines(event, emit, listAirlineUseCase),
    );
  }

  Future<void> _onFetchAirlines(
    FetchAirlines event,
    Emitter<AirlineState> emit,
    ListAirlineUseCase listAirlineUseCase,
  ) async {
    emit(AirlineLoading());

    try {
      final airlines = await listAirlineUseCase.call();
      emit(AirlineSuccess(airlines));
    } catch (e) {
      emit(AirlineError(e.toString()));
    }
  }
}
