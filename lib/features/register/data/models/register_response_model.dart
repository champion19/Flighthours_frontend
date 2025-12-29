import 'dart:convert';

/// Modelo para la respuesta del backend de registro
/// Mapea la estructura: { success: bool, code: string, message: string }
class RegisterResponseModel {
  final bool success;
  final String code;
  final String message;

  RegisterResponseModel({
    required this.success,
    required this.code,
    required this.message,
  });

  factory RegisterResponseModel.fromJson(String str) =>
      RegisterResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegisterResponseModel.fromMap(Map<String, dynamic> json) =>
      RegisterResponseModel(
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
