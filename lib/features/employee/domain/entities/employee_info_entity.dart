import 'package:equatable/equatable.dart';

/// Entity representing an employee's complete information.
/// This is used for displaying employee details without exposing internal IDs.
class EmployeeInfoEntity extends Equatable {
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

  const EmployeeInfoEntity({
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

  /// Returns true if the employee is currently active
  bool get isActive => active;

  /// Returns a formatted date range string for display
  String get dateRangeDisplay {
    if (startDate == null && endDate == null) return 'Not specified';
    final start =
        startDate != null
            ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
            : 'N/A';
    final end =
        endDate != null
            ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
            : 'N/A';
    return '$start - $end';
  }

  /// Returns the role with proper capitalization for display
  String get roleDisplay => role?.toUpperCase() ?? 'N/A';

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    airline,
    identificationNumber,
    bp,
    startDate,
    endDate,
    active,
    role,
  ];
}
