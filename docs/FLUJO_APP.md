# Documentación Completa del Proyecto Flight Hours App

Este documento proporciona una visión completa de la arquitectura, flujo de la aplicación, conexión con el backend, y recomendaciones de mejora.

---

## 📂 Estructura del Proyecto

```
flight_hours_app/
├── lib/
│   ├── core/                           # Componentes compartidos de la aplicación
│   │   ├── authpage.dart               # Controlador de navegación Login/Register
│   │   ├── config/
│   │   │   └── config.dart             # Configuración de URLs del backend
│   │   ├── constants/                  # Constantes de la app
│   │   ├── errors/                     # Manejo de errores personalizados
│   │   ├── injector/
│   │   │   ├── injector.dart           # Inyección de dependencias (Kiwi)
│   │   │   └── injector.g.dart         # Archivo generado
│   │   ├── validator/                  # Validadores genéricos
│   │   └── validators/                 # Validadores específicos
│   │
│   ├── features/                       # Funcionalidades de la app (Clean Architecture)
│   │   ├── airline/                    # Feature: Aerolíneas
│   │   │   ├── data/
│   │   │   │   ├── datasources/        # AirlineRemoteDataSource
│   │   │   │   ├── models/             # AirlineModel
│   │   │   │   └── repositories/       # AirlineRepositoryImpl
│   │   │   ├── domain/
│   │   │   │   ├── entities/           # AirlineEntity
│   │   │   │   ├── repositories/       # AirlineRepository (abstracto)
│   │   │   │   └── usecases/           # ListAirlineUseCase
│   │   │   └── presentation/
│   │   │       ├── bloc/               # AirlineBloc, Events, States
│   │   │       ├── pages/              # AirlineListPage
│   │   │       └── widgets/
│   │   │
│   │   ├── email_verification/         # Feature: Verificación de Email
│   │   │   ├── data/
│   │   │   │   ├── datasource/         # EmailVerificationDatasource
│   │   │   │   ├── models/             # EmailVerificationModel
│   │   │   │   └── repositories/       # EmailVerificationRepositoryImpl
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/       # EmailVerificationRepository
│   │   │   │   └── usecases/           # EmailVerificationUseCase
│   │   │   └── presentation/
│   │   │       ├── bloc/               # EmailVerificationBloc
│   │   │       └── pages/
│   │   │
│   │   ├── login/                      # Feature: Login
│   │   │   ├── data/
│   │   │   │   ├── datasources/        # LoginDatasource
│   │   │   │   ├── models/             # EmployeeModel (Login)
│   │   │   │   └── repositories/       # LoginRepositoryImpl
│   │   │   ├── domain/
│   │   │   │   ├── entities/           # EmployeeEntity
│   │   │   │   ├── repositories/       # LoginRepository
│   │   │   │   └── usecases/           # LoginUseCase
│   │   │   └── presentation/
│   │   │       ├── bloc/               # LoginBloc, Events, States
│   │   │       ├── pages/              # LoginPage, HelloEmployeePage
│   │   │       └── widgets/
│   │   │
│   │   └── register/                   # Feature: Registro
│   │       ├── data/
│   │       │   ├── datasources/        # RegisterDatasource
│   │       │   ├── models/             # RegisterModel
│   │       │   └── repositories/       # RegisterRepositoryImpl
│   │       ├── domain/
│   │       │   ├── entities/           # EmployeeEntityRegister
│   │       │   ├── repositories/       # RegisterRepository
│   │       │   └── usecases/           # RegisterUseCase
│   │       └── presentation/
│   │           ├── bloc/               # RegisterBloc, Events, States
│   │           ├── pages/              # PersonalInfoPage, PilotInfoPage, etc.
│   │           └── widgets/
│   │
│   ├── img/                            # Recursos de imagen
│   └── main.dart                       # Punto de entrada
│
├── docs/                               # Documentación
├── test/                               # Tests unitarios
├── android/                            # Configuración Android
├── ios/                                # Configuración iOS
├── web/                                # Configuración Web
├── macos/                              # Configuración macOS
├── linux/                              # Configuración Linux
├── windows/                            # Configuración Windows
└── pubspec.yaml                        # Dependencias del proyecto
```

