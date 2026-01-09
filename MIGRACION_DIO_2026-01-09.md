# Migración a Dio - Resumen de Cambios

**Fecha:** 2026-01-09
**Objetivo:** Migrar de paquete `http` a `dio` para mejorar el manejo de HTTP con interceptores, refresh token automático, y mejor debugging.

---

## 📁 Archivos Modificados/Creados

### 1. `lib/core/network/dio_client.dart` (NUEVO)

Cliente Dio centralizado con las siguientes características:

| Característica | Descripción |
|----------------|-------------|
| **Singleton Pattern** | Una única instancia de Dio en toda la app |
| **Base URL automática** | Configurada desde `Config.baseUrl` |
| **Auth Interceptor** | Agrega automáticamente `Bearer token` a todas las requests |
| **Refresh Token Automático** | En errores 401, intenta renovar el token y reintentar la request |
| **Logging Interceptor** | Logs detallados de requests/responses con datos sensibles ocultos |
| **Retry Logic** | Evita loops infinitos con flag `is_retry` |
| **Force Logout Callback** | `onForceLogout` para manejar cuando el refresh token falla |

#### Endpoint de Refresh Token

El cliente asume que tu API de Go tiene:
```
POST /auth/refresh
Body: { "refresh_token": "<token>" }
Response: { "success": true, "data": { "access_token": "...", "refresh_token": "..." } }
```

**⚠️ Si tu endpoint es diferente, ajusta `refreshAccessToken()` en `dio_client.dart`**

---

### 2. `lib/features/employee/data/datasources/employee_remote_data_source.dart` (MODIFICADO)

Migrado de `http` a `Dio`:

| Antes (`http`) | Después (`Dio`) |
|----------------|-----------------|
| `import 'package:http/http.dart' as http;` | `import 'package:dio/dio.dart';` |
| `http.get(Uri.parse("${Config.baseUrl}/..."))` | `_dio.get('/...')` |
| `headers: _getHeaders()` | Automático vía interceptor |
| `EmployeeResponseModel.fromJson(response.body)` | `EmployeeResponseModel.fromMap(response.data)` |
| `jsonEncode(request.toMap())` | `request.toMap()` directamente |

#### Cambios clave:
- **Ya no necesita** `import 'config.dart'` ni `session_service.dart` (manejado por DioClient)
- **Ya no necesita** método `_getHeaders()` (inyectado por AuthInterceptor)
- **Usa** `fromMap()` en lugar de `fromJson()` (Dio parsea automáticamente a Map)

---

## ✅ Verificación

```bash
# Compilación exitosa
flutter build ios --no-codesign --debug
✓ Built build/ios/iphoneos/Runner.app
```

---

## ✅ DataSources Migrados

| DataSource | Archivo | Estado |
|------------|---------|--------|
| **Employee** | `lib/features/employee/data/datasources/employee_remote_data_source.dart` | ✅ Migrado |
| **Airline** | `lib/features/airline/data/datasources/airline_remote_data_source.dart` | ✅ Migrado |
| **Airport** | `lib/features/airport/data/datasources/airport_remote_data_source.dart` | ✅ Migrado |
| **Login** | `lib/features/login/data/datasources/login_datasource.dart` | ✅ Migrado |
| **Register** | `lib/features/register/data/datasources/register_datasource.dart` | ✅ Migrado |
| **Reset Password** | `lib/features/reset_password/data/datasources/reset_password_datasource.dart` | ✅ Migrado |
| **Email Verification** | `lib/features/email_verification/data/datasource/email_verifcation_datasource.dart` | ✅ Migrado |

## 🎉 Migración Completa

Ya no hay usos del paquete `http` en la aplicación. Puedes removerlo del `pubspec.yaml`:

```yaml
# Puedes eliminar esta línea de pubspec.yaml:
# http: ^1.4.0
```

### Cómo migrar otros DataSources:

```dart
// 1. Cambiar imports
import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
// Eliminar: import 'package:http/http.dart' as http;

// 2. Agregar campo Dio
final Dio _dio;
MyDataSourceImpl({Dio? dio}) : _dio = dio ?? DioClient().client;

// 3. Cambiar llamadas
// ANTES: await http.get(Uri.parse("${Config.baseUrl}/endpoint"), headers: _getHeaders());
// DESPUÉS: await _dio.get('/endpoint');

// 4. Cambiar parsing
// ANTES: Model.fromJson(response.body)
// DESPUÉS: Model.fromMap(response.data)
```

---

## 📦 Dependencias

`pubspec.yaml` ya tiene:
```yaml
dependencies:
  dio: ^5.7.0
  http: ^1.4.0  # Puede removerse después de migrar todos los DataSources
```

---

## 🔧 Configuración Opcional

### Deshabilitar Logs en Producción

En `dio_client.dart`, línea ~166:
```dart
// Cambia a false para producción
static const bool _enableLogging = false;
```

O usa `kDebugMode` de Flutter:
```dart
import 'package:flutter/foundation.dart';
static final bool _enableLogging = kDebugMode;
```
