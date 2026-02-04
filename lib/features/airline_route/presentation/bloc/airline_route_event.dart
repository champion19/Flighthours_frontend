import 'package:equatable/equatable.dart';

/// Base class for all AirlineRoute events
abstract class AirlineRouteEvent extends Equatable {
  const AirlineRouteEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch all airline routes
class FetchAirlineRoutes extends AirlineRouteEvent {}

/// Event to fetch a specific airline route by ID
class FetchAirlineRouteById extends AirlineRouteEvent {
  final String airlineRouteId;

  const FetchAirlineRouteById({required this.airlineRouteId});

  @override
  List<Object> get props => [airlineRouteId];
}

/// Event to search/filter airline routes locally
class SearchAirlineRoutes extends AirlineRouteEvent {
  final String query;

  const SearchAirlineRoutes({required this.query});

  @override
  List<Object> get props => [query];
}

/// Event to activate an airline route
class ActivateAirlineRoute extends AirlineRouteEvent {
  final String airlineRouteId;

  const ActivateAirlineRoute({required this.airlineRouteId});

  @override
  List<Object> get props => [airlineRouteId];
}

/// Event to deactivate an airline route
class DeactivateAirlineRoute extends AirlineRouteEvent {
  final String airlineRouteId;

  const DeactivateAirlineRoute({required this.airlineRouteId});

  @override
  List<Object> get props => [airlineRouteId];
}
