import 'package:equatable/equatable.dart';

abstract class AircraftModelEvent extends Equatable {
  const AircraftModelEvent();

  @override
  List<Object> get props => [];
}

class FetchAircraftModels extends AircraftModelEvent {}

class ActivateAircraftModel extends AircraftModelEvent {
  final String aircraftModelId;

  const ActivateAircraftModel({required this.aircraftModelId});

  @override
  List<Object> get props => [aircraftModelId];
}

class DeactivateAircraftModel extends AircraftModelEvent {
  final String aircraftModelId;

  const DeactivateAircraftModel({required this.aircraftModelId});

  @override
  List<Object> get props => [aircraftModelId];
}

class FetchAircraftModelsByFamily extends AircraftModelEvent {
  final String family;

  const FetchAircraftModelsByFamily({required this.family});

  @override
  List<Object> get props => [family];
}
