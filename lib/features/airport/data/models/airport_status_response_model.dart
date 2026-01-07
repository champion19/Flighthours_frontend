import 'dart:convert';

/// Response model for airport status update operations (activate/deactivate)
/// Backend response format:
/// {
///   "success": true,
///   "code": "MOD_APT_ACTIVATE_EXI_00002",
///   "message": "The airport has been activated successfully",
///   "data": {
///     "id": "...",
///     "status": "active",
///     "updated": true,
///     "_links": [...]
///   }
/// }
class AirportStatusResponseModel {
  final bool success;
  final String code;
  final String message;
  final String? id;
  final String? status;
  final bool? updated;

  const AirportStatusResponseModel({
    required this.success,
    required this.code,
    required this.message,
    this.id,
    this.status,
    this.updated,
  });

  factory AirportStatusResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return AirportStatusResponseModel(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      id: data?['id'],
      status: data?['status'],
      updated: data?['updated'],
    );
  }

  factory AirportStatusResponseModel.fromJsonString(String str) {
    return AirportStatusResponseModel.fromJson(json.decode(str));
  }

  /// Creates an error response model from a JSON error response
  factory AirportStatusResponseModel.fromError(Map<String, dynamic> json) {
    return AirportStatusResponseModel(
      success: json['success'] ?? false,
      code: json['code'] ?? 'UNKNOWN_ERROR',
      message: json['message'] ?? 'An unknown error occurred',
    );
  }
}
