import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/config/config.dart';
import 'package:flight_hours_app/core/services/session_service.dart';
import 'package:flight_hours_app/core/services/token_refresh_service.dart';

/// Cliente Dio centralizado para todas las llamadas HTTP
/// Proporciona configuración base, interceptores y manejo de autenticación con refresh token
class DioClient {
  // Singleton pattern
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late final Dio dio;
  late final Dio
  _refreshDio; // Cliente separado para refresh token (evita loops)

  // Flag para evitar múltiples refresh simultáneos
  bool _isRefreshing = false;

  // Callback para manejar logout forzado (cuando refresh token falla)
  void Function()? onForceLogout;

  DioClient._internal() {
    // Cliente principal
    dio = Dio(
      BaseOptions(
        baseUrl: Config.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Cliente separado para refresh token (sin interceptores de auth para evitar loops)
    _refreshDio = Dio(
      BaseOptions(
        baseUrl: Config.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Agregar interceptores
    dio.interceptors.addAll([_AuthInterceptor(this), _LoggingInterceptor()]);

    // Solo logging para el cliente de refresh
    _refreshDio.interceptors.add(_LoggingInterceptor());
  }

  /// Obtiene la instancia de Dio configurada
  Dio get client => dio;

  /// Intenta refrescar el access token usando el refresh token
  /// Retorna true si el refresh fue exitoso, false si falló
  Future<bool> refreshAccessToken() async {
    if (_isRefreshing) {
      // Ya hay un refresh en progreso, esperar
      await Future.delayed(const Duration(milliseconds: 100));
      return SessionService().accessToken != null;
    }

    _isRefreshing = true;

    try {
      final refreshToken = SessionService().refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) {
        _handleLogout();
        return false;
      }

      final response = await _refreshDio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        final newAccessToken = data['access_token'] as String?;
        final newRefreshToken = data['refresh_token'] as String?;

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          await SessionService().updateAccessToken(newAccessToken);
          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await SessionService().updateRefreshToken(newRefreshToken);
          }
          // Update token expiry and restart proactive refresh timer
          final newExpiresIn = data['expires_in'] as int? ?? 300;
          await SessionService().updateTokenExpiry(newExpiresIn);
          TokenRefreshService().startTokenRefreshCycle(newExpiresIn);
          return true;
        }
      }

      _handleLogout();
      return false;
    } on DioException catch (e) {
      print('❌ REFRESH TOKEN ERROR: ${e.message}');
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _handleLogout();
      }
      return false;
    } catch (e) {
      print('❌ REFRESH TOKEN UNEXPECTED ERROR: $e');
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Maneja el logout forzado
  void _handleLogout() {
    TokenRefreshService().stopTokenRefreshCycle();
    SessionService().clearSession();
    onForceLogout?.call();
  }
}

/// Interceptor para agregar automáticamente el token de autenticación
/// y manejar renovación automática en errores 401
class _AuthInterceptor extends Interceptor {
  final DioClient _dioClient;

  _AuthInterceptor(this._dioClient);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = SessionService().accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Si es 401, intentar refresh token
    if (err.response?.statusCode == 401 &&
        !_isRetryRequest(err.requestOptions)) {
      final refreshed = await _dioClient.refreshAccessToken();

      if (refreshed) {
        // Reintentar la request original con el nuevo token
        try {
          final options = err.requestOptions;
          options.headers['Authorization'] =
              'Bearer ${SessionService().accessToken}';
          options.extra['is_retry'] = true;

          final response = await _dioClient.dio.fetch(options);
          handler.resolve(response);
          return;
        } on DioException catch (retryError) {
          handler.next(retryError);
          return;
        }
      }
    }

    handler.next(err);
  }

  /// Verifica si esta es una request de reintento (para evitar loops infinitos)
  bool _isRetryRequest(RequestOptions options) {
    return options.extra['is_retry'] == true;
  }
}

/// Interceptor para logging de requests y responses (útil en desarrollo)
/// En producción, considera usar kDebugMode para deshabilitarlo
class _LoggingInterceptor extends Interceptor {
  // Cambia esto a false para deshabilitar logs en producción
  static const bool _enableLogging = true;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_enableLogging) {
      print('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
      print('   Headers: ${_sanitizeHeaders(options.headers)}');
      if (options.data != null) {
        print('   Body: ${_sanitizeBody(options.data)}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_enableLogging) {
      print(
        '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
      print('   Data: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_enableLogging) {
      print(
        '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      );
      print('   Message: ${err.message}');
      if (err.response?.data != null) {
        print('   Response: ${err.response?.data}');
      }
    }
    handler.next(err);
  }

  /// Oculta tokens en los logs por seguridad
  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = Map<String, dynamic>.from(headers);
    if (sanitized.containsKey('Authorization')) {
      final auth = sanitized['Authorization'] as String;
      if (auth.startsWith('Bearer ')) {
        sanitized['Authorization'] = 'Bearer [HIDDEN]';
      }
    }
    return sanitized;
  }

  /// Oculta passwords en los logs por seguridad
  dynamic _sanitizeBody(dynamic body) {
    if (body is Map<String, dynamic>) {
      final sanitized = Map<String, dynamic>.from(body);
      final sensitiveKeys = [
        'password',
        'current_password',
        'new_password',
        'confirm_password',
        'refresh_token',
      ];
      for (final key in sensitiveKeys) {
        if (sanitized.containsKey(key)) {
          sanitized[key] = '[HIDDEN]';
        }
      }
      return sanitized;
    }
    return body;
  }
}
