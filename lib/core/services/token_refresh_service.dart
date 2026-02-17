import 'dart:async';

import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/core/services/session_service.dart';

/// Proactive token refresh service.
/// Schedules a timer to refresh the access token before it expires,
/// and forces logout when refresh fails.
class TokenRefreshService {
  // Singleton
  static final TokenRefreshService _instance = TokenRefreshService._internal();
  factory TokenRefreshService() => _instance;
  TokenRefreshService._internal();

  Timer? _refreshTimer;

  /// Minimum buffer before expiry to trigger refresh (seconds)
  static const int _refreshBufferSeconds = 30;

  /// Starts the proactive token refresh cycle.
  /// Schedules a refresh [expiresInSeconds - buffer] seconds from now.
  /// If the token lifetime is very short (<= buffer), uses half the lifetime.
  void startTokenRefreshCycle(int expiresInSeconds) {
    // Cancel any existing timer
    stopTokenRefreshCycle();

    if (expiresInSeconds <= 0) return;

    // Calculate delay: refresh 30s before expiry, or at half-life if too short
    final int delaySeconds =
        expiresInSeconds > _refreshBufferSeconds
            ? expiresInSeconds - _refreshBufferSeconds
            : (expiresInSeconds / 2).floor().clamp(1, expiresInSeconds);

    print(
      '🔄 TOKEN REFRESH: Timer scheduled in ${delaySeconds}s '
      '(token expires in ${expiresInSeconds}s)',
    );

    _refreshTimer = Timer(Duration(seconds: delaySeconds), _performRefresh);
  }

  /// Stops the current refresh timer.
  void stopTokenRefreshCycle() {
    if (_refreshTimer != null) {
      _refreshTimer!.cancel();
      _refreshTimer = null;
      print('🔄 TOKEN REFRESH: Timer cancelled');
    }
  }

  /// Attempts to refresh the token proactively.
  /// On success, restarts the timer with the new expiry.
  /// On failure, triggers forced logout.
  Future<void> _performRefresh() async {
    print('🔄 TOKEN REFRESH: Performing proactive refresh...');

    final success = await DioClient().refreshAccessToken();

    if (success) {
      print('✅ TOKEN REFRESH: Proactive refresh successful');
      // The timer is restarted from DioClient.refreshAccessToken()
      // after it updates the expiry in SessionService.
    } else {
      print('❌ TOKEN REFRESH: Proactive refresh failed — forcing logout');
      DioClient().onForceLogout?.call();
    }
  }

  /// Called on app startup to validate persisted session.
  /// If the token is still valid, starts the refresh timer for the remaining time.
  /// If expired, tries a refresh. If refresh fails, forces logout.
  Future<void> tryRestoreSession() async {
    final session = SessionService();

    if (!session.isLoggedIn) return;

    final remaining = session.remainingTokenSeconds;

    if (remaining > 0) {
      // Token still valid — schedule refresh for remaining time
      print('🔄 TOKEN REFRESH: Restoring session — ${remaining}s remaining');
      startTokenRefreshCycle(remaining);
    } else {
      // Token expired — attempt refresh
      print('🔄 TOKEN REFRESH: Token expired, attempting refresh...');
      final success = await DioClient().refreshAccessToken();
      if (!success) {
        print('❌ TOKEN REFRESH: Restore failed — forcing logout');
        DioClient().onForceLogout?.call();
      }
      // If success, DioClient.refreshAccessToken() restarts the timer
    }
  }
}
