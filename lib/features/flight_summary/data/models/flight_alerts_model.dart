import 'dart:convert';

/// Response model for GET /employees/flight-alerts
class FlightAlertsResponseModel {
  final bool success;
  final String code;
  final String message;
  final FlightAlertsData? data;

  FlightAlertsResponseModel({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory FlightAlertsResponseModel.fromJson(String str) =>
      FlightAlertsResponseModel.fromMap(json.decode(str));

  factory FlightAlertsResponseModel.fromMap(
    Map<String, dynamic> json,
  ) => FlightAlertsResponseModel(
    success: json["success"] ?? false,
    code: json["code"] ?? '',
    message: json["message"] ?? '',
    data: json["data"] != null ? FlightAlertsData.fromMap(json["data"]) : null,
  );
}

/// Wrapper for the alerts array
class FlightAlertsData {
  final List<FlightAlertData> alerts;

  FlightAlertsData({required this.alerts});

  factory FlightAlertsData.fromMap(Map<String, dynamic> json) {
    final alertsList = json["alerts"] as List<dynamic>? ?? [];
    return FlightAlertsData(
      alerts:
          alertsList
              .map((a) => FlightAlertData.fromMap(a as Map<String, dynamic>))
              .toList(),
    );
  }
}

/// Single flight alert
class FlightAlertData {
  final String type;
  final String severity;
  final String message;
  final int currentValue;
  final int threshold;

  FlightAlertData({
    required this.type,
    required this.severity,
    required this.message,
    required this.currentValue,
    required this.threshold,
  });

  factory FlightAlertData.fromMap(Map<String, dynamic> json) => FlightAlertData(
    type: json["type"] ?? '',
    severity: json["severity"] ?? '',
    message: json["message"] ?? '',
    currentValue: json["current_value"] ?? 0,
    threshold: json["threshold"] ?? 0,
  );

  /// Whether this is a WARNING (exceeded) or INFO (approaching)
  bool get isWarning => severity == 'WARNING';

  /// Whether this is an INFO alert (approaching expiry)
  bool get isInfo => severity == 'INFO';

  /// Whether this is a NOTICE (gentle reminder, neutral)
  bool get isNotice => severity == 'NOTICE';

  /// Whether this is a flight hours limit alert
  bool get isHourLimit => type.startsWith('HOUR_LIMIT');

  /// Whether this is a minimum landings alert
  bool get isLandingAlert => type == 'MIN_LANDINGS_90_DAYS';
}
