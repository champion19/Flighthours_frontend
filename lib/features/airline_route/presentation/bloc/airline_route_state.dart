import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';

/// Base class for all AirlineRoute states
abstract class AirlineRouteState extends Equatable {
  const AirlineRouteState();

  @override
  List<Object> get props => [];
}

/// Initial state before any action
class AirlineRouteInitial extends AirlineRouteState {}

/// Loading state while fetching data
class AirlineRouteLoading extends AirlineRouteState {}

/// Success state with list of airline routes
class AirlineRouteSuccess extends AirlineRouteState {
  final List<AirlineRouteEntity> airlineRoutes;

  const AirlineRouteSuccess(this.airlineRoutes);

  @override
  List<Object> get props => [airlineRoutes];
}

/// Success state with a single airline route detail
class AirlineRouteDetailSuccess extends AirlineRouteState {
  final AirlineRouteEntity airlineRoute;

  const AirlineRouteDetailSuccess(this.airlineRoute);

  @override
  List<Object> get props => [airlineRoute];
}

/// Error state with error message
class AirlineRouteError extends AirlineRouteState {
  final String message;

  const AirlineRouteError(this.message);

  @override
  List<Object> get props => [message];
}

/// Loading state while updating status
class AirlineRouteStatusUpdating extends AirlineRouteState {}

/// Success state after status update
class AirlineRouteStatusUpdateSuccess extends AirlineRouteState {
  final String message;

  const AirlineRouteStatusUpdateSuccess(this.message);

  @override
  List<Object> get props => [message];
}

/// Error state after status update failure
class AirlineRouteStatusUpdateError extends AirlineRouteState {
  final String message;

  const AirlineRouteStatusUpdateError(this.message);

  @override
  List<Object> get props => [message];
}
