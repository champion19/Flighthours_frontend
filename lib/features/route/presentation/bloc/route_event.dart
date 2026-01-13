import 'package:equatable/equatable.dart';

/// Base class for all Route events
abstract class RouteEvent extends Equatable {
  const RouteEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch all routes
class FetchRoutes extends RouteEvent {}

/// Event to fetch a specific route by ID
class FetchRouteById extends RouteEvent {
  final String routeId;

  const FetchRouteById({required this.routeId});

  @override
  List<Object> get props => [routeId];
}

/// Event to search/filter routes locally
class SearchRoutes extends RouteEvent {
  final String query;

  const SearchRoutes({required this.query});

  @override
  List<Object> get props => [query];
}
