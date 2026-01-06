import 'package:equatable/equatable.dart';

abstract class AirlineEvent extends Equatable {
  const AirlineEvent();

  @override
  List<Object> get props => [];
}

class FetchAirlines extends AirlineEvent {}

class FetchAirlineById extends AirlineEvent {
  final String airlineId;

  const FetchAirlineById({required this.airlineId});

  @override
  List<Object> get props => [airlineId];
}
