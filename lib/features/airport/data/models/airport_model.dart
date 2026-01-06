import 'dart:convert';

import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';

/// Parses airport list from JSON string
/// Backend response format:
/// {
///   "success": true,
///   "data": {
///     "airports": [
///       {"id": "...", "name": "El Dorado", "iata_code": "BOG", "city": "Bogota", ...}
///     ],
///     "total": 3
///   }
/// }
List<AirportModel> airportModelFromMap(String str) {
  final decoded = json.decode(str);

  // Expected format: {success: true, data: {airports: [...]}}
  if (decoded is Map<String, dynamic>) {
    // Check for data.airports structure
    if (decoded.containsKey('data')) {
      final data = decoded['data'];
      if (data is Map<String, dynamic> && data.containsKey('airports')) {
        final airports = data['airports'];
        if (airports is List) {
          return List<AirportModel>.from(
            airports.map(
              (x) => AirportModel.fromJson(x as Map<String, dynamic>),
            ),
          );
        }
      }
      // Fallback: data is directly an array
      if (data is List) {
        return List<AirportModel>.from(
          data.map((x) => AirportModel.fromJson(x as Map<String, dynamic>)),
        );
      }
    }
  }

  // Direct array response
  if (decoded is List) {
    return List<AirportModel>.from(
      decoded.map((x) => AirportModel.fromJson(x as Map<String, dynamic>)),
    );
  }

  return [];
}

String airportModelToMap(List<AirportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AirportModel extends AirportEntity {
  const AirportModel({
    required super.id,
    super.uuid,
    required super.name,
    super.code,
    super.iataCode,
    super.city,
    super.country,
    super.status,
    super.airportType,
  });

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      id: json['id'] ?? '',
      uuid: json['uuid'],
      // Support both 'name' and 'airport_name' field names
      name: json['name'] ?? json['airport_name'] ?? '',
      // Support legacy 'code' and new 'iata_code'/'airport_code' field names
      code: json['code'] ?? json['airport_code'] ?? json['iata_code'],
      iataCode: json['iata_code'] ?? json['airport_code'] ?? json['code'],
      city: json['city'],
      country: json['country'],
      status: json['status'],
      airportType: json['airport_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'code': code,
      'iata_code': iataCode,
      'city': city,
      'country': country,
      'status': status,
      'airport_type': airportType,
    };
  }
}