---

## 🏗️ Arquitectura de la Aplicación

La aplicación sigue una **Clean Architecture** con separación clara de responsabilidades:

### Capas de Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│   (BLoC, Pages, Widgets)                                   │
│   - Maneja la UI y el estado de la aplicación              │
│   - Usa flutter_bloc para gestión de estados               │
└───────────────────────────┬─────────────────────────────────┘
                            │ emite eventos / escucha estados
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                           │
│   (Entities, Repositories (abstract), UseCases)            │
│   - Lógica de negocio pura                                 │
│   - No tiene dependencias de frameworks                    │
└───────────────────────────┬─────────────────────────────────┘
                            │ llama al repositorio
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                            │
│   (DataSources, Models, Repository Implementations)        │
│   - Implementa los repositorios del dominio                │
│   - Comunica con APIs externas (Backend Golang)            │
└─────────────────────────────────────────────────────────────┘
```

### Inyección de Dependencias

Se usa el paquete **Kiwi** para inyección de dependencias con generación de código:

```dart
// lib/core/injector/injector.dart
@Register.factory(LoginRepository, from: LoginRepositoryImpl)
@Register.factory(LoginUseCase)
@Register.factory(LoginDatasource)
// ... más registros
```

**Comando para regenerar el inyector:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🔄 Flujo de la Aplicación

### 1. Punto de Entrada (`main.dart`)

```
main()
   │
   ├── InjectorApp.setyp()         # Inicializa dependencias
   │
   └── MultiBlocProvider           # Provee BLoCs a toda la app
       ├── RegisterBloc
       ├── LoginBloc
       ├── AirlineBloc
       └── EmailVerificationBloc
           │
           └── MaterialApp
               ├── initialRoute: '/'
               ├── home: AuthPage
               └── routes:
                   ├── '/home'      → HelloEmployee
                   ├── '/login'     → LoginPage
                   ├── '/airlines'  → AirlineListPage
                   └── '/email'     → VerificationPage
```

### 2. AuthPage - Controlador Principal

`AuthPage` actúa como un conmutador entre Login y Registro:

```
AuthPage (StatefulWidget)
   │
   ├── AuthPageState.login → LoginPage
   │       └── onSwitchToRegister → Cambia a Register
   │
   └── AuthPageState.register → RegisterPage
           └── onSwitchToLogin → Cambia a Login
```

### 3. Flujo de Login

```
LoginPage
   │
   ├── Usuario ingresa email y password
   │
   └── Botón "Iniciar Sesión"
       │
       └── Dispara LoginSubmitted(email, password)
           │
           └── LoginBloc
               ├── emit(LoginLoading())
               │
               └── LoginUseCase.call(email, password)
                   │
                   └── LoginRepository.login()
                       │
                       └── LoginDatasource.loginEmployee()
                           │
                           └── HTTP POST /v1/login
                               │
                               ├── 200 OK → emit(LoginSuccess(employee))
                               │             → Navegar a HelloEmployee
                               │
                               └── Error → emit(LoginError(message))
                                           → Mostrar SnackBar
