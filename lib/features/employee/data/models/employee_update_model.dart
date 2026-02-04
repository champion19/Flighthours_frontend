import 'dart:convert';

/// Request model for updating employee basic information
/// PUT /employees - only name and identificationNumber
class EmployeeUpdateRequest {
  final String name;
  final String identificationNumber;

  EmployeeUpdateRequest({
    required this.name,
    required this.identificationNumber,
  });

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
    "name": name,
    "identificationNumber": identificationNumber,
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
