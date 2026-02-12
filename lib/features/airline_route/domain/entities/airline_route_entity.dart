import 'package:equatable/equatable.dart';

/// Represents an airline route association
/// Links an airline with a specific route and its operational status
class AirlineRouteEntity extends Equatable {
  final String id; // Obfuscated ID (for display like AR-0125)
  final String? uuid; // Real UUID from database
  final String routeId; // ID of the associated route
  final String airlineId; // ID of the associated airline
  final String? routeName; // Route display name (e.g., "JFK → LAX")
  final String? airlineName; // Airline name (e.g., "Global Air")
  final String? airlineCode; // Airline code (e.g., "AV")
  final String? originAirportCode; // Origin IATA code (e.g., "JFK")
  final String? destinationAirportCode; // Destination IATA code (e.g., "LAX")
  final String? status; // "active", "inactive", "pending"

  const AirlineRouteEntity({
    required this.id,
    this.uuid,
    required this.routeId,
    required this.airlineId,
    this.routeName,
    this.airlineName,
    this.airlineCode,
    this.originAirportCode,
    this.destinationAirportCode,
    this.status,
  });

  /// Returns a display-friendly airline route ID (e.g., "AR-0125")
  String get displayId {
    // If the ID is long (like a hash), create a friendly display ID
    if (id.length > 8) {
      // Use first 4 characters of the hash for display
      return 'AR-${id.substring(0, 4).toUpperCase()}';
    }
    // If already short, just prefix with AR-
    return 'AR-$id';
  }

  /// Returns the route display string (e.g., "JFK → LAX")
  String get routeDisplay {
    if (originAirportCode != null && destinationAirportCode != null) {
      return '$originAirportCode → $destinationAirportCode';
    }
    return routeName ?? 'Unknown Route';
  }

  /// Returns normalized status for display
  String get displayStatus {
    final normalizedStatus = (status ?? 'unknown').toLowerCase();
    switch (normalizedStatus) {
      case 'active':
        return 'Active';
      case 'inactive':
        return 'Inactive';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  /// Returns whether the route is active
  bool get isActive => (status ?? '').toLowerCase() == 'active';

  /// Returns whether the route is pending
  bool get isPending => (status ?? '').toLowerCase() == 'pending';

  /// Returns whether the route is inactive
  bool get isInactive => (status ?? '').toLowerCase() == 'inactive';

  @override
  List<Object?> get props => [
    id,
    uuid,
    routeId,
    airlineId,
    routeName,
    airlineName,
    airlineCode,
    originAirportCode,
    destinationAirportCode,
    status,
  ];
}
