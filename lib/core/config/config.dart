import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

class Config {
  // ============================================================
  // CONFIGURACIÓN DE URL DEL BACKEND
  // ============================================================
  //
  // La URL se detecta automáticamente según la plataforma:
  //
  // 🌐 Web / 📱 iOS Simulator: usa localhost (127.0.0.1)
  // 🤖 Emulador Android:       usa 10.0.2.2 (alias del host)
  // 📲 Dispositivo físico:      cambiar _host por tu IP local (ej: 192.168.1.X)
  // 🌐 Producción:              cambiar _host por tu dominio
  //
  // ============================================================

  static String get _host {
    if (kIsWeb) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost'; // iOS Simulator, macOS, Linux, Windows
  }

  static String get baseUrl => "http://$_host:8081/flighthours/api/v1";
}

// La base URL es el dominio hasta v1, lo demás se agrega en los endpoints de cada datasource
