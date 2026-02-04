import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/route/domain/usecases/get_route_by_id_use_case.dart';
import 'package:flight_hours_app/features/route/domain/usecases/list_routes_use_case.dart';
import 'package:flight_hours_app/features/route/presentation/bloc/route_event.dart';
import 'package:flight_hours_app/features/route/presentation/bloc/route_state.dart';

/// BLoC for managing route-related state
///
/// Supports dependency injection for testing:
/// - [listRoutesUseCase] for listing routes
/// - [getRouteByIdUseCase] for fetching route details
class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final ListRoutesUseCase _listRoutesUseCase;
  final GetRouteByIdUseCase _getRouteByIdUseCase;

  RouteBloc({
    ListRoutesUseCase? listRoutesUseCase,
    GetRouteByIdUseCase? getRouteByIdUseCase,
  }) : _listRoutesUseCase =
           listRoutesUseCase ?? InjectorApp.resolve<ListRoutesUseCase>(),
       _getRouteByIdUseCase =
           getRouteByIdUseCase ?? InjectorApp.resolve<GetRouteByIdUseCase>(),
       super(RouteInitial()) {
    on<FetchRoutes>(_onFetchRoutes);
    on<FetchRouteById>(_onFetchRouteById);
  }

  /// Handle FetchRoutes event
  Future<void> _onFetchRoutes(
    FetchRoutes event,
    Emitter<RouteState> emit,
  ) async {
    emit(RouteLoading());

    try {
      final routes = await _listRoutesUseCase.call();
      emit(RouteSuccess(routes));
    } catch (e) {
      emit(RouteError(e.toString()));
    }
  }

  /// Handle FetchRouteById event
  Future<void> _onFetchRouteById(
    FetchRouteById event,
    Emitter<RouteState> emit,
  ) async {
    try {
      final route = await _getRouteByIdUseCase.call(event.routeId);
      if (route != null) {
        emit(RouteDetailSuccess(route));
      }
    } catch (e) {
      // Silently fail - don't emit error to avoid disrupting the UI
    }
  }
}
