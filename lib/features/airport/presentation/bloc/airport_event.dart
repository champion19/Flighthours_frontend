import 'package:equatable/equatable.dart';

abstract class AirportEvent extends Equatable {
  const AirportEvent();

  @override
  List<Object> get props => [];
}

class FetchAirports extends AirportEvent {}

class FetchAirportById extends AirportEvent {
  final String airportId;

  const FetchAirportById({required this.airportId});

  @override
  List<Object> get props => [airportId];
}

class ActivateAirport extends AirportEvent {
  final String airportId;

  const ActivateAirport({required this.airportId});

  @override
  List<Object> get props => [airportId];
}

class DeactivateAirport extends AirportEvent {
  final String airportId;

  const DeactivateAirport({required this.airportId});

  @override
  List<Object> get props => [airportId];
}
