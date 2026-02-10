import 'package:equatable/equatable.dart';

/// License Plate domain entity
///
/// Represents an aircraft registration (matrícula) from the database
/// Fields follow hexagonal architecture patterns
class LicensePlateEntity extends Equatable {
  final String id;
  final String licensePlate;
  final String? modelName;
  final String? airlineName;
  final String? aircraftModelId;
  final String? airlineId;

  const LicensePlateEntity({
    required this.id,
    required this.licensePlate,
    this.modelName,
    this.airlineName,
    this.aircraftModelId,
    this.airlineId,
  });

  @override
  List<Object?> get props => [
    id,
    licensePlate,
    modelName,
    airlineName,
    aircraftModelId,
    airlineId,
  ];
}
