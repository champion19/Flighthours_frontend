import 'dart:convert';

/// Model for the backend password reset response
/// Maps the structure: { success: bool, code: string, message: string }
class ResetPasswordResponseModel {
  final bool success;
  final String code;
  final String message;

  ResetPasswordResponseModel({
    required this.success,
    required this.code,
    required this.message,
  });

  factory ResetPasswordResponseModel.fromJson(String str) =>
      ResetPasswordResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResetPasswordResponseModel.fromMap(Map<String, dynamic> json) =>
      ResetPasswordResponseModel(
        success: json["success"] ?? false,
        code: json["code"] ?? '',
        message: json["message"] ?? '',
      );

  Map<String, dynamic> toMap() => {
    "success": success,
    "code": code,
    "message": message,
  };
}
