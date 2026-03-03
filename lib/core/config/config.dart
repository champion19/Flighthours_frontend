class Config {
  // ============================================================
  // CONFIGURACIÓN DE URL DEL BACKEND
  // ============================================================
  //
  // Usa la opción apropiada según tu entorno:
  //
  // 📱 Simulador iOS:     "http://127.0.0.1:8081/flighthours/api/v1"
  // 🤖 Emulador Android:  "http://10.0.2.2:8081/flighthours/api/v1"
  // 📲 Dispositivo físico: "http://TU_IP_LOCAL:8081/flighthours/api/v1" (ej: 192.168.1.X)
  // 🌐 Producción:        "https://tu-api-produccion.com/flighthours/api/v1"
  //
  // ============================================================

  // CAMBIA ESTA LÍNEA según tu entorno de desarrollo:
  // - Para iOS Simulator / Web: usa localhost
  // - Para Android Emulator: usa 10.0.2.2
  static const String baseUrl = "http://localhost:8081/flighthours/api/v1";
}

// La base URL es el dominio hasta v1, lo demás se agrega en los endpoints de cada datasource
