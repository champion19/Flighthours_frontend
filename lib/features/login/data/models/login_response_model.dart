import 'dart:convert';

/// Model for the backend login response
/// Maps the structure: { success: bool, code: string, message: string, data?: { tokens } }
class LoginResponseModel {
  final bool success;
  final String code;
  final String message;
  final TokenData? data;

  LoginResponseModel({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(String str) =>
      LoginResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromMap(Map<String, dynamic> json) =>
      LoginResponseModel(
        success: json["success"] ?? false,
        code: json["code"] ?? '',
        message: json["message"] ?? '',
        data: json["data"] != null ? TokenData.fromMap(json["data"]) : null,
      );

  Map<String, dynamic> toMap() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data?.toMap(),
  };
}

/// Token data returned on successful login
class TokenData {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;
  final String? employeeId;

  TokenData({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
    this.employeeId,
  });

  factory TokenData.fromMap(Map<String, dynamic> json) => TokenData(
    accessToken: json["access_token"] ?? '',
    refreshToken: json["refresh_token"] ?? '',
    expiresIn: json["expires_in"] ?? 0,
    tokenType: json["token_type"] ?? 'Bearer',
    employeeId: json["employee_id"],
  );

  Map<String, dynamic> toMap() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "expires_in": expiresIn,
    "token_type": tokenType,
    "employee_id": employeeId,
  };
}
