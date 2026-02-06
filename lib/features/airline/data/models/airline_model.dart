import 'dart:convert';

import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';

/// Parses airline list from JSON string
/// Backend response format:
/// {
///   "success": true,
///   "data": {
///     "airlines": [
///       {"id": "...", "airline_name": "Avianca", "airline_code": "AV", "status": "1"}
///     ],
///     "total": 3
///   }
/// }
List<AirlineModel> airlineModelFromMap(String str) {
  final decoded = json.decode(str);

  // Expected format: {success: true, data: {airlines: [...]}}
  if (decoded is Map<String, dynamic>) {
    // Check for data.airlines structure
    if (decoded.containsKey('data')) {
      final data = decoded['data'];
      if (data is Map<String, dynamic> && data.containsKey('airlines')) {
        final airlines = data['airlines'];
        if (airlines is List) {
          return List<AirlineModel>.from(
            airlines.map(
              (x) => AirlineModel.fromJson(x as Map<String, dynamic>),
            ),
          );
        }
      }
      // Fallback: data is directly an array
      if (data is List) {
        return List<AirlineModel>.from(
          data.map((x) => AirlineModel.fromJson(x as Map<String, dynamic>)),
        );
      }
    }
  }

  // Direct array response
  if (decoded is List) {
    return List<AirlineModel>.from(
      decoded.map((x) => AirlineModel.fromJson(x as Map<String, dynamic>)),
    );
  }

  return [];
}

String airlineModelToMap(List<AirlineModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AirlineModel extends AirlineEntity {
  const AirlineModel({
    required super.id,
    super.uuid,
    required super.name,
    super.code,
    super.active,
  });

  factory AirlineModel.fromJson(Map<String, dynamic> json) {
    // Parse status: "1" or 1 = active, "0" or 0 = inactive
    final statusValue = json['status'];
    final isActive =
        statusValue == '1' || statusValue == 1 || statusValue == true;

    return AirlineModel(
      id: json['id'] ?? '',
      uuid: json['uuid'],
      // Support both 'name' and 'airline_name' field names
      name: json['name'] ?? json['airline_name'] ?? '',
      // Support both 'code' and 'airline_code' field names
      code: json['code'] ?? json['airline_code'],
      active: isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'code': code,
      'status': active ? '1' : '0',
    };
  }
}
