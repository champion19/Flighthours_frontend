import 'package:equatable/equatable.dart';

/// Tail Number domain entity
///
/// Represents an aircraft registration (matrícula) from the database
/// Fields follow hexagonal architecture patterns
class TailNumberEntity extends Equatable {
  final String id;
  final String tailNumber;
  final String? modelName;
  final String? airlineName;
  final String? aircraftModelId;
  final String? airlineId;

  const TailNumberEntity({
    required this.id,
    required this.tailNumber,
    this.modelName,
    this.airlineName,
    this.aircraftModelId,
    this.airlineId,
  });

  @override
  List<Object?> get props => [
    id,
    tailNumber,
    modelName,
    airlineName,
    aircraftModelId,
    airlineId,
  ];
}