```

### 4. Flujo de Registro (Multi-step)

El registro usa un `PageView` para navegación entre pasos:

```
RegisterPage
   │
   ├── BlocListener<RegisterBloc>   # Escucha cambios de estado
   │
   └── PageView (NeverScrollableScrollPhysics)
       │
       ├── [Paso 1] PersonalInfoPage
       │       │
       │       └── EnterPersonalInformation(employee)
       │           │
       │           └── RegisterBloc
       │               └── emit(PersonalInfoCompleted)
       │                   → PageController.nextPage()
       │
       ├── [Paso 2] PilotInfoPage
       │       │
       │       ├── Carga lista de aerolíneas (AirlineBloc)
       │       │
       │       └── EnterPilotInformation(employee)
       │           │
       │           └── RegisterBloc
       │               └── emit(PilotInfoCompleted)
       │                   → PageController.nextPage()
       │
       └── [Paso 3] PasswordInfoPage
               │
               └── RegisterSubmitted(employee)
                   │
                   └── RegisterBloc
                       ├── emit(RegisterLoading())
                       │
                       └── RegisterUseCase.call(employee)
                           │
                           └── RegisterDatasource.registerEmployee()
                               │
                               └── HTTP POST /v1/employees
                                   │
                                   ├── 201 Created → emit(RegisterSuccess)
                                   │                 → Volver a Login
                                   │
                                   └── Error → emit(RegisterError)
```

### 5. Flujo de Recuperación de Contraseña

```
EmailInfoPage
   │
   ├── EmailFlow.registration   # Flujo normal de registro
   │
   └── EmailFlow.recovery       # Flujo de recuperación
       │
       ├── [RecoveryStep.enterEmail]
       │       └── ForgotPasswordRequested(email)
       │           → RecoveryCodeSent
       │
       ├── [RecoveryStep.enterCode]
       │       └── VerificationCodeSubmitted(code)
       │           → RecoveryCodeVerified
       │
       └── [RecoveryStep.resetPassword]
               └── PasswordResetSubmitted(newPassword)
                   → PasswordResetSuccess
```

---

## 🌐 Conexión con Backend (Golang)

### Configuración de URL Base

```dart
// lib/core/config/config.dart
class Config {
  // 📱 Simulador iOS:     "http://127.0.0.1:8081/v1"
  // 🤖 Emulador Android:  "http://10.0.2.2:8081/v1"
  // 📲 Dispositivo físico: "http://TU_IP_LOCAL:8081/v1"
  // 🌐 Producción:        "https://tu-api-produccion.com/v1"

  static const String baseUrl = "http://127.0.0.1:8081/v1";
}
```

### 📡 Endpoints Utilizados

| Método | Endpoint | Descripción | Request Body | Response |
|--------|----------|-------------|--------------|----------|
| POST | `/v1/login` | Login de empleado | `{email, password}` | `EmployeeModel` |
| POST | `/v1/employees` | Registro de empleado | `{name, airline, email, password, ...}` | `{employee: {...}}` |
| GET | `/v1/airlines` | Lista de aerolíneas | - | `[{id, name, ...}]` |
| GET | `/v1/Flighthours/email/status?email=X` | Verificar estado de email | - | `EmailVerificationModel` |

### Estructura de Payloads

**Registro de Empleado (POST /v1/employees):**
```json
{
  "name": "string",
  "airline": "string",
  "email": "string",
  "password": "string",
  "emailconfirmed": "boolean",
  "identificationNumber": "string",
  "bp": "string",
  "start_date": "string",
  "end_date": "string",
  "active": "boolean"
}
```

**Login (POST /v1/login):**
```json
{
  "email": "string",
  "password": "string"
}
```

---

## 🐳 Contenedores Docker

**⚠️ NOTA:** Este proyecto Flutter (frontend) **NO tiene contenedores Docker propios**.

Sin embargo, según las conversaciones previas, el **proyecto backend en Golang** (`flighthours-api`) utiliza los siguientes contenedores:

| Contenedor | Descripción | Puerto |
|------------|-------------|--------|
| **API Backend** | Servidor Golang (flighthours-api) | 8081 |
| **Keycloak** | Servidor de Identidad/Autenticación | 8080 |
| **PostgreSQL** | Base de datos | 5432 |

### Backend API Endpoints (a confirmar con backend)

```
Base URL: http://localhost:8081/flighthours/api/v1/

Autenticación:
  POST /auth/update-password     # Actualizar contraseña
  POST /auth/login               # Login vía Keycloak

Empleados:
  POST /employees                # Crear empleado
  GET  /employees/:id            # Obtener empleado

