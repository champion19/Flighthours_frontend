import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';

/// Model class for Logbook Detail (flight segment) that extends the entity
/// Provides JSON serialization/deserialization
class LogbookDetailModel extends LogbookDetailEntity {
  const LogbookDetailModel({
    required super.id,
    super.uuid,
    super.dailyLogbookId,
    super.flightNumber,
    super.flightRealDate,
    super.logDate,
    super.airlineRouteId,
    super.routeCode,
    super.originIataCode,
    super.destinationIataCode,
    super.airlineCode,
    super.actualAircraftRegistrationId,
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

  /// Factory constructor to create LogbookDetailModel from JSON
  ///
  /// Expected backend response format (from GET /daily-logbooks/:id/details):
  /// {
  ///   "id": "XwdEsEKzC83JFr1zSXL6T8wcvP1Hd4W",
  ///   "uuid": "FCDE13AF-66B1-431E-AF58-013DBB61E7F2",
  ///   "daily_logbook_id": "RZDtPJJtD3JCEZ4HDr2fZMxiD8PtQLL",
  ///   "flight_real_date": "2025-12-14T00:00:00-05:00",
  ///   "flight_number": "4043",
  ///   "airline_route_id": "Z26wt6QYsMY2UZz9ioXoiXktz8NuaJK",
  ///   "actual_aircraft_registration_id": "RrydfpW2u8QGhKYoH8LptV3JcJ5NCGQ5",
  ///   "passengers": 174,
  ///   "out_time": "21:17:00",
  ///   "takeoff_time": "21:35:00",
  ///   "landing_time": "22:04:00",
  ///   "in_time": "22:07:00",
  ///   "pilot_role": "PM",
  ///   "companion_name": "David Ramirez",
  ///   "air_time": "00:29:00",
  ///   "block_time": "00:50:00",
  ///   "duty_time": "10:14:00",
  ///   "approach_type": "VISUAL",
  ///   "flight_type": "Comercial",
  ///   "log_date": "2026-01-07T00:00:00-05:00",
  ///   "route_code": "MDE-BOG",
  ///   "origin_iata_code": "MDE",
  ///   "destination_iata_code": "BOG",
  ///   "airline_code": "AV",
  ///   "license_plate": "CC-BAQ",
  ///   "model_name": "A320-112"
  /// }
  factory LogbookDetailModel.fromJson(Map<String, dynamic> json) {
    return LogbookDetailModel(
      id: json['id']?.toString() ?? '',
      uuid: json['uuid']?.toString(),
      dailyLogbookId: json['daily_logbook_id']?.toString(),
      flightNumber: json['flight_number']?.toString(),
      flightRealDate: _parseDate(json['flight_real_date']),
      logDate: _parseDate(json['log_date']),
      airlineRouteId: json['airline_route_id']?.toString(),
      routeCode: json['route_code']?.toString(),
      originIataCode: json['origin_iata_code']?.toString(),
      destinationIataCode: json['destination_iata_code']?.toString(),
      airlineCode: json['airline_code']?.toString(),
      actualAircraftRegistrationId:
          json['actual_aircraft_registration_id']?.toString(),
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
      passengers: _parseInt(json['passengers']),
      approachType: json['approach_type']?.toString(),
      flightType: json['flight_type']?.toString(),
    );
  }

  /// Parse date from various formats
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  /// Parse int from various types
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (uuid != null) 'uuid': uuid,
      if (dailyLogbookId != null) 'daily_logbook_id': dailyLogbookId,
      if (flightNumber != null) 'flight_number': flightNumber,
      if (flightRealDate != null)
        'flight_real_date': _formatDate(flightRealDate!),
      if (airlineRouteId != null) 'airline_route_id': airlineRouteId,
      if (actualAircraftRegistrationId != null)
        'actual_aircraft_registration_id': actualAircraftRegistrationId,
      if (passengers != null) 'passengers': passengers,
      if (outTime != null) 'out_time': outTime,
      if (takeoffTime != null) 'takeoff_time': takeoffTime,
      if (landingTime != null) 'landing_time': landingTime,
      if (inTime != null) 'in_time': inTime,
      if (pilotRole != null) 'pilot_role': pilotRole,
      if (companionName != null) 'companion_name': companionName,
      if (airTime != null) 'air_time': airTime,
      if (blockTime != null) 'block_time': blockTime,
      if (dutyTime != null) 'duty_time': dutyTime,
      if (approachType != null) 'approach_type': approachType,
      if (flightType != null) 'flight_type': flightType,
    };
  }

  /// Format date for API (YYYY-MM-DD)
  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Create request body for creating a new logbook detail
  static Map<String, dynamic> createRequest({
    required String flightRealDate,
    required String flightNumber,
    required String airlineRouteId,
    required String actualAircraftRegistrationId,
    required int passengers,
    required String outTime,
    required String takeoffTime,
    required String landingTime,
    required String inTime,
    required String pilotRole,
    required String companionName,
    required String airTime,
    required String blockTime,
    required String dutyTime,
    required String approachType,
    required String flightType,
  }) {
    return {
      'flight_real_date': flightRealDate,
      'flight_number': flightNumber,
      'airline_route_id': airlineRouteId,
      'actual_aircraft_registration_id': actualAircraftRegistrationId,
      'passengers': passengers,
      'out_time': outTime,
      'takeoff_time': takeoffTime,
      'landing_time': landingTime,
      'in_time': inTime,
      'pilot_role': pilotRole,
      'companion_name': companionName,
      'air_time': airTime,
      'block_time': blockTime,
      'duty_time': dutyTime,
      'approach_type': approachType,
      'flight_type': flightType,
    };
  }

  /// Create request body for updating a logbook detail
  static Map<String, dynamic> updateRequest({
    required String flightRealDate,
    required String flightNumber,
    required String airlineRouteId,
    required String actualAircraftRegistrationId,
    required int passengers,
    required String outTime,
    required String takeoffTime,
    required String landingTime,
    required String inTime,
    required String pilotRole,
    required String companionName,
    required String airTime,
    required String blockTime,
    required String dutyTime,
    required String approachType,
    required String flightType,
  }) {
    return createRequest(
      flightRealDate: flightRealDate,
      flightNumber: flightNumber,
      airlineRouteId: airlineRouteId,
      actualAircraftRegistrationId: actualAircraftRegistrationId,
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
