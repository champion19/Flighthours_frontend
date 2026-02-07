import 'package:equatable/equatable.dart';

/// Aircraft Model domain entity
///
/// Represents an aircraft model from the database
/// Fields follow hexagonal architecture patterns
class AircraftModelEntity extends Equatable {
  final String id;
  final String name;
  final String? aircraftTypeName;
  final String? family;
  final String? manufacturerName;
  final String? engineName;
  final String? status;

  const AircraftModelEntity({
    required this.id,
    required this.name,
    this.aircraftTypeName,
    this.family,
    this.manufacturerName,
    this.engineName,
    this.status,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    aircraftTypeName,
    family,
    manufacturerName,
    engineName,
    status,
  ];
}
