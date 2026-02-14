import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';

/// Model class for Daily Logbook that extends the entity
/// Provides JSON serialization/deserialization
class DailyLogbookModel extends DailyLogbookEntity {
  const DailyLogbookModel({
    required super.id,
    super.uuid,
    super.employeeId,
    super.logDate,
    super.bookPage,
    super.status,
  });

  /// Factory constructor to create DailyLogbookModel from JSON
  ///
  /// Expected backend response format:
  /// {
  ///   "id": "obfuscated_id",
  ///   "uuid": "real-uuid",
  ///   "employee_id": "...",
  ///   "log_date": "2026-01-10T00:00:00-05:00",
  ///   "book_page": 210930050,
  ///   "status": true
  /// }
  factory DailyLogbookModel.fromJson(Map<String, dynamic> json) {
    return DailyLogbookModel(
      id: json['id']?.toString() ?? '',
      uuid: json['uuid']?.toString(),
      employeeId: json['employee_id']?.toString(),
      logDate: _parseDate(json['log_date']),
      bookPage: _parseInt(json['book_page']),
      status: _parseBool(json['status']),
    );
  }

  /// Parse date from various formats
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  /// Parse int from various types
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  /// Parse bool from various types
  /// Handles: true/false, 1/0, "true"/"false", "active"/"inactive"
  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase();
      // Handle "active"/"inactive" format from backend
      if (lower == 'active' || lower == 'true') return true;
      if (lower == 'inactive' || lower == 'false') return false;
    }
    if (value is int) return value == 1;
    return null;
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (uuid != null) 'uuid': uuid,
      if (employeeId != null) 'employee_id': employeeId,
      if (logDate != null) 'log_date': _formatDate(logDate!),
      if (bookPage != null) 'book_page': bookPage,
      if (status != null) 'status': status,
    };
  }

  /// Format date for API (YYYY-MM-DD)
  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Create request body for creating a new logbook
  static Map<String, dynamic> createRequest({
    required DateTime logDate,
    required int bookPage,
  }) {
    return {'log_date': _formatDate(logDate), 'book_page': bookPage};
  }
}
