import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

class Config {
  // ============================================================
  // CONFIGURACIÓN DE URL DEL BACKEND
  // ============================================================
  //
  // En PRODUCCIÓN se pasan variables al compilar:
  //   flutter build web --dart-define=API_HOST=flighthours-api.rbsuport.com
  //                     --dart-define=API_PROTOCOL=https
  //                     --dart-define=API_PORT=443
  //
  // En DESARROLLO (sin dart-define) se detecta automáticamente:
  //   🌐 Web / 📱 iOS Simulator: localhost
  //   🤖 Emulador Android:       10.0.2.2
  //
  // ============================================================

  /// Host del backend. Si se compiló con --dart-define=API_HOST, usa ese valor.
  static String get _host {
    const envHost = String.fromEnvironment('API_HOST', defaultValue: '');
    if (envHost.isNotEmpty) return envHost;

    if (kIsWeb) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost'; // iOS Simulator, macOS, Linux, Windows
  }

  /// Protocolo: https en producción, http en desarrollo.
  static String get _protocol {
    const envProtocol = String.fromEnvironment(
      'API_PROTOCOL',
      defaultValue: 'http',
    );
    return envProtocol;
  }

  /// Puerto del backend. Vacío usa el puerto por defecto del protocolo.
  static String get _port {
    const envPort = String.fromEnvironment('API_PORT', defaultValue: '8081');
    // Si el puerto es 443 o 80 (puertos estándar), no lo incluimos en la URL
    if (envPort == '443' || envPort == '80') return '';
    return ':$envPort';
  }

  /// URL base completa del backend API.
  static String get baseUrl => "$_protocol://$_host$_port/flighthours/api/v1";
}

// La base URL es el dominio hasta v1, lo demás se agrega en los endpoints de cada datasource
