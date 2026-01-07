import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Session service with secure persistent storage for authentication tokens.
/// Uses flutter_secure_storage to encrypt and persist tokens even after app closure.
/// Also maintains in-memory cache for fast access during the app session.
class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  // Secure storage instance with Android-specific options for better security
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // Storage keys
  static const String _keyEmployeeId = 'employee_id';
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyEmail = 'email';
  static const String _keyName = 'name';

  // In-memory cache for fast access (avoids async calls during the session)
  String? _employeeId;
  String? _accessToken;
  String? _refreshToken;
  String? _email;
  String? _name;

  /// Initializes the session by restoring any persisted data.
  /// Call this method in main.dart before runApp().
  Future<void> init() async {
    _employeeId = await _storage.read(key: _keyEmployeeId);
    _accessToken = await _storage.read(key: _keyAccessToken);
    _refreshToken = await _storage.read(key: _keyRefreshToken);
    _email = await _storage.read(key: _keyEmail);
    _name = await _storage.read(key: _keyName);
  }

  /// Sets the session data after a successful login.
  /// Persists tokens securely and caches in memory for fast access.
  Future<void> setSession({
    required String employeeId,
    required String accessToken,
    required String refreshToken,
    String? email,
    String? name,
  }) async {
    // Update in-memory cache
    _employeeId = employeeId;
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _email = email;
    _name = name;

    // Persist to secure storage
    await _storage.write(key: _keyEmployeeId, value: employeeId);
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
    if (email != null) {
      await _storage.write(key: _keyEmail, value: email);
    }
    if (name != null) {
      await _storage.write(key: _keyName, value: name);
    }
  }

  /// Gets the current employee ID (from memory cache)
  String? get employeeId => _employeeId;

  /// Gets the current access token (from memory cache)
  String? get accessToken => _accessToken;

  /// Gets the current refresh token (from memory cache)
  String? get refreshToken => _refreshToken;

  /// Gets the current user's email (from memory cache)
  String? get email => _email;

  /// Gets the current user's name (from memory cache)
  String? get name => _name;

  /// Checks if a user is currently logged in
  bool get isLoggedIn => _employeeId != null && _accessToken != null;

  /// Clears the session (logout).
  /// Removes all data from both memory cache and secure storage.
  Future<void> clearSession() async {
    // Clear in-memory cache
    _employeeId = null;
    _accessToken = null;
    _refreshToken = null;
    _email = null;
    _name = null;

    // Clear secure storage
    await _storage.deleteAll();
  }

  /// Updates only the access token (useful for token refresh).
  Future<void> updateAccessToken(String newAccessToken) async {
    _accessToken = newAccessToken;
    await _storage.write(key: _keyAccessToken, value: newAccessToken);
  }

  /// Updates only the refresh token.
  Future<void> updateRefreshToken(String newRefreshToken) async {
    _refreshToken = newRefreshToken;
    await _storage.write(key: _keyRefreshToken, value: newRefreshToken);
  }

  // ========== PENDING EMPLOYEE DATA ==========
  // These methods store ALL employee data captured during registration
  // to be sent to PUT /employees/me after the first successful login

  static const String _keyPendingName = 'pending_name';
  static const String _keyPendingIdentificationNumber =
      'pending_identification_number';
  static const String _keyPendingBp = 'pending_bp';
  static const String _keyPendingAirlineId = 'pending_airline_id';
  static const String _keyPendingStartDate = 'pending_start_date';
  static const String _keyPendingEndDate = 'pending_end_date';
  static const String _keyPendingActive = 'pending_active';
  static const String _keyPendingRole = 'pending_role';
  static const String _keyHasPendingPilotData = 'has_pending_pilot_data';

  /// Saves ALL employee data to be sent after first login via PUT /employees/me
  Future<void> setPendingPilotData({
    required String name,
    required String identificationNumber,
    required String? bp,
    required String? airlineId,
    required String startDate,
    required String endDate,
    required bool active,
    String role = 'pilot',
  }) async {
    await _storage.write(key: _keyPendingName, value: name);
    await _storage.write(
      key: _keyPendingIdentificationNumber,
      value: identificationNumber,
    );
    await _storage.write(key: _keyPendingBp, value: bp ?? '');
    await _storage.write(key: _keyPendingAirlineId, value: airlineId ?? '');
    await _storage.write(key: _keyPendingStartDate, value: startDate);
    await _storage.write(key: _keyPendingEndDate, value: endDate);
    await _storage.write(key: _keyPendingActive, value: active.toString());
    await _storage.write(key: _keyPendingRole, value: role);
    await _storage.write(key: _keyHasPendingPilotData, value: 'true');
  }

  /// Checks if there is pending employee data to send
  Future<bool> hasPendingPilotData() async {
    final value = await _storage.read(key: _keyHasPendingPilotData);
    return value == 'true';
  }

  /// Gets the pending employee data for PUT /employees/me
  Future<Map<String, dynamic>?> getPendingPilotData() async {
    final hasPending = await hasPendingPilotData();
    if (!hasPending) return null;

    return {
      'name': await _storage.read(key: _keyPendingName) ?? '',
      'identificationNumber':
          await _storage.read(key: _keyPendingIdentificationNumber) ?? '',
      'bp': await _storage.read(key: _keyPendingBp) ?? '',
      'airlineId': await _storage.read(key: _keyPendingAirlineId) ?? '',
      'startDate': await _storage.read(key: _keyPendingStartDate) ?? '',
      'endDate': await _storage.read(key: _keyPendingEndDate) ?? '',
      'active': (await _storage.read(key: _keyPendingActive)) == 'true',
      'role': await _storage.read(key: _keyPendingRole) ?? 'pilot',
    };
  }

  /// Clears the pending employee data after successful update
  Future<void> clearPendingPilotData() async {
    await _storage.delete(key: _keyPendingName);
    await _storage.delete(key: _keyPendingIdentificationNumber);
    await _storage.delete(key: _keyPendingBp);
    await _storage.delete(key: _keyPendingAirlineId);
    await _storage.delete(key: _keyPendingStartDate);
    await _storage.delete(key: _keyPendingEndDate);
    await _storage.delete(key: _keyPendingActive);
    await _storage.delete(key: _keyPendingRole);
    await _storage.delete(key: _keyHasPendingPilotData);
  }
}
