import 'package:equatable/equatable.dart';

/// Represents a flight route between two airports
class RouteEntity extends Equatable {
  final String id; // Obfuscated ID (for display like FR-456)
  final String? uuid; // Real UUID from database
  final String originAirportId;
  final String destinationAirportId;
  final String? originAirportName;
  final String? originAirportCode; // IATA code (e.g., "JFK")
  final String? originCountry;
  final String? destinationAirportName;
  final String? destinationAirportCode; // IATA code (e.g., "LHR")
  final String? destinationCountry;
  final String? routeType; // "Internacional" or "Nacional"
  final String? estimatedFlightTime; // Format "HH:MM:SS"
  final String? status;

  const RouteEntity({
    required this.id,
    this.uuid,
    required this.originAirportId,
    required this.destinationAirportId,
    this.originAirportName,
    this.originAirportCode,
    this.originCountry,
    this.destinationAirportName,
    this.destinationAirportCode,
    this.destinationCountry,
    this.routeType,
    this.estimatedFlightTime,
    this.status,
  });

  /// Returns a display-friendly route ID (e.g., "FR-456")
  String get displayId {
    // If the ID looks like a UUID, create a friendly display ID
    if (id.length > 8) {
      // Use first 3 characters of the hash for display
      return 'FR-${id.substring(0, 3).toUpperCase()}';
    }
    return 'FR-$id';
  }

  /// Returns formatted estimated flight time (e.g., "7h 30m")
  String get formattedFlightTime {
    if (estimatedFlightTime == null || estimatedFlightTime!.isEmpty) {
      return 'N/A';
    }

    // Parse HH:MM:SS format
    final parts = estimatedFlightTime!.split(':');
    if (parts.length >= 2) {
      final hours = int.tryParse(parts[0]) ?? 0;
      final minutes = int.tryParse(parts[1]) ?? 0;

      if (hours > 0 && minutes > 0) {
        return '${hours}h ${minutes}m';
      } else if (hours > 0) {
        return '${hours}h';
      } else if (minutes > 0) {
        return '${minutes}m';
      }
    }
    return estimatedFlightTime!;
  }

  /// Returns route countries display (e.g., "United States → United Kingdom")
  String get countriesDisplay {
    final origin = originCountry ?? 'Unknown';
    final destination = destinationCountry ?? 'Unknown';
    return '$origin → $destination';
  }

  /// Returns whether this is an international route
  bool get isInternational {
    if (routeType != null) {
      return routeType!.toLowerCase().contains('internacional');
    }
    // Fallback: check if countries are different
    return originCountry != destinationCountry;
  }

  @override
  List<Object?> get props => [
    id,
    uuid,
    originAirportId,
    destinationAirportId,
    originAirportName,
    originAirportCode,
    originCountry,
    destinationAirportName,
    destinationAirportCode,
    destinationCountry,
    routeType,
    estimatedFlightTime,
    status,
  ];
}
