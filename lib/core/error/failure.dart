import 'package:equatable/equatable.dart';

/// Represents a failure from any operation (API call, local, etc.)
///
/// Used with `Either<Failure, T>` to propagate errors cleanly
/// without throwing exceptions.
class Failure extends Equatable {
  /// Human-readable error message (from the backend or fallback)
  final String message;

  /// Backend error code (e.g., "VUE_VAL_ERR_04807")
  final String? code;

  /// HTTP status code (e.g., 400, 404, 500)
  final int? statusCode;

  const Failure({required this.message, this.code, this.statusCode});

  @override
  List<Object?> get props => [message, code, statusCode];

  @override
  String toString() =>
      'Failure(message: $message, code: $code, statusCode: $statusCode)';
}
