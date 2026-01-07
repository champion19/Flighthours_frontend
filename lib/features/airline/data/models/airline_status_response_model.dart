import 'dart:convert';

/// Response model for airline status update operations (activate/deactivate)
/// Backend response format:
/// {
///   "success": true,
///   "code": "MOD_AIR_ACTIVATE_EXI_00002",
///   "message": "The airline has been activated successfully",
///   "data": {
///     "id": "...",
///     "status": "active",
///     "updated": true,
///     "_links": [...]
///   }
/// }
class AirlineStatusResponseModel {
  final bool success;
  final String code;
  final String message;
  final String? id;
  final String? status;
  final bool? updated;

  const AirlineStatusResponseModel({
    required this.success,
    required this.code,
    required this.message,
    this.id,
    this.status,
    this.updated,
  });

  factory AirlineStatusResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return AirlineStatusResponseModel(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      id: data?['id'],
      status: data?['status'],
      updated: data?['updated'],
    );
  }

  factory AirlineStatusResponseModel.fromJsonString(String str) {
    return AirlineStatusResponseModel.fromJson(json.decode(str));
  }

  /// Creates an error response model from a JSON error response
  factory AirlineStatusResponseModel.fromError(Map<String, dynamic> json) {
    return AirlineStatusResponseModel(
      success: json['success'] ?? false,
      code: json['code'] ?? 'UNKNOWN_ERROR',
      message: json['message'] ?? 'An unknown error occurred',
    );
  }
}
