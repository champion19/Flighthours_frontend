import 'dart:convert';

/// Response model for GET /employees/flight-hours-summary
class FlightHoursSummaryResponseModel {
  final bool success;
  final String code;
  final String message;
  final FlightHoursSummaryData? data;

  FlightHoursSummaryResponseModel({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory FlightHoursSummaryResponseModel.fromJson(String str) =>
      FlightHoursSummaryResponseModel.fromMap(json.decode(str));

  factory FlightHoursSummaryResponseModel.fromMap(Map<String, dynamic> json) =>
      FlightHoursSummaryResponseModel(
        success: json["success"] ?? false,
        code: json["code"] ?? '',
        message: json["message"] ?? '',
        data:
            json["data"] != null
                ? FlightHoursSummaryData.fromMap(json["data"])
                : null,
      );
}

/// Data model for flight hours summary
class FlightHoursSummaryData {
  final String period;
  final String startDate;
  final String endDate;
  final String totalHours;
  final int totalFlights;
  final int totalLandings;
  final Map<String, String> breakdown; // pilot_role → "HH:MM"

  FlightHoursSummaryData({
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.totalHours,
    required this.totalFlights,
    required this.totalLandings,
    required this.breakdown,
  });

  factory FlightHoursSummaryData.fromMap(Map<String, dynamic> json) {
    // Parse breakdown map — both keys and values are strings
    final rawBreakdown = json["breakdown"] as Map<String, dynamic>? ?? {};
    final breakdown = rawBreakdown.map(
      (key, value) => MapEntry(key, value?.toString() ?? '0:00'),
    );

    return FlightHoursSummaryData(
      period: json["period"] ?? '',
      startDate: json["start_date"] ?? '',
      endDate: json["end_date"] ?? '',
      totalHours: json["total_hours"] ?? '0:00',
      totalFlights: json["total_flights"] ?? 0,
      totalLandings: json["total_landings"] ?? 0,
      breakdown: breakdown,
    );
  }

  /// Parse "HH:MM" string to total minutes
  static int parseHoursToMinutes(String hoursStr) {
    final parts = hoursStr.split(':');
    if (parts.length != 2) return 0;
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    return hours * 60 + minutes;
  }

  /// Get total minutes from totalHours
  int get totalMinutes => parseHoursToMinutes(totalHours);

  /// Get breakdown in minutes for chart calculations
  Map<String, int> get breakdownMinutes =>
      breakdown.map((key, value) => MapEntry(key, parseHoursToMinutes(value)));
}
