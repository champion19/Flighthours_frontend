import 'dart:convert';

import 'package:flight_hours_app/features/crew_member_type/domain/entities/crew_member_type_entity.dart';

/// Parses crew member types list from JSON string
/// Backend response format (assumed):
/// {
///   "success": true,
///   "data": {
///     "crew_member_types": [
///       {"id": "...", "name": "Pilot", "description": "...", "status": "active"}
///     ],
///     "total": 2
///   }
/// }
List<CrewMemberTypeModel> crewMemberTypeModelFromMap(String str) {
  final decoded = json.decode(str);

  if (decoded is Map<String, dynamic>) {
    if (decoded.containsKey('data')) {
      final data = decoded['data'];
      if (data is Map<String, dynamic> &&
          data.containsKey('crew_member_types')) {
        final types = data['crew_member_types'];
        if (types is List) {
          return List<CrewMemberTypeModel>.from(
            types.map(
              (x) => CrewMemberTypeModel.fromJson(x as Map<String, dynamic>),
            ),
          );
        }
      }
      if (data is List) {
        return List<CrewMemberTypeModel>.from(
          data.map(
            (x) => CrewMemberTypeModel.fromJson(x as Map<String, dynamic>),
          ),
        );
      }
    }
  }

  if (decoded is List) {
    return List<CrewMemberTypeModel>.from(
      decoded.map(
        (x) => CrewMemberTypeModel.fromJson(x as Map<String, dynamic>),
      ),
    );
  }

  return [];
}

class CrewMemberTypeModel extends CrewMemberTypeEntity {
  const CrewMemberTypeModel({
    required super.id,
    super.uuid,
    super.name,
    super.description,
    super.status,
  });

  factory CrewMemberTypeModel.fromJson(Map<String, dynamic> json) {
    return CrewMemberTypeModel(
      id: json['id'] ?? '',
      uuid: json['uuid'],
      name: json['name'] ?? json['crew_member_type_name'],
      description: json['description'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'description': description,
      'status': status,
    };
  }
}