Email:
  GET  /Flighthours/email/status # Verificar estado de email
```

---

## 🔧 Dependencias del Proyecto

```yaml
# pubspec.yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8
  bloc: ^8.0.3           # Core BLoC
  flutter_bloc: ^8.0.1   # Flutter BLoC integration
  injector: ^4.0.0       # Dependency injection
  kiwi: ^5.0.1           # DI container
  kiwi_generator: ^4.2.1 # DI code generator
  http: ^1.4.0           # HTTP client
  equatable: ^2.0.7      # Value comparison
  intl: ^0.19.0          # Internacionalización

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^6.0.0
  build_runner: ^2.5.3   # Code generation
```

---

## 🚀 Mejoras Recomendadas

### 1. **Manejo de Errores**

**Problema:** Los datasources lanzan excepciones genéricas.

**Mejora:**
```dart
// Crear clases de error específicas
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String? errorCode;

  ApiException({required this.message, required this.statusCode, this.errorCode});
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}
```

### 2. **Token Management / Autenticación**

**Problema:** No hay manejo de tokens JWT post-login.

**Mejora:**
```dart
// Crear un AuthService/TokenManager
class TokenManager {
  static String? _accessToken;
  static String? _refreshToken;

  static void setTokens(String access, String refresh) {...}
  static String? get accessToken => _accessToken;
  static Future<void> refresh() {...}
}

// Agregar interceptor HTTP para incluir tokens
class AuthenticatedHttpClient {
  Future<http.Response> get(Uri url) async {
    final headers = {
      'Authorization': 'Bearer ${TokenManager.accessToken}',
      'Content-Type': 'application/json',
    };
    return http.get(url, headers: headers);
  }
}
```

### 3. **Almacenamiento Seguro**

**Problema:** No hay persistencia de sesión.

**Mejora:** Agregar `flutter_secure_storage`:
```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

### 4. **Loading States Consistentes**

**Problema:** Cada BLoC maneja loading de forma diferente.

**Mejora:** Crear un mixin o base state:
```dart
abstract class BaseState {
  final bool isLoading;
  final String? errorMessage;

  BaseState({this.isLoading = false, this.errorMessage});
}
```

### 5. **Retry Logic & Timeout**

**Problema:** No hay manejo de reintentos ni timeouts.

**Mejora:**
```dart
Future<Response> fetchWithRetry(Uri url, {int maxRetries = 3}) async {
  for (int i = 0; i < maxRetries; i++) {
    try {
      final response = await http.get(url).timeout(Duration(seconds: 30));
      if (response.statusCode == 200) return response;
    } catch (e) {
      if (i == maxRetries - 1) rethrow;
      await Future.delayed(Duration(seconds: 2 * (i + 1)));
    }
  }
  throw Exception('Failed after $maxRetries retries');
}
```

### 6. **Environment Configuration**

**Problema:** URLs están hardcodeadas.

**Mejora:** Usar flavors o variables de entorno:
```dart
enum Environment { dev, staging, prod }

class Config {
  static late Environment _env;

  static void initialize(Environment env) => _env = env;

  static String get baseUrl {
    switch (_env) {
      case Environment.dev:
        return 'http://127.0.0.1:8081/v1';
      case Environment.staging:
        return 'https://staging-api.example.com/v1';
      case Environment.prod:
        return 'https://api.example.com/v1';
    }
  }
}
```

### 7. **Internacionalización**

**Problema:** Mensajes están hardcodeados en español.

**Mejora:** Usar el paquete `intl` existente:
```dart
// lib/l10n/messages_es.dart
class AppLocalizations {
  static const loginError = 'Error al iniciar sesión';
  static const registerSuccess = 'Registro exitoso';
  // ...
}
```

### 8. **Testing**

**Problema:** Solo hay un archivo de test placeholder.

**Mejora:**
- Unit tests para BLoCs
- Widget tests para páginas
- Integration tests para flujos completos
- Mock de datasources con `mockito`

