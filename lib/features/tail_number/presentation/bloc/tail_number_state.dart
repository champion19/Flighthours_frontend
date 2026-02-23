import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';
import 'package:flight_hours_app/features/tail_number/domain/entities/tail_number_entity.dart';

/// States for the Tail Number BLoC
abstract class TailNumberState extends Equatable {
  const TailNumberState();

  @override
  List<Object?> get props => [];
}

/// Initial state — no search has been performed
class TailNumberInitial extends TailNumberState {}

/// Plates loaded silently, search bar is ready
class TailNumberReady extends TailNumberState {}

/// Loading state — API call in progress
class TailNumberLoading extends TailNumberState {}

/// List loaded state — all tail numbers available for filtering
class TailNumberListLoaded extends TailNumberState {
  final List<TailNumberEntity> plates;

  const TailNumberListLoaded(this.plates);

  @override
  List<Object?> get props => [plates];
}

/// Success state — tail number data loaded
class TailNumberSuccess extends TailNumberState {
  final TailNumberEntity tailNumber;
  final AircraftModelEntity? aircraftModel;

  const TailNumberSuccess(this.tailNumber, {this.aircraftModel});

  @override
  List<Object?> get props => [tailNumber, aircraftModel];
}

/// Error state — API call failed
class TailNumberError extends TailNumberState {
  final String message;

  const TailNumberError(this.message);

  @override
  List<Object?> get props => [message];
}
