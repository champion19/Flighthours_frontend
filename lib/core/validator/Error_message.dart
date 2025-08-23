import 'package:flight_hours_app/core/validator/validation_messages.dart';

class ErrorMessageMapper {
  /// Mapea errores del servidor/backend a mensajes localizados
  static String mapServerError(String serverMessage) {
    switch (serverMessage.toLowerCase()) {
      case 'invalid_credentials':
      case 'invalid credentials':
      case 'unauthorized':
        return ValidationMessages.invalidCredentials;
      case 'network_error':
      case 'connection_error':
        return ValidationMessages.networkError;
      case 'server_error':
      case 'internal_server_error':
        return ValidationMessages.serverError;
      case 'timeout':
      case 'request_timeout':
        return ValidationMessages.timeoutError;
      default:
        return ValidationMessages.genericError;
    }
  }

  static String mapHttpError(int statusCode, [String? message]) {
    switch (statusCode) {
      case 400:
        return ValidationMessages.invalidCredentials;
      case 401:
        return ValidationMessages.invalidCredentials;
      case 503:
        return ValidationMessages.serverError;
      case 408:
        return ValidationMessages.timeoutError;
      default:
        return message ?? ValidationMessages.genericError;
    }
  }
}