### 9. **Response Models Tipados**

**Problema:** Algunos parseos de JSON son manuales.

**Mejora:** Usar `json_serializable`:
```yaml
dev_dependencies:
  json_serializable: ^6.7.1
  json_annotation: ^4.8.1
```

### 10. **Estado Global de Autenticación**

**Problema:** No hay forma de saber si el usuario está autenticado globalmente.

**Mejora:** Crear un `AuthBloc` global:
```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<Logout>(_onLogout);
  }
}
```

---

## 📋 Checklist para Integración con Backend Golang

- [ ] Verificar que los endpoints del backend coincidan con los datasources
- [ ] Confirmar estructura de payloads JSON
- [ ] Implementar manejo de tokens JWT
- [ ] Configurar CORS en el backend si es necesario
- [ ] Agregar health check endpoint
- [ ] Implementar refresh token flow
- [ ] Agregar logging de requests/responses para debugging
- [ ] Configurar timeouts apropiados
- [ ] Manejar códigos de error específicos del backend
- [ ] Implementar verificación de email con backend real
- [ ] Conectar flujo de recuperación de contraseña con backend

---

## Diagrama de Flujo Completo

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              FLUTTER APP                                    │
│  ┌─────────────┐                                                            │
│  │  main.dart  │                                                            │
│  └──────┬──────┘                                                            │
│         │                                                                   │
│         ▼                                                                   │
│  ┌─────────────────────────────────────────────────────┐                   │
│  │              MultiBlocProvider                       │                   │
│  │  ┌──────────────┐ ┌───────────────┐                 │                   │
│  │  │ RegisterBloc │ │   LoginBloc   │ ...             │                   │
│  │  └──────────────┘ └───────────────┘                 │                   │
│  └───────────────────────────┬─────────────────────────┘                   │
│                              │                                              │
│                              ▼                                              │
│  ┌─────────────────────────────────────────────────────┐                   │
│  │                     AuthPage                         │                   │
│  │     ┌──────────────┐     ┌───────────────┐          │                   │
│  │     │  LoginPage   │ ←→  │ RegisterPage  │          │                   │
│  │     └──────┬───────┘     └───────┬───────┘          │                   │
│  │            │                     │                   │                   │
│  │            ▼                     ▼                   │                   │
│  │     ┌──────────────┐     ┌───────────────────┐      │                   │
│  │     │ LoginUseCase │     │ RegisterUseCase   │      │                   │
│  │     └──────┬───────┘     └───────┬───────────┘      │                   │
│  │            │                     │                   │                   │
│  │            ▼                     ▼                   │                   │
│  │     ┌────────────────────────────────────────┐      │                   │
│  │     │            DataSources                 │      │                   │
│  │     │  LoginDS | RegisterDS | AirlineDS     │      │                   │
│  │     └────────────────┬───────────────────────┘      │                   │
│  └──────────────────────┼──────────────────────────────┘                   │
│                         │ HTTP                                              │
└─────────────────────────┼───────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           GOLANG BACKEND                                    │
│  ┌──────────────────────────────────────────────────────────┐              │
│  │                    API Gateway (:8081)                    │              │
│  │  /v1/login  |  /v1/employees  |  /v1/airlines  | ...     │              │
│  └──────────────────────────┬───────────────────────────────┘              │
│                             │                                               │
│                             ▼                                               │
│  ┌──────────────────────────────────────────────────────────┐              │
│  │                     Keycloak (:8080)                      │              │
│  │              (Autenticación / Tokens JWT)                 │              │
│  └──────────────────────────────────────────────────────────┘              │
│                             │                                               │
│                             ▼                                               │
│  ┌──────────────────────────────────────────────────────────┐              │
│  │                   PostgreSQL (:5432)                      │              │
│  │                      (Datos)                              │              │
│  └──────────────────────────────────────────────────────────┘              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

*Última actualización: Diciembre 2024*
