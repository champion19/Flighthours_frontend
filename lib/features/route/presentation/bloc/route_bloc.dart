import 'package:bloc/bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/route/domain/usecases/get_route_by_id_use_case.dart';
import 'package:flight_hours_app/features/route/domain/usecases/list_routes_use_case.dart';
import 'package:flight_hours_app/features/route/presentation/bloc/route_event.dart';
import 'package:flight_hours_app/features/route/presentation/bloc/route_state.dart';

/// BLoC for managing route-related state
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

  Future<void> _onFetchRoutes(
    FetchRoutes event,
    Emitter<RouteState> emit,
  ) async {
    emit(RouteLoading());

    final result = await _listRoutesUseCase.call();
    result.fold(
      (failure) => emit(RouteError(failure.message)),
      (routes) => emit(RouteSuccess(routes)),
    );
  }

  Future<void> _onFetchRouteById(
    FetchRouteById event,
    Emitter<RouteState> emit,
  ) async {
    final result = await _getRouteByIdUseCase.call(event.routeId);
    result.fold(
      (_) {}, // Silently fail
      (route) => emit(RouteDetailSuccess(route)),
    );
  }
}
