import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/airline_route/data/datasources/airline_route_remote_data_source.dart';
import 'package:flight_hours_app/features/airline_route/domain/usecases/get_airline_route_by_id_use_case.dart';
import 'package:flight_hours_app/features/airline_route/domain/usecases/list_airline_routes_use_case.dart';
import 'package:flight_hours_app/features/airline_route/presentation/bloc/airline_route_event.dart';
import 'package:flight_hours_app/features/airline_route/presentation/bloc/airline_route_state.dart';

/// BLoC for managing airline route-related state
class AirlineRouteBloc extends Bloc<AirlineRouteEvent, AirlineRouteState> {
  final AirlineRouteRemoteDataSource _dataSource;
  final ListAirlineRoutesUseCase _listAirlineRoutesUseCase;
  final GetAirlineRouteByIdUseCase _getAirlineRouteByIdUseCase;

  AirlineRouteBloc({
    AirlineRouteRemoteDataSource? dataSource,
    ListAirlineRoutesUseCase? listAirlineRoutesUseCase,
    GetAirlineRouteByIdUseCase? getAirlineRouteByIdUseCase,
  }) : _dataSource = dataSource ?? AirlineRouteRemoteDataSourceImpl(),
       _listAirlineRoutesUseCase =
           listAirlineRoutesUseCase ??
           InjectorApp.resolve<ListAirlineRoutesUseCase>(),
       _getAirlineRouteByIdUseCase =
           getAirlineRouteByIdUseCase ??
           InjectorApp.resolve<GetAirlineRouteByIdUseCase>(),
       super(AirlineRouteInitial()) {
    on<FetchAirlineRoutes>(_onFetchAirlineRoutes);
    on<FetchAirlineRouteById>(_onFetchAirlineRouteById);
    on<ActivateAirlineRoute>(_onActivateAirlineRoute);
    on<DeactivateAirlineRoute>(_onDeactivateAirlineRoute);
  }

  Future<void> _onFetchAirlineRoutes(
    FetchAirlineRoutes event,
    Emitter<AirlineRouteState> emit,
  ) async {
    emit(AirlineRouteLoading());

    final result = await _listAirlineRoutesUseCase.call();
    result.fold(
      (failure) => emit(AirlineRouteError(failure.message)),
      (airlineRoutes) => emit(AirlineRouteSuccess(airlineRoutes)),
    );
  }

  Future<void> _onFetchAirlineRouteById(
    FetchAirlineRouteById event,
    Emitter<AirlineRouteState> emit,
  ) async {
    final result = await _getAirlineRouteByIdUseCase.call(event.airlineRouteId);
    result.fold(
      (_) {}, // Silently fail - don't emit error to avoid disrupting the UI
      (airlineRoute) => emit(AirlineRouteDetailSuccess(airlineRoute)),
    );
  }

  /// Handle ActivateAirlineRoute event
  Future<void> _onActivateAirlineRoute(
    ActivateAirlineRoute event,
    Emitter<AirlineRouteState> emit,
  ) async {
    emit(AirlineRouteStatusUpdating());

    try {
      final response = await _dataSource.activateAirlineRoute(
        event.airlineRouteId,
      );
      if (response.success) {
        emit(AirlineRouteStatusUpdateSuccess(response.message));
      } else {
        emit(AirlineRouteStatusUpdateError(response.message));
      }
    } catch (e) {
      emit(AirlineRouteStatusUpdateError(e.toString()));
    }
  }

  /// Handle DeactivateAirlineRoute event
  Future<void> _onDeactivateAirlineRoute(
    DeactivateAirlineRoute event,
    Emitter<AirlineRouteState> emit,
  ) async {
    emit(AirlineRouteStatusUpdating());

    try {
      final response = await _dataSource.deactivateAirlineRoute(
        event.airlineRouteId,
      );
      if (response.success) {
        emit(AirlineRouteStatusUpdateSuccess(response.message));
      } else {
        emit(AirlineRouteStatusUpdateError(response.message));
      }
    } catch (e) {
      emit(AirlineRouteStatusUpdateError(e.toString()));
    }
  }
}
