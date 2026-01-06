import 'dart:convert';

/// Response model for delete employee operation
class DeleteEmployeeResponseModel {
  final bool success;
  final String code;
  final String message;

  DeleteEmployeeResponseModel({
    required this.success,
    required this.code,
    required this.message,
  });

  factory DeleteEmployeeResponseModel.fromJson(String str) =>
      DeleteEmployeeResponseModel.fromMap(json.decode(str));

  factory DeleteEmployeeResponseModel.fromMap(Map<String, dynamic> json) =>
      DeleteEmployeeResponseModel(
        success: json["success"] ?? false,
        code: json["code"] ?? '',
        message: json["message"] ?? '',
      );
}
