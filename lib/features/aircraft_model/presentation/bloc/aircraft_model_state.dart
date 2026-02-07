import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/aircraft_model/data/models/aircraft_model_status_response_model.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';

abstract class AircraftModelState extends Equatable {
  const AircraftModelState();

  @override
  List<Object> get props => [];
}

class AircraftModelInitial extends AircraftModelState {}

class AircraftModelLoading extends AircraftModelState {}

class AircraftModelSuccess extends AircraftModelState {
  final List<AircraftModelEntity> aircraftModels;

  const AircraftModelSuccess(this.aircraftModels);

  @override
  List<Object> get props => [aircraftModels];
}

class AircraftModelsByFamilySuccess extends AircraftModelState {
  final List<AircraftModelEntity> aircraftModels;
  final String family;

  const AircraftModelsByFamilySuccess(
    this.aircraftModels, {
    required this.family,
  });

  @override
  List<Object> get props => [aircraftModels, family];
}

class AircraftModelStatusUpdateSuccess extends AircraftModelState {
  final AircraftModelStatusResponseModel response;
  final bool isActivation;

  const AircraftModelStatusUpdateSuccess(
    this.response, {
    required this.isActivation,
  });

  @override
  List<Object> get props => [response, isActivation];
}

class AircraftModelError extends AircraftModelState {
  final String message;

  const AircraftModelError(this.message);

  @override
  List<Object> get props => [message];
}
