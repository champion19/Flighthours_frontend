import 'dart:convert';

import 'package:flight_hours_app/features/manufacturer/domain/entities/manufacturer_entity.dart';

/// Parses manufacturer list from JSON string
/// Backend response format:
/// {
///   "success": true,
///   "data": {
///     "manufacturers": [
///       {"id": "...", "manufacturer_name": "Boeing", "country": "USA", "status": "1"}
///     ],
///     "total": 3
///   }
/// }
List<ManufacturerModel> manufacturerModelFromMap(String str) {
  final decoded = json.decode(str);

  if (decoded is Map<String, dynamic>) {
    if (decoded.containsKey('data')) {
      final data = decoded['data'];
      if (data is Map<String, dynamic> && data.containsKey('manufacturers')) {
        final manufacturers = data['manufacturers'];
        if (manufacturers is List) {
          return List<ManufacturerModel>.from(
            manufacturers.map(
              (x) => ManufacturerModel.fromJson(x as Map<String, dynamic>),
            ),
          );
        }
      }
      if (data is List) {
        return List<ManufacturerModel>.from(
          data.map(
            (x) => ManufacturerModel.fromJson(x as Map<String, dynamic>),
          ),
        );
      }
    }
  }

  if (decoded is List) {
    return List<ManufacturerModel>.from(
      decoded.map((x) => ManufacturerModel.fromJson(x as Map<String, dynamic>)),
    );
  }

  return [];
}

class ManufacturerModel extends ManufacturerEntity {
  const ManufacturerModel({
    required super.id,
    super.uuid,
    required super.name,
    super.country,
    super.description,
    super.status,
  });

  factory ManufacturerModel.fromJson(Map<String, dynamic> json) {
    // Parse status: "1" or 1 = active, "0" or 0 = inactive
    final statusValue = json['status'];
    String parsedStatus = 'inactive';
    if (statusValue == '1' ||
        statusValue == 1 ||
        statusValue == true ||
        statusValue == 'active') {
      parsedStatus = 'active';
    }

    return ManufacturerModel(
      id: json['id'] ?? '',
      uuid: json['uuid'],
      name: json['name'] ?? json['manufacturer_name'] ?? '',
      country: json['country'],
      description: json['description'],
      status: parsedStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'country': country,
      'description': description,
      'status': status == 'active' ? '1' : '0',
    };
  }
}
