import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/airline_route/domain/usecases/get_airline_route_by_id_use_case.dart';
import 'package:flight_hours_app/features/airline_route/domain/usecases/list_airline_routes_use_case.dart';
import 'package:flight_hours_app/features/airline_route/presentation/bloc/airline_route_event.dart';
import 'package:flight_hours_app/features/airline_route/presentation/bloc/airline_route_state.dart';

/// BLoC for managing airline route-related state
class AirlineRouteBloc extends Bloc<AirlineRouteEvent, AirlineRouteState> {
  AirlineRouteBloc() : super(AirlineRouteInitial()) {
    final listAirlineRoutesUseCase =
        InjectorApp.resolve<ListAirlineRoutesUseCase>();
    final getAirlineRouteByIdUseCase =
        InjectorApp.resolve<GetAirlineRouteByIdUseCase>();

    on<FetchAirlineRoutes>(
      (event, emit) =>
          _onFetchAirlineRoutes(event, emit, listAirlineRoutesUseCase),
    );
    on<FetchAirlineRouteById>(
      (event, emit) =>
          _onFetchAirlineRouteById(event, emit, getAirlineRouteByIdUseCase),
    );
  }

  /// Handle FetchAirlineRoutes event
  Future<void> _onFetchAirlineRoutes(
    FetchAirlineRoutes event,
    Emitter<AirlineRouteState> emit,
    ListAirlineRoutesUseCase listAirlineRoutesUseCase,
  ) async {
    emit(AirlineRouteLoading());

    try {
      final airlineRoutes = await listAirlineRoutesUseCase.call();
      emit(AirlineRouteSuccess(airlineRoutes));
    } catch (e) {
      emit(AirlineRouteError(e.toString()));
    }
  }

  /// Handle FetchAirlineRouteById event
  Future<void> _onFetchAirlineRouteById(
    FetchAirlineRouteById event,
    Emitter<AirlineRouteState> emit,
    GetAirlineRouteByIdUseCase getAirlineRouteByIdUseCase,
  ) async {
    try {
      final airlineRoute = await getAirlineRouteByIdUseCase.call(
        event.airlineRouteId,
      );
      if (airlineRoute != null) {
        emit(AirlineRouteDetailSuccess(airlineRoute));
      }
    } catch (e) {
      // Silently fail - don't emit error to avoid disrupting the UI
    }
  }
}
