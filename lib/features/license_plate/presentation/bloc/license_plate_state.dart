import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';
import 'package:flight_hours_app/features/license_plate/domain/entities/license_plate_entity.dart';

/// States for the License Plate BLoC
abstract class LicensePlateState extends Equatable {
  const LicensePlateState();

  @override
  List<Object?> get props => [];
}

/// Initial state — no search has been performed
class LicensePlateInitial extends LicensePlateState {}

/// Plates loaded silently, search bar is ready
class LicensePlateReady extends LicensePlateState {}

/// Loading state — API call in progress
class LicensePlateLoading extends LicensePlateState {}

/// List loaded state — all license plates available for filtering
class LicensePlateListLoaded extends LicensePlateState {
  final List<LicensePlateEntity> plates;

  const LicensePlateListLoaded(this.plates);

  @override
  List<Object?> get props => [plates];
}

/// Success state — license plate data loaded
class LicensePlateSuccess extends LicensePlateState {
  final LicensePlateEntity licensePlate;
  final AircraftModelEntity? aircraftModel;

  const LicensePlateSuccess(this.licensePlate, {this.aircraftModel});

  @override
  List<Object?> get props => [licensePlate, aircraftModel];
}

/// Error state — API call failed
class LicensePlateError extends LicensePlateState {
  final String message;

  const LicensePlateError(this.message);

  @override
  List<Object?> get props => [message];
}
