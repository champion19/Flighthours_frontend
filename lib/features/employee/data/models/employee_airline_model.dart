import 'dart:convert';

/// Response model for GET /employees/airline endpoint
/// Returns the airline employee relationship data
class EmployeeAirlineResponseModel {
  final bool success;
  final String code;
  final String message;
  final EmployeeAirlineData? data;

  EmployeeAirlineResponseModel({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory EmployeeAirlineResponseModel.fromJson(String str) =>
      EmployeeAirlineResponseModel.fromMap(json.decode(str));

  factory EmployeeAirlineResponseModel.fromMap(Map<String, dynamic> json) =>
      EmployeeAirlineResponseModel(
        success: json["success"] ?? false,
        code: json["code"] ?? '',
        message: json["message"] ?? '',
        data:
            json["data"] != null
                ? EmployeeAirlineData.fromMap(json["data"])
                : null,
      );
}

/// Data model for airline employee relationship
class EmployeeAirlineData {
  final String? airlineId;
  final String? airlineName;
  final String? airlineCode;
  final String? bp;
  final DateTime? startDate;
  final DateTime? endDate;

  EmployeeAirlineData({
    this.airlineId,
    this.airlineName,
    this.airlineCode,
    this.bp,
    this.startDate,
    this.endDate,
  });

  factory EmployeeAirlineData.fromMap(Map<String, dynamic> json) =>
      EmployeeAirlineData(
        airlineId: json["airline_id"],
        airlineName: json["airline_name"],
        airlineCode: json["airline_code"],
        bp: json["bp"],
        startDate:
            json["start_date"] != null
                ? DateTime.tryParse(json["start_date"])
                : null,
        endDate:
            json["end_date"] != null
                ? DateTime.tryParse(json["end_date"])
                : null,
      );

  Map<String, dynamic> toMap() => {
    "airline_id": airlineId,
    "airline_name": airlineName,
    "airline_code": airlineCode,
    "bp": bp,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
  };

  /// Check if the employee has an airline association
  bool get hasAirline => airlineId != null && airlineId!.isNotEmpty;
}

/// Request model for PUT /employees/airline endpoint
class EmployeeAirlineUpdateRequest {
  final String airlineId;
  final String bp;
  final String startDate;
  final String endDate;

  EmployeeAirlineUpdateRequest({
    required this.airlineId,
    required this.bp,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() => {
    "airline_id": airlineId,
    "bp": bp,
    "start_date": startDate,
    "end_date": endDate,
  };

  String toJson() => json.encode(toMap());
}
