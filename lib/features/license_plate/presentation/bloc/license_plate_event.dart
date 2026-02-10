import 'package:equatable/equatable.dart';

/// Events for the License Plate BLoC
abstract class LicensePlateEvent extends Equatable {
  const LicensePlateEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all license plates
class LoadAllLicensePlates extends LicensePlateEvent {}

/// Event to search a license plate by its ID
class SearchLicensePlate extends LicensePlateEvent {
  final String id;

  const SearchLicensePlate(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to select a license plate (fetches aircraft model for engine info)
class SelectLicensePlate extends LicensePlateEvent {
  final String id;

  const SelectLicensePlate(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to reset the license plate state
class ResetLicensePlate extends LicensePlateEvent {}
