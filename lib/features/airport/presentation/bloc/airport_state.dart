import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';

abstract class AirportState extends Equatable {
  const AirportState();

  @override
  List<Object> get props => [];
}

class AirportInitial extends AirportState {}

class AirportLoading extends AirportState {}

class AirportSuccess extends AirportState {
  final List<AirportEntity> airports;

  const AirportSuccess(this.airports);

  @override
  List<Object> get props => [airports];
}

class AirportDetailSuccess extends AirportState {
  final AirportEntity airport;

  const AirportDetailSuccess(this.airport);

  @override
  List<Object> get props => [airport];
}

class AirportStatusUpdateSuccess extends AirportState {
  final AirportStatusResponseModel response;
  final bool isActivation;

  const AirportStatusUpdateSuccess(this.response, {required this.isActivation});

  @override
  List<Object> get props => [response, isActivation];
}

class AirportError extends AirportState {
  final String message;

  const AirportError(this.message);

  @override
  List<Object> get props => [message];
}
