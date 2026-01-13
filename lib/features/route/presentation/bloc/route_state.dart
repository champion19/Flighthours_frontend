import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';

/// Base class for all Route states
abstract class RouteState extends Equatable {
  const RouteState();

  @override
  List<Object> get props => [];
}

/// Initial state before any action
class RouteInitial extends RouteState {}

/// Loading state while fetching data
class RouteLoading extends RouteState {}

/// Success state with list of routes
class RouteSuccess extends RouteState {
  final List<RouteEntity> routes;

  const RouteSuccess(this.routes);

  @override
  List<Object> get props => [routes];
}

/// Success state with a single route detail
class RouteDetailSuccess extends RouteState {
  final RouteEntity route;

  const RouteDetailSuccess(this.route);

  @override
  List<Object> get props => [route];
}

/// Error state with error message
class RouteError extends RouteState {
  final String message;

  const RouteError(this.message);

  @override
  List<Object> get props => [message];
}
