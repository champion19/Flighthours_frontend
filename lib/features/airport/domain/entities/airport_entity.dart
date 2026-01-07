import 'package:equatable/equatable.dart';

class AirportEntity extends Equatable {
  final String id; // Obfuscated ID
  final String? uuid; // Real UUID from database
  final String name;
  final String? code; // Legacy field for backwards compatibility
  final String? iataCode; // IATA code (e.g., "MDE", "BOG")
  final String? city;
  final String? country;
  final String? status; // "active" or "inactive"
  final String? airportType; // e.g., "Internacional", "Nacional"

  const AirportEntity({
    required this.id,
    this.uuid,
    required this.name,
    this.code,
    this.iataCode,
    this.city,
    this.country,
    this.status,
    this.airportType,
  });

  @override
  List<Object?> get props => [
    id,
    uuid,
    name,
    code,
    iataCode,
    city,
    country,
    status,
    airportType,
  ];
}
