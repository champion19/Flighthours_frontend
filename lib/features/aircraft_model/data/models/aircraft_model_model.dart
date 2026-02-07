import 'dart:convert';

import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';

/// Parses aircraft model list from JSON string
/// Backend response format:
/// {
///   "success": true,
///   "data": {
///     "aircraftModels": [
///       {"id": "...", "name": "A320-200", "aircraft_type_name": "Passenger", ...}
///     ],
///     "total": 3
///   }
/// }
List<AircraftModelModel> aircraftModelModelFromMap(String str) {
  final decoded = json.decode(str);

  // Expected format: {success: true, data: {aircraftModels: [...]}}
  if (decoded is Map<String, dynamic>) {
    if (decoded.containsKey('data')) {
      final data = decoded['data'];
      if (data is Map<String, dynamic> && data.containsKey('aircraftModels')) {
        final models = data['aircraftModels'];
        if (models is List) {
          return List<AircraftModelModel>.from(
            models.map(
              (x) => AircraftModelModel.fromJson(x as Map<String, dynamic>),
            ),
          );
        }
      }
      // Fallback: data is directly an array
      if (data is List) {
        return List<AircraftModelModel>.from(
          data.map(
            (x) => AircraftModelModel.fromJson(x as Map<String, dynamic>),
          ),
        );
      }
    }
  }

  // Direct array response
  if (decoded is List) {
    return List<AircraftModelModel>.from(
      decoded.map(
        (x) => AircraftModelModel.fromJson(x as Map<String, dynamic>),
      ),
    );
  }

  return [];
}

String aircraftModelModelToMap(List<AircraftModelModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AircraftModelModel extends AircraftModelEntity {
  const AircraftModelModel({
    required super.id,
    required super.name,
    super.aircraftTypeName,
    super.family,
    super.manufacturerName,
    super.engineName,
    super.status,
  });

  factory AircraftModelModel.fromJson(Map<String, dynamic> json) {
    // status can be bool (from backend) or String
    final rawStatus = json['status'];
    String? statusStr;
    if (rawStatus is bool) {
      statusStr = rawStatus ? 'active' : 'inactive';
    } else if (rawStatus is String) {
      statusStr = rawStatus;
    }

    return AircraftModelModel(
      id: json['id'] ?? '',
      name:
          json['name'] ??
          json['model_name'] ??
          json['aircraft_model_name'] ??
          '',
      aircraftTypeName: json['aircraft_type_name'],
      family: json['family'],
      manufacturerName: json['manufacturer_name'] ?? json['manufacturer'],
      engineName: json['engine_name'] ?? json['engine_type_name'],
      status: statusStr,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'aircraft_type_name': aircraftTypeName,
      'family': family,
      'manufacturer_name': manufacturerName,
      'engine_name': engineName,
      'status': status,
    };
  }
}
