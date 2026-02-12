import 'package:equatable/equatable.dart';

/// Flight domain entity
///
/// Represents a flight record (daily logbook detail) from the backend.
/// Used across the presentation and domain layers.
class FlightEntity extends Equatable {
  final String id;
  final String? dailyLogbookId;
  final String? flightNumber;
  final DateTime? flightRealDate;

  // Route info
  final String? airlineRouteId;
  final String? routeCode;
  final String? originIataCode;
  final String? destinationIataCode;
  final String? airlineCode;

  // Aircraft info
  final String? licensePlateId;
  final String? licensePlate;
  final String? modelName;

  // Times
  final String? outTime;
  final String? takeoffTime;
  final String? landingTime;
  final String? inTime;
  final String? airTime;
  final String? blockTime;
  final String? dutyTime;

  // Crew
  final String? pilotRole;
  final String? companionName;

  // Details
  final int? passengers;
  final String? approachType;
  final String? flightType;

  const FlightEntity({
    required this.id,
    this.dailyLogbookId,
    this.flightNumber,
    this.flightRealDate,
    this.airlineRouteId,
    this.routeCode,
    this.originIataCode,
    this.destinationIataCode,
    this.airlineCode,
    this.licensePlateId,
    this.licensePlate,
    this.modelName,
    this.outTime,
    this.takeoffTime,
    this.landingTime,
    this.inTime,
    this.airTime,
    this.blockTime,
    this.dutyTime,
    this.pilotRole,
    this.companionName,
    this.passengers,
    this.approachType,
    this.flightType,
  });

  /// Display ID: FL-XXXX (first 4 chars uppercased)
  String get displayId {
    if (id.length > 4) {
      return 'FL-${id.substring(0, 4).toUpperCase()}';
    }
    return 'FL-${id.toUpperCase()}';
  }

  /// Route display: e.g. "MDE-BOG"
  String get routeDisplay {
    if (routeCode != null && routeCode!.isNotEmpty) return routeCode!;
    if (originIataCode != null && destinationIataCode != null) {
      return '$originIataCode-$destinationIataCode';
    }
    return 'Unknown Route';
  }

  /// Formatted date: MM/DD/YY
  String get formattedDate {
    if (flightRealDate != null) {
      final d = flightRealDate!;
      return '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${(d.year % 100).toString().padLeft(2, '0')}';
    }
    return 'Unknown';
  }

  /// Aircraft display: "CC-BAQ (A320)" or fallback
  String get aircraftDisplay {
    if (licensePlate != null && modelName != null) {
      final shortModel =
          modelName!.contains('-') ? modelName!.split('-').first : modelName!;
      return '$licensePlate ($shortModel)';
    }
    if (licensePlate != null) return licensePlate!;
    if (modelName != null) return modelName!;
    return 'Unknown Aircraft';
  }

  /// Format time string: keeps HH:MM from "HH:MM" or "HH:MM:SS"
  static String formatTime(String? time) {
    if (time == null || time.isEmpty) return '--:--';
    if (time.length >= 5) return time.substring(0, 5);
    return time;
  }

  String get startTime => formatTime(outTime);
  String get endTime => formatTime(inTime);
  String get displayPilotRole => pilotRole ?? 'Unknown';

  @override
  List<Object?> get props => [
    id,
    dailyLogbookId,
    flightNumber,
    flightRealDate,
    airlineRouteId,
    routeCode,
    originIataCode,
    destinationIataCode,
    airlineCode,
    licensePlateId,
    licensePlate,
    modelName,
    outTime,
    takeoffTime,
    landingTime,
    inTime,
    airTime,
    blockTime,
    dutyTime,
    pilotRole,
    companionName,
    passengers,
    approachType,
    flightType,
  ];
}
