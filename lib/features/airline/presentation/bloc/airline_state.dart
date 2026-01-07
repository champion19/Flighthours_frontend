import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';

abstract class AirlineState extends Equatable {
  const AirlineState();

  @override
  List<Object> get props => [];
}

class AirlineInitial extends AirlineState {}

class AirlineLoading extends AirlineState {}

class AirlineSuccess extends AirlineState {
  final List<AirlineEntity> airlines;

  const AirlineSuccess(this.airlines);

  @override
  List<Object> get props => [airlines];
}

class AirlineDetailSuccess extends AirlineState {
  final AirlineEntity airline;

  const AirlineDetailSuccess(this.airline);

  @override
  List<Object> get props => [airline];
}

class AirlineError extends AirlineState {
  final String message;

  const AirlineError(this.message);

  @override
  List<Object> get props => [message];
}

/// State when airline status is being updated (activate/deactivate)
class AirlineStatusUpdating extends AirlineState {
  final String airlineId;

  const AirlineStatusUpdating({required this.airlineId});

  @override
  List<Object> get props => [airlineId];
}

/// State when airline status update succeeds
class AirlineStatusUpdateSuccess extends AirlineState {
  final String message;
  final String code;
  final String? newStatus;

  const AirlineStatusUpdateSuccess({
    required this.message,
    required this.code,
    this.newStatus,
  });

  @override
  List<Object> get props => [message, code];
}

/// State when airline status update fails
class AirlineStatusUpdateError extends AirlineState {
  final String message;
  final String code;

  const AirlineStatusUpdateError({required this.message, required this.code});

  @override
  List<Object> get props => [message, code];
}
