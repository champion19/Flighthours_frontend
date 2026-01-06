import 'dart:convert';

/// Request model for updating employee information
class EmployeeUpdateRequest {
  final String name;
  final String airline;
  final String identificationNumber;
  final String bp;
  final String startDate;
  final String endDate;
  final bool active;
  final String role;

  EmployeeUpdateRequest({
    required this.name,
    required this.airline,
    required this.identificationNumber,
    required this.bp,
    required this.startDate,
    required this.endDate,
    required this.active,
    required this.role,
  });

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
    "name": name,
    "airline": airline,
    "identificationNumber": identificationNumber,
    "bp": bp,
    "start_date": startDate,
    "end_date": endDate,
    "active": active,
    "role": role,
  };
}

/// Response model for update employee operation
class EmployeeUpdateResponseModel {
  final bool success;
  final String code;
  final String message;
  final UpdateResultData? data;

  EmployeeUpdateResponseModel({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory EmployeeUpdateResponseModel.fromJson(String str) =>
      EmployeeUpdateResponseModel.fromMap(json.decode(str));

  factory EmployeeUpdateResponseModel.fromMap(
    Map<String, dynamic> json,
  ) => EmployeeUpdateResponseModel(
    success: json["success"] ?? false,
    code: json["code"] ?? '',
    message: json["message"] ?? '',
    data: json["data"] != null ? UpdateResultData.fromMap(json["data"]) : null,
  );
}

/// Data returned after a successful update
class UpdateResultData {
  final String id;
  final bool updated;

  UpdateResultData({required this.id, required this.updated});

  factory UpdateResultData.fromMap(Map<String, dynamic> json) =>
      UpdateResultData(id: json["id"] ?? '', updated: json["updated"] ?? false);
}
