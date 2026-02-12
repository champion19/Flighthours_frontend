import 'package:equatable/equatable.dart';

/// Events for the Flight BLoC
abstract class FlightEvent extends Equatable {
  const FlightEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch all flights for the employee
class FetchEmployeeFlights extends FlightEvent {
  const FetchEmployeeFlights();
}

/// Load a specific flight detail
class LoadFlightDetail extends FlightEvent {
  final String flightId;

  const LoadFlightDetail(this.flightId);

  @override
  List<Object?> get props => [flightId];
}

/// Fetch the employee's logbook ID
class FetchLogbookId extends FlightEvent {
  const FetchLogbookId();
}

/// Create a new flight record
class CreateFlight extends FlightEvent {
  final String dailyLogbookId;
  final Map<String, dynamic> data;

  const CreateFlight({required this.dailyLogbookId, required this.data});

  @override
  List<Object?> get props => [dailyLogbookId, data];
}

/// Update an existing flight record
class UpdateFlight extends FlightEvent {
  final String flightId;
  final Map<String, dynamic> data;

  const UpdateFlight({required this.flightId, required this.data});

  @override
  List<Object?> get props => [flightId, data];
}
