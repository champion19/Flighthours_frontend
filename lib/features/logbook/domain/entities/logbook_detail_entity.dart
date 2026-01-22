import 'package:equatable/equatable.dart';

/// Represents a flight segment (detail) within a Daily Logbook
/// Contains all flight information: times, route, aircraft, pilot role, etc.
class LogbookDetailEntity extends Equatable {
  final String id; // Obfuscated ID
  final String? uuid; // Real UUID from database
  final String? dailyLogbookId; // Parent logbook reference

  // Flight identification
  final String? flightNumber; // e.g., "4043"
  final DateTime? flightRealDate; // Actual flight date
  final DateTime? logDate; // Logbook date

  // Route information (denormalized from airline_route)
  final String? airlineRouteId;
  final String? routeCode; // e.g., "MDE-BOG"
  final String? originIataCode; // e.g., "MDE"
  final String? destinationIataCode; // e.g., "BOG"
  final String? airlineCode; // e.g., "AV"

  // Aircraft information (denormalized from aircraft_registration)
  final String? actualAircraftRegistrationId;
  final String? licensePlate; // e.g., "CC-BAQ"
  final String? modelName; // e.g., "A320-112"

  // Time tracking (format HH:MM:SS)
  final String? outTime; // Block out
  final String? takeoffTime; // Off
  final String? landingTime; // On
  final String? inTime; // Block in
  final String? airTime; // Calculated: landing - takeoff
  final String? blockTime; // Calculated: in - out
  final String? dutyTime; // Service time

  // Pilot information
  final String? pilotRole; // PF, PM, PFL, PFTO
  final String? companionName; // Name of the other pilot

  // Flight details
  final int? passengers;
  final String? approachType; // NPA, PA, APV, VISUAL
  final String? flightType; // Comercial, Training, etc.

  const LogbookDetailEntity({
    required this.id,
    this.uuid,
    this.dailyLogbookId,
    this.flightNumber,
    this.flightRealDate,
    this.logDate,
    this.airlineRouteId,
    this.routeCode,
    this.originIataCode,
    this.destinationIataCode,
    this.airlineCode,
    this.actualAircraftRegistrationId,
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

  /// Returns a display-friendly detail ID
  String get displayId {
    if (id.length > 8) {
      return 'FL-${id.substring(0, 4).toUpperCase()}';
    }
    return 'FL-$id';
  }

  /// Returns route display (e.g., "MDE-BOG")
  String get routeDisplay {
    if (routeCode != null && routeCode!.isNotEmpty) {
      return routeCode!;
    }
    if (originIataCode != null && destinationIataCode != null) {
      return '$originIataCode-$destinationIataCode';
    }
    return 'Unknown Route';
  }

  /// Returns formatted date for display (e.g., "10/26/23")
  String get formattedDate {
    final date = flightRealDate ?? logDate;
    if (date == null) return 'Unknown';
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}';
  }

  /// Returns start time (out_time) formatted as HH:MM
  String get startTime {
    if (outTime == null) return '--:--';
    return _formatTime(outTime!);
  }

  /// Returns end time (in_time) formatted as HH:MM
  String get endTime {
    if (inTime == null) return '--:--';
    return _formatTime(inTime!);
  }

  /// Returns pilot role display
  String get displayPilotRole => pilotRole ?? 'Unknown';

  /// Helper to format time from HH:MM:SS to HH:MM
  String _formatTime(String time) {
    final parts = time.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return time;
  }

  /// Returns full aircraft display (e.g., "CC-BAQ (A320)")
  String get aircraftDisplay {
    if (licensePlate != null && modelName != null) {
      // Extract short model name (e.g., "A320" from "A320-112")
      final shortModel = modelName!.split('-').first;
      return '$licensePlate ($shortModel)';
    }
    return licensePlate ?? modelName ?? 'Unknown Aircraft';
  }

  @override
  List<Object?> get props => [
    id,
    uuid,
    dailyLogbookId,
    flightNumber,
    flightRealDate,
    logDate,
    airlineRouteId,
    routeCode,
    originIataCode,
    destinationIataCode,
    airlineCode,
    actualAircraftRegistrationId,
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
