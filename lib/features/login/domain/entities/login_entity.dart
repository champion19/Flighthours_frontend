import 'package:equatable/equatable.dart';

/// Entity representing a successful login result
/// Contains the authentication tokens and user information extracted from JWT
class LoginEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;

  // Employee ID from the backend database
  final String? employeeId;

  // User info extracted from JWT (optional, can be decoded from token)
  final String? email;
  final String? name;
  final List<String> roles;

  const LoginEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
    this.employeeId,
    this.email,
    this.name,
    this.roles = const [],
  });

  /// Creates an empty LoginEntity (for initial states or errors)
  factory LoginEntity.empty() => const LoginEntity(
    accessToken: '',
    refreshToken: '',
    expiresIn: 0,
    tokenType: 'Bearer',
    roles: [],
  );

  /// Check if the login entity has valid tokens
  bool get isValid => accessToken.isNotEmpty && refreshToken.isNotEmpty;

  /// Check if we have the employee ID for API calls
  bool get hasEmployeeId => employeeId != null && employeeId!.isNotEmpty;

  @override
  List<Object?> get props => [
    accessToken,
    refreshToken,
    expiresIn,
    tokenType,
    employeeId,
    email,
    name,
    roles,
  ];
}
