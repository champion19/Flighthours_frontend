import 'package:flight_hours_app/features/flight/domain/entities/flight_entity.dart';

/// Flight data model — handles JSON serialization/deserialization
class FlightModel extends FlightEntity {
  const FlightModel({
    required super.id,
    super.dailyLogbookId,
    super.flightNumber,
    super.flightRealDate,
    super.airlineRouteId,
    super.routeCode,
    super.originIataCode,
    super.destinationIataCode,
    super.airlineCode,
    super.licensePlateId,
    super.licensePlate,
    super.modelName,
    super.outTime,
    super.takeoffTime,
    super.landingTime,
    super.inTime,
    super.airTime,
    super.blockTime,
    super.dutyTime,
    super.pilotRole,
    super.companionName,
    super.passengers,
    super.approachType,
    super.flightType,
  });

  /// Parse from backend JSON (snake_case)
  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['id']?.toString() ?? '',
      dailyLogbookId: json['daily_logbook_id']?.toString(),
      flightNumber: json['flight_number']?.toString(),
      flightRealDate: _parseDate(json['flight_real_date']),
      airlineRouteId: json['airline_route_id']?.toString(),
      routeCode: json['route_code']?.toString(),
      originIataCode: json['origin_iata_code']?.toString(),
      destinationIataCode: json['destination_iata_code']?.toString(),
      airlineCode: json['airline_code']?.toString(),
      licensePlateId: json['license_plate_id']?.toString(),
      licensePlate: json['license_plate']?.toString(),
      modelName: json['model_name']?.toString(),
      outTime: json['out_time']?.toString(),
      takeoffTime: json['takeoff_time']?.toString(),
      landingTime: json['landing_time']?.toString(),
      inTime: json['in_time']?.toString(),
      airTime: json['air_time']?.toString(),
      blockTime: json['block_time']?.toString(),
      dutyTime: json['duty_time']?.toString(),
      pilotRole: json['pilot_role']?.toString(),
      companionName: json['companion_name']?.toString(),
      passengers:
          json['passengers'] is int
              ? json['passengers']
              : int.tryParse(json['passengers']?.toString() ?? ''),
      approachType: json['approach_type']?.toString(),
      flightType: json['flight_type']?.toString(),
    );
  }

  /// Parse date from ISO string
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  /// Build the request body for POST /daily-logbooks/:id/details
  static Map<String, dynamic> createRequest({
    required String flightRealDate,
    required String flightNumber,
    required String airlineRouteId,
    required String licensePlateId,
    int? passengers,
    String? outTime,
    String? takeoffTime,
    String? landingTime,
    String? inTime,
    String? pilotRole,
    String? companionName,
    String? airTime,
    String? blockTime,
    String? dutyTime,
    String? approachType,
    String? flightType,
  }) {
    final map = <String, dynamic>{
      'flight_real_date': flightRealDate,
      'flight_number': flightNumber,
      'airline_route_id': airlineRouteId,
      'license_plate_id': licensePlateId,
    };
    if (passengers != null) map['passengers'] = passengers;
    if (outTime != null) map['out_time'] = outTime;
    if (takeoffTime != null) map['takeoff_time'] = takeoffTime;
    if (landingTime != null) map['landing_time'] = landingTime;
    if (inTime != null) map['in_time'] = inTime;
    if (pilotRole != null) map['pilot_role'] = pilotRole;
    if (companionName != null) map['companion_name'] = companionName;
    if (airTime != null) map['air_time'] = airTime;
    if (blockTime != null) map['block_time'] = blockTime;
    if (dutyTime != null) map['duty_time'] = dutyTime;
    if (approachType != null) map['approach_type'] = approachType;
    if (flightType != null) map['flight_type'] = flightType;
    return map;
  }

  /// Build the request body for PUT /daily-logbook-details/:id
  static Map<String, dynamic> updateRequest({
    required String flightRealDate,
    required String flightNumber,
    required String airlineRouteId,
    required String licensePlateId,
    int? passengers,
    String? outTime,
    String? takeoffTime,
    String? landingTime,
    String? inTime,
    String? pilotRole,
    String? companionName,
    String? airTime,
    String? blockTime,
    String? dutyTime,
    String? approachType,
    String? flightType,
  }) {
    return createRequest(
      flightRealDate: flightRealDate,
      flightNumber: flightNumber,
      airlineRouteId: airlineRouteId,
      licensePlateId: licensePlateId,
      passengers: passengers,
      outTime: outTime,
      takeoffTime: takeoffTime,
      landingTime: landingTime,
      inTime: inTime,
      pilotRole: pilotRole,
      companionName: companionName,
      airTime: airTime,
      blockTime: blockTime,
      dutyTime: dutyTime,
      approachType: approachType,
      flightType: flightType,
    );
  }
}
