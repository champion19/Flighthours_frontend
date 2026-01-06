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
}
