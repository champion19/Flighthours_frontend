import 'dart:convert';

/// Response model for GET employee endpoint
class EmployeeResponseModel {
  final bool success;
  final String code;
  final String message;
  final EmployeeData? data;

  EmployeeResponseModel({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory EmployeeResponseModel.fromJson(String str) =>
      EmployeeResponseModel.fromMap(json.decode(str));

  factory EmployeeResponseModel.fromMap(Map<String, dynamic> json) =>
      EmployeeResponseModel(
        success: json["success"] ?? false,
        code: json["code"] ?? '',
        message: json["message"] ?? '',
        data: json["data"] != null ? EmployeeData.fromMap(json["data"]) : null,
      );
}

/// Data model containing employee information
class EmployeeData {
  final String id;
  final String name;
  final String email;
  final String? airline;
  final String? identificationNumber;
  final String? bp;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool active;
  final String? role;

  EmployeeData({
    required this.id,
    required this.name,
    required this.email,
    this.airline,
    this.identificationNumber,
    this.bp,
    this.startDate,
    this.endDate,
    this.active = true,
    this.role,
  });

  factory EmployeeData.fromMap(Map<String, dynamic> json) => EmployeeData(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    email: json["email"] ?? '',
    airline: json["airline"],
    identificationNumber: json["identification_number"],
    bp: json["bp"],
    startDate:
        json["start_date"] != null
            ? DateTime.tryParse(json["start_date"])
            : null,
    endDate:
        json["end_date"] != null ? DateTime.tryParse(json["end_date"]) : null,
    active: json["active"] ?? true,
    role: json["role"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "airline": airline,
    "identification_number": identificationNumber,
    "bp": bp,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "active": active,
    "role": role,
  };
}
