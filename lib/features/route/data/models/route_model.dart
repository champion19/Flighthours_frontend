import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';

/// Model class that extends RouteEntity and provides JSON serialization
class RouteModel extends RouteEntity {
  const RouteModel({
    required super.id,
    super.uuid,
    required super.originAirportId,
    required super.destinationAirportId,
    super.originAirportName,
    super.originAirportCode,
    super.originCountry,
    super.destinationAirportName,
    super.destinationAirportCode,
    super.destinationCountry,
    super.routeType,
    super.estimatedFlightTime,
    super.status,
  });

  /// Factory constructor to create RouteModel from JSON
  ///
  /// Expected backend response format:
  /// {
  ///   "id": "obfuscated_id",
  ///   "uuid": "real-uuid",
  ///   "origin_airport_id": "...",
  ///   "destination_airport_id": "...",
  ///   "origin_airport_name": "John F. Kennedy International",
  ///   "origin_airport_code": "JFK",
  ///   "origin_country": "United States",
  ///   "destination_airport_name": "London Heathrow",
  ///   "destination_airport_code": "LHR",
  ///   "destination_country": "United Kingdom",
  ///   "route_type": "Internacional",
  ///   "estimated_flight_time": "07:30:00",
  ///   "status": "active"
  /// }
  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id']?.toString() ?? '',
      uuid: json['uuid'],
      originAirportId: json['origin_airport_id']?.toString() ?? '',
      destinationAirportId: json['destination_airport_id']?.toString() ?? '',
      originAirportName: json['origin_airport_name'],
      originAirportCode:
          json['origin_airport_code'] ?? json['origin_iata_code'],
      originCountry: json['origin_country'],
      destinationAirportName: json['destination_airport_name'],
      destinationAirportCode:
          json['destination_airport_code'] ?? json['destination_iata_code'],
      destinationCountry: json['destination_country'],
      routeType: json['route_type'],
      estimatedFlightTime: json['estimated_flight_time'],
      status: json['status'],
    );
  }

  /// Convert RouteModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'origin_airport_id': originAirportId,
      'destination_airport_id': destinationAirportId,
      'origin_airport_name': originAirportName,
      'origin_airport_code': originAirportCode,
      'origin_country': originCountry,
      'destination_airport_name': destinationAirportName,
      'destination_airport_code': destinationAirportCode,
      'destination_country': destinationCountry,
      'route_type': routeType,
      'estimated_flight_time': estimatedFlightTime,
      'status': status,
    };
  }
}
