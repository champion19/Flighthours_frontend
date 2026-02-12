import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';

/// Model class that extends AirlineRouteEntity and provides JSON serialization
class AirlineRouteModel extends AirlineRouteEntity {
  const AirlineRouteModel({
    required super.id,
    super.uuid,
    required super.routeId,
    required super.airlineId,
    super.routeName,
    super.airlineName,
    super.airlineCode,
    super.originAirportCode,
    super.destinationAirportCode,
    super.status,
  });

  /// Factory constructor to create AirlineRouteModel from JSON
  ///
  /// Expected backend response format:
  /// {
  ///   "id": "obfuscated_id",
  ///   "uuid": "real-uuid",
  ///   "route_id": "...",
  ///   "airline_id": "...",
  ///   "route_name": "JFK → LAX",
  ///   "airline_name": "Global Air",
  ///   "origin_airport_code": "JFK",
  ///   "destination_airport_code": "LAX",
  ///   "status": "active"
  /// }
  factory AirlineRouteModel.fromJson(Map<String, dynamic> json) {
    return AirlineRouteModel(
      id: json['id']?.toString() ?? '',
      uuid: json['uuid']?.toString(),
      routeId: json['route_id']?.toString() ?? '',
      airlineId: json['airline_id']?.toString() ?? '',
      routeName: json['route_name']?.toString(),
      airlineName: json['airline_name']?.toString(),
      airlineCode: json['airline_code']?.toString(),
      originAirportCode:
          (json['origin_airport_code'] ?? json['origin_iata_code'])?.toString(),
      destinationAirportCode:
          (json['destination_airport_code'] ?? json['destination_iata_code'])
              ?.toString(),
      status: _parseStatus(json['status']),
    );
  }

  /// Parse status from various types (bool, string)
  static String? _parseStatus(dynamic value) {
    if (value == null) return null;
    if (value is bool) {
      return value ? 'active' : 'inactive';
    }
    return value.toString();
  }

  /// Convert AirlineRouteModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'route_id': routeId,
      'airline_id': airlineId,
      'route_name': routeName,
      'airline_name': airlineName,
      'airline_code': airlineCode,
      'origin_airport_code': originAirportCode,
      'destination_airport_code': destinationAirportCode,
      'status': status,
    };
  }
}
