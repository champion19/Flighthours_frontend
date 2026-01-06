import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/get_airline_by_id_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/list_airline_use_case.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_event.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_state.dart';

class AirlineBloc extends Bloc<AirlineEvent, AirlineState> {
  AirlineBloc() : super(AirlineInitial()) {
    final listAirlineUseCase = InjectorApp.resolve<ListAirlineUseCase>();
    final getAirlineByIdUseCase = InjectorApp.resolve<GetAirlineByIdUseCase>();

    on<FetchAirlines>(
      (event, emit) => _onFetchAirlines(event, emit, listAirlineUseCase),
    );
    on<FetchAirlineById>(
      (event, emit) => _onFetchAirlineById(event, emit, getAirlineByIdUseCase),
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

  Future<void> _onFetchAirlineById(
    FetchAirlineById event,
    Emitter<AirlineState> emit,
    GetAirlineByIdUseCase getAirlineByIdUseCase,
  ) async {
    try {
      final airline = await getAirlineByIdUseCase.call(event.airlineId);
      if (airline != null) {
        emit(AirlineDetailSuccess(airline));
      }
    } catch (e) {
      // Silently fail - don't emit error to avoid disrupting the UI
    }
  }
}
