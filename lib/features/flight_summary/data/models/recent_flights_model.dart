import 'dart:convert';

/// Response model for GET /employees/recent-flights
class RecentFlightsResponseModel {
  final bool success;
  final String code;
  final String message;
  final List<RecentFlightData> data;

  RecentFlightsResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory RecentFlightsResponseModel.fromJson(String str) =>
      RecentFlightsResponseModel.fromMap(json.decode(str));

  factory RecentFlightsResponseModel.fromMap(Map<String, dynamic> json) {
    final dataList = json["data"] as List<dynamic>? ?? [];
    return RecentFlightsResponseModel(
      success: json["success"] ?? false,
      code: json["code"] ?? '',
      message: json["message"] ?? '',
      data:
          dataList
              .map((d) => RecentFlightData.fromMap(d as Map<String, dynamic>))
              .toList(),
    );
  }
}

/// Complete flight entry — mirrors DailyLogbookDetailResponse from backend
class RecentFlightData {
  final String id;
  final String? dailyLogbookId;
  final String flightRealDate;
  final String flightNumber;
  final String? airlineRouteId;
  final String? tailNumberId;

  // Times
  final String? outTime;
  final String? takeoffTime;
  final String? landingTime;
  final String? inTime;
  final String? airTime;
  final String? blockTime;

  // Pilot info
  final String? pilotRole;
  final String? crewRole;
  final String? companionName;

  // Flight details
  final int? passengers;
  final String? approachType;
  final String? flightType;

  // Denormalized display fields
  final String? logDate;
  final String? routeCode;
  final String originIataCode;
  final String destinationIataCode;
  final String? airlineCode;
  final String? tailNumber;
  final String modelName;

  RecentFlightData({
    required this.id,
    this.dailyLogbookId,
    required this.flightRealDate,
    required this.flightNumber,
    this.airlineRouteId,
    this.tailNumberId,
    this.outTime,
    this.takeoffTime,
    this.landingTime,
    this.inTime,
    this.airTime,
    this.blockTime,
    this.pilotRole,
    this.crewRole,
    this.companionName,
    this.passengers,
    this.approachType,
    this.flightType,
    this.logDate,
    this.routeCode,
    required this.originIataCode,
    required this.destinationIataCode,
    this.airlineCode,
    this.tailNumber,
    required this.modelName,
  });

  factory RecentFlightData.fromMap(Map<String, dynamic> json) =>
      RecentFlightData(
        id: json["id"] ?? '',
        dailyLogbookId: json["daily_logbook_id"],
        flightRealDate: json["flight_real_date"] ?? '',
        flightNumber: json["flight_number"] ?? '',
        airlineRouteId: json["airline_route_id"],
        tailNumberId: json["tail_number_id"],
        outTime: json["out_time"],
        takeoffTime: json["takeoff_time"],
        landingTime: json["landing_time"],
        inTime: json["in_time"],
        airTime: json["air_time"],
        blockTime: json["block_time"],
        pilotRole: json["pilot_role"],
        crewRole: json["crew_role"],
        companionName: json["companion_name"],
        passengers: json["passengers"],
        approachType: json["approach_type"],
        flightType: json["flight_type"],
        logDate: json["log_date"],
        routeCode: json["route_code"],
        originIataCode: json["origin_iata_code"] ?? '',
        destinationIataCode: json["destination_iata_code"] ?? '',
        airlineCode: json["airline_code"],
        tailNumber: json["tail_number"],
        modelName: json["model_name"] ?? '',
      );

  /// Format date for display (e.g., "Feb 20, 2026")
  String get displayDate {
    final date = DateTime.tryParse(flightRealDate);
    if (date == null) return flightRealDate;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Display route as "BOG → MDE"
  String get displayRoute => '$originIataCode → $destinationIataCode';
}
