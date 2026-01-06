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
