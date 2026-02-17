/// Centralized constants from backend JSON schemas.
/// These values MUST match the constraints defined in:
/// api-flighthours/platform/schema/json_schema/*.json
///
/// When the backend schema changes, update these constants accordingly.
class SchemaConstants {
  SchemaConstants._();

  // ══════════════════════════════════════════════════════════════
  // AUTH
  // ══════════════════════════════════════════════════════════════

  /// Email: used in login, register, change_password, password_reset
  static const int emailMinLength = 5;
  static const int emailMaxLength = 150;

  /// Password for login (more permissive — just needs non-empty)
  static const int loginPasswordMinLength = 1;
  static const int loginPasswordMaxLength = 128;

  /// Password for register, change_password, update_password
  /// Requires: 8+ chars, 1 uppercase, 1 special character
  static const int passwordMinLength = 8;
  static const int passwordMaxLength = 64;

  // ══════════════════════════════════════════════════════════════
  // EMPLOYEE
  // ══════════════════════════════════════════════════════════════

  /// Employee name
  static const int nameMinLength = 1;
  static const int nameMaxLength = 50;

  /// Identification number (digits only: ^[0-9]+$)
  static const int identificationMinLength = 7;
  static const int identificationMaxLength = 10;

  // ══════════════════════════════════════════════════════════════
  // AIRLINE EMPLOYEE
  // ══════════════════════════════════════════════════════════════

  /// Business partner code (bp)
  static const int bpMaxLength = 16;

  // ══════════════════════════════════════════════════════════════
  // LICENSE PLATE (Aircraft Registration)
  // ══════════════════════════════════════════════════════════════

  /// Aircraft registration number (e.g., HK-5432, CC-BFA)
  static const int licensePlateMinLength = 1;
  static const int licensePlateMaxLength = 7;

  /// Pattern: uppercase letters, digits, and hyphens only
  static final RegExp licensePlatePattern = RegExp(r'^[A-Z0-9-]+$');

  // ══════════════════════════════════════════════════════════════
  // DAILY LOGBOOK DETAIL
  // ══════════════════════════════════════════════════════════════

  /// Flight number (e.g., AV123)
  static const int flightNumberMinLength = 1;
  static const int flightNumberMaxLength = 20;

  /// Companion pilot name
  static const int companionNameMaxLength = 100;

  /// Passengers: integer >= 0
  static const int passengersMinimum = 0;

  /// Time fields (out_time, takeoff_time, landing_time, in_time,
  /// air_time, block_time, duty_time): format HH:MM
  static final RegExp timePattern = RegExp(r'^\d{2}:\d{2}$');

  // ══════════════════════════════════════════════════════════════
  // DAILY LOGBOOK
  // ══════════════════════════════════════════════════════════════

  /// Book page number: integer >= 1
  static const int bookPageMinimum = 1;

  // ══════════════════════════════════════════════════════════════
  // SHARED PATTERNS
  // ══════════════════════════════════════════════════════════════

  /// Date format: YYYY-MM-DD
  static final RegExp datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  /// Digits only (for identificationNumber)
  static final RegExp digitsOnlyPattern = RegExp(r'^[0-9]+$');
}
