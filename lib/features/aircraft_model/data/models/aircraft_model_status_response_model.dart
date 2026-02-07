import 'dart:convert';

import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_status_response_entity.dart';

/// Response model for aircraft model status update operations (activate/deactivate)
/// Backend response format:
/// {
///   "success": true,
///   "code": "MOD_AM_ACT_EXI_04201",
///   "message": "The aircraft model has been activated successfully",
///   "data": {
///     "id": "...",
///     "status": "active",
///     "updated": true,
///     "_links": [...]
///   }
/// }
class AircraftModelStatusResponseModel
    extends AircraftModelStatusResponseEntity {
  const AircraftModelStatusResponseModel({
    required super.success,
    required super.code,
    required super.message,
    super.id,
    super.status,
    super.updated,
  });

  factory AircraftModelStatusResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return AircraftModelStatusResponseModel(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      id: data?['id'],
      status: data?['status'],
      updated: data?['updated'],
    );
  }

  factory AircraftModelStatusResponseModel.fromJsonString(String str) {
    return AircraftModelStatusResponseModel.fromJson(json.decode(str));
  }

  /// Creates an error response model from a JSON error response
  factory AircraftModelStatusResponseModel.fromError(
    Map<String, dynamic> json,
  ) {
    return AircraftModelStatusResponseModel(
      success: json['success'] ?? false,
      code: json['code'] ?? 'UNKNOWN_ERROR',
      message: json['message'] ?? 'An unknown error occurred',
    );
  }
}
