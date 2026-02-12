import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/flight/domain/entities/flight_entity.dart';

/// States for the Flight BLoC
abstract class FlightState extends Equatable {
  const FlightState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class FlightInitial extends FlightState {
  const FlightInitial();
}

/// Loading state for any flight operation
class FlightLoading extends FlightState {
  const FlightLoading();
}

/// Employee's logbook ID loaded
class LogbookIdLoaded extends FlightState {
  final String logbookId;

  const LogbookIdLoaded(this.logbookId);

  @override
  List<Object?> get props => [logbookId];
}

/// List of flights loaded
class FlightListLoaded extends FlightState {
  final List<FlightEntity> flights;

  const FlightListLoaded(this.flights);

  @override
  List<Object?> get props => [flights];
}

/// Single flight detail loaded
class FlightDetailLoaded extends FlightState {
  final FlightEntity flight;

  const FlightDetailLoaded(this.flight);

  @override
  List<Object?> get props => [flight];
}

/// Flight created successfully
class FlightCreated extends FlightState {
  final FlightEntity? flight;

  const FlightCreated(this.flight);

  @override
  List<Object?> get props => [flight];
}

/// Flight updated successfully
class FlightUpdated extends FlightState {
  final FlightEntity? flight;

  const FlightUpdated(this.flight);

  @override
  List<Object?> get props => [flight];
}

/// Error state
class FlightError extends FlightState {
  final String message;

  const FlightError(this.message);

  @override
  List<Object?> get props => [message];
}
