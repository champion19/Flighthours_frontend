import 'dart:convert';

/// Request model for changing employee password
class ChangePasswordRequest {
  final String email;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordRequest({
    required this.email,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
    "email": email,
    "current_password": currentPassword,
    "new_password": newPassword,
    "confirm_password": confirmPassword,
  };
}

/// Response model for change password operation
class ChangePasswordResponseModel {
  final bool success;
  final String code;
  final String message;
  final ChangePasswordData? data;

  ChangePasswordResponseModel({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory ChangePasswordResponseModel.fromJson(String str) =>
      ChangePasswordResponseModel.fromMap(json.decode(str));

  factory ChangePasswordResponseModel.fromMap(Map<String, dynamic> json) =>
      ChangePasswordResponseModel(
        success: json["success"] ?? false,
        code: json["code"] ?? '',
        message: json["message"] ?? '',
        data:
            json["data"] != null
                ? ChangePasswordData.fromMap(json["data"])
                : null,
      );
}

/// Data returned after a successful password change
class ChangePasswordData {
  final bool changed;
  final String email;

  ChangePasswordData({required this.changed, required this.email});

  factory ChangePasswordData.fromMap(Map<String, dynamic> json) =>
      ChangePasswordData(
        changed: json["changed"] ?? false,
        email: json["email"] ?? '',
      );
}
