import 'package:equatable/equatable.dart';

/// Represents a Daily Logbook (header) for a pilot
/// Contains the grouping of flight segments for a specific date
class DailyLogbookEntity extends Equatable {
  final String id; // Obfuscated ID
  final String? uuid; // Real UUID from database
  final String? employeeId; // Owner of the logbook
  final DateTime? logDate; // Date of the logbook
  final int? bookPage; // Physical page number in the logbook
  final bool? status; // Active/Inactive status

  const DailyLogbookEntity({
    required this.id,
    this.uuid,
    this.employeeId,
    this.logDate,
    this.bookPage,
    this.status,
  });

  /// Returns a display-friendly logbook ID
  String get displayId {
    if (id.length > 8) {
      return 'LB-${id.substring(0, 4).toUpperCase()}';
    }
    return 'LB-$id';
  }

  /// Returns formatted date for display (e.g., "10/26/23")
  String get formattedDate {
    if (logDate == null) return 'Unknown Date';
    return '${logDate!.month.toString().padLeft(2, '0')}/${logDate!.day.toString().padLeft(2, '0')}/${logDate!.year.toString().substring(2)}';
  }

  /// Returns full formatted date (e.g., "October 26, 2023")
  String get fullFormattedDate {
    if (logDate == null) return 'Unknown Date';
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[logDate!.month - 1]} ${logDate!.day}, ${logDate!.year}';
  }

  /// Returns status display string
  String get displayStatus => (status ?? true) ? 'Active' : 'Inactive';

  /// Returns whether the logbook is active
  bool get isActive => status ?? true;

  @override
  List<Object?> get props => [id, uuid, employeeId, logDate, bookPage, status];
}
