import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/activate_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/deactivate_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/get_airport_by_id_use_case.dart';
import 'package:flight_hours_app/features/airport/domain/usecases/list_airport_use_case.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_event.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_state.dart';

class AirportBloc extends Bloc<AirportEvent, AirportState> {
  AirportBloc() : super(AirportInitial()) {
    final listAirportUseCase = InjectorApp.resolve<ListAirportUseCase>();
    final getAirportByIdUseCase = InjectorApp.resolve<GetAirportByIdUseCase>();
    final activateAirportUseCase =
        InjectorApp.resolve<ActivateAirportUseCase>();
    final deactivateAirportUseCase =
        InjectorApp.resolve<DeactivateAirportUseCase>();

    on<FetchAirports>(
      (event, emit) => _onFetchAirports(event, emit, listAirportUseCase),
    );
    on<FetchAirportById>(
      (event, emit) => _onFetchAirportById(event, emit, getAirportByIdUseCase),
    );
    on<ActivateAirport>(
      (event, emit) => _onActivateAirport(event, emit, activateAirportUseCase),
    );
    on<DeactivateAirport>(
      (event, emit) =>
          _onDeactivateAirport(event, emit, deactivateAirportUseCase),
    );
  }

  Future<void> _onFetchAirports(
    FetchAirports event,
    Emitter<AirportState> emit,
    ListAirportUseCase listAirportUseCase,
  ) async {
    emit(AirportLoading());

    try {
      final airports = await listAirportUseCase.call();
      emit(AirportSuccess(airports));
    } catch (e) {
      emit(AirportError(e.toString()));
    }
  }

  Future<void> _onFetchAirportById(
    FetchAirportById event,
    Emitter<AirportState> emit,
    GetAirportByIdUseCase getAirportByIdUseCase,
  ) async {
    try {
      final airport = await getAirportByIdUseCase.call(event.airportId);
      if (airport != null) {
        emit(AirportDetailSuccess(airport));
      }
    } catch (e) {
      // Silently fail - don't emit error to avoid disrupting the UI
    }
  }

  Future<void> _onActivateAirport(
    ActivateAirport event,
    Emitter<AirportState> emit,
    ActivateAirportUseCase activateAirportUseCase,
  ) async {
    emit(AirportLoading());

    try {
      final response = await activateAirportUseCase.call(event.airportId);
      if (response.success) {
        emit(AirportStatusUpdateSuccess(response, isActivation: true));
      } else {
        emit(AirportError(response.message));
      }
    } catch (e) {
      emit(AirportError(e.toString()));
    }
  }

  Future<void> _onDeactivateAirport(
    DeactivateAirport event,
    Emitter<AirportState> emit,
    DeactivateAirportUseCase deactivateAirportUseCase,
  ) async {
    emit(AirportLoading());

    try {
      final response = await deactivateAirportUseCase.call(event.airportId);
      if (response.success) {
        emit(AirportStatusUpdateSuccess(response, isActivation: false));
      } else {
        emit(AirportError(response.message));
      }
    } catch (e) {
      emit(AirportError(e.toString()));
    }
  }
}
