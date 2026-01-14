import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/route/domain/usecases/get_route_by_id_use_case.dart';
import 'package:flight_hours_app/features/route/domain/usecases/list_routes_use_case.dart';
import 'package:flight_hours_app/features/route/presentation/bloc/route_event.dart';
import 'package:flight_hours_app/features/route/presentation/bloc/route_state.dart';

/// BLoC for managing route-related state
class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc() : super(RouteInitial()) {
    final listRoutesUseCase = InjectorApp.resolve<ListRoutesUseCase>();
    final getRouteByIdUseCase = InjectorApp.resolve<GetRouteByIdUseCase>();

    on<FetchRoutes>(
      (event, emit) => _onFetchRoutes(event, emit, listRoutesUseCase),
    );
    on<FetchRouteById>(
      (event, emit) => _onFetchRouteById(event, emit, getRouteByIdUseCase),
    );
  }

  /// Handle FetchRoutes event
  Future<void> _onFetchRoutes(
    FetchRoutes event,
    Emitter<RouteState> emit,
    ListRoutesUseCase listRoutesUseCase,
  ) async {
    emit(RouteLoading());

    try {
      final routes = await listRoutesUseCase.call();
      emit(RouteSuccess(routes));
    } catch (e) {
      emit(RouteError(e.toString()));
    }
  }

  /// Handle FetchRouteById event
  Future<void> _onFetchRouteById(
    FetchRouteById event,
    Emitter<RouteState> emit,
    GetRouteByIdUseCase getRouteByIdUseCase,
  ) async {
    try {
      final route = await getRouteByIdUseCase.call(event.routeId);
      if (route != null) {
        emit(RouteDetailSuccess(route));
      }
    } catch (e) {
      // Silently fail - don't emit error to avoid disrupting the UI
    }
  }
}
