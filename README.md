# FlightHours Frontend

[![Flutter Version](https://img.shields.io/badge/Flutter-3.32.0-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/Dart-3.8.0-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![SonarCloud](https://img.shields.io/badge/SonarCloud-Analyzed-F3702A?logo=sonarcloud)](https://sonarcloud.io/project/overview?id=champion19_Flighthours_frontend)

> Aplicación móvil multiplataforma de **FlightHours** — sistema de gestión de horas de vuelo para pilotos y aerolíneas, construido con Flutter siguiendo Clean Architecture y el patrón BLoC para la gestión de estado.

---

## 📖 Tabla de Contenidos

- [Visión](#-visión)
- [Funcionalidades Principales](#-funcionalidades-principales)
- [Stack Tecnológico](#-stack-tecnológico)
- [Arquitectura](#-arquitectura)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Inicio Rápido](#-inicio-rápido)
- [Configuración](#️-configuración)
- [Módulos de Funcionalidad](#-módulos-de-funcionalidad)
- [Testing](#-testing)
- [Calidad de Código](#-calidad-de-código)
- [Seguridad](#️-seguridad)
- [Licencia](#-licencia)

---

## 🎯 Visión

Para Pilotos y administradores en general que presentan deficiencias en el seguimiento y monitoreo de sus horas de vuelo, lo que puede derivar en problemas de salud, económicos, sociales y legales, Flight Hours es un Aplicación web y móvil que incorpora las mejores prácticas y técnicas basadas en estudios médicos, físicos, laborales y emocionales; pensada en satisfacer las necesidades del usuario final.Este sistema  garantizará un acceso confiable y seguro a la información, priorizando siempre el derecho a la protección de los datos almacenados. A diferencia de Aplicaciones como Logten Pro, ForeFlight, FlightLogger, CrewLounge y ZuluLog, nuestro producto  ofrecerá una interacción amigable e intuitiva  y estará diseñado bajo principios de experiencia de usuario, será multiplataforma (compatible con ordenadores, tabletas y smartphones), y podrá ser administrado y gestionado conforme a la normativa legal vigente aplicable a cada cliente.

---

## ✨ Funcionalidades Principales

- **Autenticación y Registro** — Login, registro de empleados, verificación de email y flujos de restablecimiento de contraseña
- **Integración con Identity Provider** — Keycloak para gestión segura de identidad y acceso (OIDC/JWT)
- **Dashboards Diferenciados por Rol** — Vistas separadas para Piloto (`/home`) y Administrador (`/admin-home`) con redirección automática post-login
- **Bitácora de Vuelo (Logbook)** — Registro de vuelos diarios con detalle de horas, rutas, tripulación y aeronave asignada
- **Gestión de Aerolíneas** — Consulta, activación y desactivación de aerolíneas con diálogos de confirmación de seguridad
- **Gestión de Aeropuertos** — Administración del estado de aeropuertos con impacto reactivo en visibilidad de rutas
- **Gestión de Rutas y Rutas de Aerolínea** — Consulta de rutas globales y gestión de asignaciones ruta-aerolínea con toggle de estado
- **Gestión de Modelos de Aeronave** — Activación/desactivación de modelos con búsqueda por familia de aeronave
- **Gestión de Fabricantes** — Catálogo de fabricantes con branding visual especializado (logos de Airbus, Boeing)
- **Perfil de Empleado** — Visualización y edición de datos profesionales, asociación de aerolínea y cambio de contraseña
- **Búsqueda de Matrículas (Tail Number)** — Lookup de aeronaves por número de matrícula
- **Tipos de Tripulante** — Consulta de tipos de miembro de tripulación
- **Resumen de Vuelos** — Estadísticas y resúmenes de actividad de vuelo
- **Diseño Responsivo** — Adaptación automática a diferentes tamaños de pantalla (móvil, tablet, web)
- **Gestión Segura de Sesiones** — Almacenamiento seguro de tokens con auto-refresh y logout forzado ante expiración

---

## 🛠 Stack Tecnológico

| Categoría                           | Tecnología                                                                               |
| ------------------------------------ | ----------------------------------------------------------------------------------------- |
| **Framework**                  | [Flutter](https://flutter.dev/) 3.32.0                                                       |
| **Lenguaje**                   | [Dart](https://dart.dev/) 3.8.0 (SDK ≥3.7.0)                                                |
| **Gestión de Estado**         | [flutter_bloc](https://pub.dev/packages/flutter_bloc) (BLoC Pattern)                         |
| **Cliente HTTP**               | [Dio](https://pub.dev/packages/dio) 5.7.0                                                    |
| **Inyección de Dependencias** | [Kiwi](https://pub.dev/packages/kiwi) + [Injector](https://pub.dev/packages/injector)           |
| **Almacenamiento Seguro**      | [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)                    |
| **Comparación de Entidades**  | [Equatable](https://pub.dev/packages/equatable)                                              |
| **Programación Funcional**    | [dartz](https://pub.dev/packages/dartz)                                                      |
| **Internacionalización**      | [intl](https://pub.dev/packages/intl)                                                        |
| **Splash Screen**              | [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)                      |
| **Identity Provider**          | [Keycloak](https://www.keycloak.org/) (OIDC + JWT)                                           |
| **Backend API**                | Go (api-flighthours) — REST API                                                          |
| **Testing**                    | [mocktail](https://pub.dev/packages/mocktail) + [bloc_test](https://pub.dev/packages/bloc_test) |
| **Calidad de Código**         | SonarCloud +`flutter analyze`                                                           |
| **Plataformas**                | Android, iOS, Web, macOS, Linux, Windows                                                  |

---

## 🏗 Arquitectura

FlightHours sigue una **Clean Architecture** modular organizada por features, con el patrón **BLoC** para la gestión de estado:

```
┌─────────────────────────────────────────────────────────────┐
│                    presentation/                             │
│   ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│   │    pages/     │  │   widgets/   │  │      bloc/       │  │  ← UI Layer
│   │  (Screens)    │  │ (Reusables)  │  │ (Events/States)  │  │
│   └──────────────┘  └──────────────┘  └──────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                      domain/                                 │
│   ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│   │   entities/   │  │  usecases/   │  │  repositories/   │  │  ← Business Logic
│   │  (Modelos de  │  │ (Casos de    │  │  (Contratos /    │  │
│   │   dominio)    │  │   uso)       │  │   Interfaces)    │  │
│   └──────────────┘  └──────────────┘  └──────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                       data/                                  │
│   ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│   │   models/     │  │ datasources/ │  │  repositories/   │  │  ← Infrastructure
│   │   (DTOs)      │  │  (API/Dio)   │  │  (Implementación)│  │
│   └──────────────┘  └──────────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

**Principios clave:**

- Las dependencias apuntan **hacia adentro** — `data` implementa las interfaces de `domain/repositories`
- La lógica de negocio en `domain/usecases` es **agnóstica al framework**
- `presentation/bloc` orquesta la comunicación entre la UI y los casos de uso
- `presentation/pages` solo construye widgets en base al estado actual del BLoC
- **15 BLoCs globales** gestionados desde un `MultiBlocProvider` raíz en `main.dart`
- **Simplified Result Pattern** — Métodos retornan `Future<T>` directamente; las excepciones se propagan hasta el BLoC donde se mapean a estados de error

---

## 📁 Estructura del Proyecto

```
flight_hours_app/
├── lib/
│   ├── main.dart                        # Punto de entrada, MultiBlocProvider y rutas
│   ├── core/
│   │   ├── authpage.dart                # Guard de autenticación y redirección por rol
│   │   ├── config/                      # Configuración de URL del backend
│   │   ├── constants/                   # Mensajes centralizados por feature
│   │   │   ├── admin_messages.dart      #   → Textos del dashboard de admin
│   │   │   ├── employee_messages.dart   #   → Textos del dashboard de piloto
│   │   │   ├── login_messages.dart      #   → Textos de autenticación
│   │   │   ├── validation_messages.dart #   → Mensajes de validación globales
│   │   │   └── schema_constants.dart    #   → Constantes de esquema
│   │   ├── errors/                      # Clases de error de dominio
│   │   ├── injector/                    # Inyección de dependencias (Kiwi)
│   │   │   ├── injector.dart            #   → Registro manual de dependencias
│   │   │   └── injector.g.dart          #   → Código generado
│   │   ├── network/                     # Capa de red
│   │   │   ├── dio_client.dart          #   → Cliente HTTP con interceptores
│   │   │   ├── dio_web_impl.dart        #   → Implementación para Flutter Web
│   │   │   └── dio_web_stub.dart        #   → Stub para plataformas no-web
│   │   ├── responsive/                  # Sistema de diseño responsivo
│   │   │   ├── adaptive_scaffold.dart   #   → Scaffold adaptativo
│   │   │   ├── responsive_breakpoints.dart
│   │   │   ├── responsive_layout.dart
│   │   │   └── responsive_padding.dart
│   │   ├── services/                    # Servicios transversales
│   │   │   ├── session_service.dart     #   → Gestión de sesión y tokens
│   │   │   └── token_refresh_service.dart #  → Auto-refresh de JWT
│   │   ├── validator/                   # Mapeo de errores del backend
│   │   ├── validators/                  # Validadores de formularios
│   │   └── widgets/                     # Widgets reutilizables globales
│   │       ├── app_page_header.dart
│   │       ├── gradient_icon_box.dart
│   │       └── responsive_body.dart
│   └── features/                        # Módulos de funcionalidad (20 features)
│       ├── admin/                       # Dashboard de administrador
│       ├── aircraft_model/              # Gestión de modelos de aeronave
│       ├── airline/                     # Gestión de aerolíneas
│       ├── airline_route/               # Asignaciones ruta-aerolínea
│       ├── airport/                     # Gestión de aeropuertos
│       ├── alerts/                      # Sistema de alertas
│       ├── crew_member_type/            # Tipos de tripulante
│       ├── daily_logbook_detail/        # Detalle de bitácora diaria
│       ├── email_verification/          # Verificación de email
│       ├── employee/                    # Perfil de empleado y aerolínea
│       ├── flight/                      # Registro de vuelos
│       ├── flight_summary/              # Resúmenes de vuelo
│       ├── logbook/                     # Bitácora de vuelo
│       ├── login/                       # Autenticación (Login)
│       ├── manufacturer/               # Catálogo de fabricantes
│       ├── register/                    # Registro de empleados
│       ├── reset_password/              # Restablecimiento de contraseña
│       ├── route/                       # Rutas globales
│       ├── splash/                      # Pantalla de splash
│       └── tail_number/                 # Búsqueda de matrículas
├── test/                                # Tests unitarios y de widgets (1,150+ tests)
│   ├── core/                            # Tests de utilidades y validadores
│   ├── domain/                          # Tests de entidades
│   └── features/                        # Tests por feature (130+ archivos)
├── assets/
│   └── images/                          # Logos, splash, branding de fabricantes
│       └── manufacturers/               # Logos de Airbus, Boeing, etc.
├── docs/                                # Documentación adicional
├── coverage/                            # Reportes de cobertura generados
├── pubspec.yaml                         # Dependencias y configuración
├── analysis_options.yaml                # Reglas de lint (flutter_lints)
├── sonar-project.properties             # Integración con SonarCloud
├── flutter_native_splash.yaml           # Configuración de splash screen
└── devtools_options.yaml                # Configuración de DevTools
```

Cada feature sigue la estructura hexagonal de **8 directorios**:

```
features/{feature_name}/
├── data/
│   ├── datasources/    # Llamadas API vía Dio
│   ├── models/         # DTOs (Data Transfer Objects)
│   └── repositories/   # Implementación de repositorios
├── domain/
│   ├── entities/       # Entidades de dominio (Equatable)
│   ├── repositories/   # Interfaces (contratos abstractos)
│   └── usecases/       # Casos de uso
└── presentation/
    ├── bloc/           # BLoC (Events + States + Bloc)
    └── pages/          # Pantallas de UI
```

---

## 🚀 Inicio Rápido

**Tiempo estimado:** 10–15 minutos

### Prerrequisitos

| Herramienta           | Versión             | Propósito                                              |
| --------------------- | -------------------- | ------------------------------------------------------- |
| **Flutter**     | ≥ 3.32.0            | Framework de desarrollo                                 |
| **Dart**        | ≥ 3.7.0             | Lenguaje de programación                               |
| **Git**         | Cualquiera           | Control de versiones                                    |
| **Backend API** | api-flighthours (Go) | API RESTful del backend corriendo en `localhost:8081` |
| **Keycloak**    | ≥ 20.0              | Identity Provider (opcional para desarrollo local)      |

### Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/champion19/Flighthours_frontend.git
cd Flighthours_frontend
```

### Paso 2: Instalar Dependencias

```bash
flutter pub get
```

### Paso 3: Configurar la URL del Backend

Editar `lib/core/config/config.dart` según tu entorno:

```dart
class Config {
  // 📱 Simulador iOS / Web:     "http://127.0.0.1:8081/flighthours/api/v1"
  // 🤖 Emulador Android:        "http://10.0.2.2:8081/flighthours/api/v1"
  // 📲 Dispositivo físico:      "http://TU_IP_LOCAL:8081/flighthours/api/v1"
  // 🌐 Producción:              "https://tu-api.com/flighthours/api/v1"

  static const String baseUrl = "http://localhost:8081/flighthours/api/v1";
}
```

### Paso 4: Ejecutar la Aplicación

```bash
# iOS Simulator
flutter run -d ios

# Android Emulator
flutter run -d android

# Chrome (Web)
flutter run -d chrome

# macOS Desktop
flutter run -d macos
```

### ✅ Verificación

| Comprobación                  | Cómo verificar                                                  |
| ------------------------------ | ---------------------------------------------------------------- |
| **App corriendo**        | La pantalla de splash se muestra seguida de la pantalla de login |
| **Conexión al backend** | El login exitoso redirige al dashboard correspondiente al rol    |
| **Análisis limpio**     | `flutter analyze` retorna `No issues found!`                 |
| **Tests pasando**        | `flutter test` ejecuta 1,150+ tests sin fallos                 |

---

## ⚙️ Configuración

### URL del Backend

La configuración del backend se gestiona en `lib/core/config/config.dart`. La URL base apunta al API REST del backend FlightHours:

| Entorno                       | URL                                            |
| ----------------------------- | ---------------------------------------------- |
| **iOS Simulator / Web** | `http://127.0.0.1:8081/flighthours/api/v1`   |
| **Android Emulator**    | `http://10.0.2.2:8081/flighthours/api/v1`    |
| **Dispositivo Físico** | `http://TU_IP_LOCAL:8081/flighthours/api/v1` |
| **Producción**         | `https://tu-dominio.com/flighthours/api/v1`  |

### Cliente HTTP (Dio)

El `DioClient` en `lib/core/network/dio_client.dart` incluye:

- **Interceptor de autenticación** — Inyección automática del Bearer token en cada request
- **Auto-refresh de tokens** — Renovación transparente del JWT expirado vía `TokenRefreshService`
- **Logout forzado** — Redirección automática al login cuando el refresh token expira (HTTP 401)
- **Sanitización de logs** — Enmascaramiento de passwords y tokens en los logs (`[HIDDEN]`)
- **Soporte Web** — Implementaciones condicionales (`dio_web_impl.dart` / `dio_web_stub.dart`) para HttpOnly cookies en Flutter Web

### Gestión de Sesión

El `SessionService` en `lib/core/services/`:

- Almacena tokens (access + refresh) en `flutter_secure_storage`
- Persiste el rol del usuario para redirección correcta al reiniciar la app
- Mantiene metadata de identidad del empleado (ID, nombre, rol)

---

## 📦 Módulos de Funcionalidad

La aplicación cuenta con **20 módulos de funcionalidad** organizados en features independientes:

### 🔐 Autenticación y Registro

| Módulo                      | Rutas               | Descripción                                                                              |
| ---------------------------- | ------------------- | ----------------------------------------------------------------------------------------- |
| **Login**              | `/login`          | Autenticación con descubrimiento de rol post-login                                       |
| **Register**           | —                  | Formulario multi-paso (datos personales, info de piloto, selección de aerolínea, email) |
| **Email Verification** | `/email`          | Verificación de cuenta vía email                                                        |
| **Reset Password**     | `/reset-password` | Solicitud y actualización de contraseña                                                 |

### 👨‍✈️ Dashboard de Piloto

| Módulo                        | Rutas                     | Descripción                                                |
| ------------------------------ | ------------------------- | ----------------------------------------------------------- |
| **Home (Piloto)**        | `/home`                 | Dashboard con saludo, info de aerolínea, acciones rápidas |
| **Logbook**              | `/logbook`              | Bitácora de vuelo con registro de horas diarias            |
| **New Flight**           | `/new-flight`           | Formulario de registro de nuevo vuelo                       |
| **Daily Logbook Detail** | `/daily-logbook-detail` | Detalle de registros de vuelo del día                      |
| **Flight Summary**       | —                        | Resúmenes y estadísticas de actividad de vuelo            |
| **Employee Profile**     | `/employee-profile`     | Perfil profesional y asociación de aerolínea              |
| **Change Password**      | `/change-password`      | Cambio de contraseña autenticado                           |

### 🛡️ Dashboard de Administrador

| Módulo                     | Rutas                  | Descripción                                                   |
| --------------------------- | ---------------------- | -------------------------------------------------------------- |
| **Admin Home**        | `/admin-home`        | Panel de administración con tarjetas de acceso rápido        |
| **Airlines**          | `/airlines`          | Gestión de aerolíneas (consultar, activar, desactivar)       |
| **Airports**          | `/airports`          | Gestión de aeropuertos (consultar, activar, desactivar)       |
| **Routes**            | `/flight-routes`     | Consulta de rutas globales (solo lectura)                      |
| **Airline Routes**    | `/airline-routes`    | Gestión de asignaciones ruta-aerolínea (activar, desactivar) |
| **Aircraft Models**   | `/aircraft-models`   | Gestión de modelos de aeronave (activar, desactivar)          |
| **Aircraft Families** | `/aircraft-families` | Búsqueda de modelos por familia de aeronave                   |
| **Manufacturers**     | `/manufacturers`     | Catálogo de fabricantes con branding visual                   |
| **Crew Member Types** | `/crew-member-types` | Consulta de tipos de tripulante                                |
| **Tail Numbers**      | `/tail-number`       | Búsqueda de aeronaves por matrícula                          |

### 🔗 Endpoints del Backend Consumidos

La aplicación consume la API RESTful del backend (`api-flighthours`) con los siguientes grupos de endpoints:

| Grupo                    | Endpoints                                                             | Métodos                    |
| ------------------------ | --------------------------------------------------------------------- | --------------------------- |
| **Auth**           | `/login`, `/register`, `/auth/*`                                | `POST`                    |
| **Employees**      | `/employees`, `/employees/airline`, `/employees/airline-routes` | `GET`, `PUT`, `PATCH` |
| **Airlines**       | `/airlines`, `/airlines/{id}/*`                                   | `GET`, `PATCH`          |
| **Routes**         | `/routes`, `/routes/{id}`                                         | `GET`                     |
| **Airline Routes** | `/airline-routes`, `/airline-routes/{id}/*`                       | `GET`, `PATCH`          |
| **Airports**       | `/airports`, `/airports/{id}/*`                                   | `GET`, `PATCH`          |
| **Aircraft**       | `/aircraft-models`, `/aircraft-families/{family}`                 | `GET`, `PATCH`          |
| **Logbooks**       | `/daily-logbooks`                                                   | `GET`                     |

---

## 🧪 Testing

### Ejecutar Todos los Tests

```bash
flutter test
```

### Reporte de Cobertura

```bash
# Generar reporte LCOV
flutter test --coverage

# Generar HTML (requiere lcov instalado)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Estado de Cobertura

| Métrica                      | Valor                    |
| ----------------------------- | ------------------------ |
| **Cobertura de línea** | **70%+**           |
| **Tests totales**       | **1,150+** pasando |
| **Target**              | **80%**            |

### Cobertura por Capa

| Capa                      | Cobertura | Archivos                             |
| ------------------------- | --------- | ------------------------------------ |
| **Models**          | ✅ 100%   | 21 modelos                           |
| **Datasources**     | ✅ 100%   | 10 datasources remotos               |
| **Repositories**    | ✅ 100%   | 10 repositorios                      |
| **Use Cases**       | ✅ 100%   | 15 casos de uso                      |
| **BLoCs (lógica)** | ✅ 100%   | 10 BLoCs refactorizados para DI      |
| **Pages (widgets)** | 📈 28%    | Rollout progresivo de widget testing |

### Stack de Testing

| Biblioteca       | Propósito                                               |
| ---------------- | -------------------------------------------------------- |
| `flutter_test` | Framework base de testing                                |
| `mocktail`     | Mocking de dependencias (Dio, repositories, datasources) |
| `bloc_test`    | Testing de BLoCs con `blocTest<B, S>()`                |
| `mockito`      | Mocking adicional                                        |

---

## 📊 Calidad de Código

### SonarCloud

El proyecto está integrado con [SonarCloud](https://sonarcloud.io/project/overview?id=champion19_Flighthours_frontend) para análisis estático continuo:

- **Project Key**: `champion19_Flighthours_frontend`
- **Sources**: `lib/`
- **Tests**: `test/`
- **Exclusiones**: `*.g.dart`, `*.freezed.dart`, `*.mocks.dart`, `generated/`

### Análisis Estático

```bash
# Ejecutar el analizador de Dart/Flutter
flutter analyze

# Esperado: No issues found!
```

### Linting

Configurado en `analysis_options.yaml` con el paquete `flutter_lints` que incluye reglas recomendadas para aplicaciones Flutter.

---

## 🛡️ Seguridad

### Gestión de Tokens

- **Almacenamiento**: Los tokens JWT (access + refresh) se almacenan en `flutter_secure_storage`, cifrados a nivel del sistema operativo
- **Auto-refresh**: El `TokenRefreshService` renueva automáticamente el access token antes de su expiración
- **Logout forzado**: Si el refresh token expira o es inválido, el `DioClient` fuerza un logout limpio y redirige al login
- **Sanitización**: Headers de autorización y campos sensibles (passwords, tokens) se enmascaran como `[HIDDEN]` en los logs

### Nota sobre Credenciales

> **Este repositorio es un proyecto de grado académico.** La configuración incluida en `lib/core/config/config.dart` contiene URLs de desarrollo local que se incluyen intencionalmente para facilitar la ejecución y evaluación del proyecto.

| Archivo                         | ¿Commiteado? | Propósito                                            |
| ------------------------------- | :-----------: | ----------------------------------------------------- |
| `lib/core/config/config.dart` |    ✅ Sí    | URL base del backend (solo desarrollo local)          |
| Tokens y credenciales           |     ❌ No     | Se almacenan en `flutter_secure_storage` en runtime |

### Autenticación y Autorización

```
Flujo de autenticación:

  Login → JWT Tokens → Role Discovery (GET /employees) → Redirect por Rol
                                                            ├── Admin  → /admin-home
                                                            └── Pilot  → /home
```

- **Identity Provider**: Keycloak gestiona autenticación via OIDC
- **Bearer Token**: Inyectado automáticamente en cada request HTTP
- **Role-Based Access**: La UI se adapta al rol del usuario descubierto post-login
- **Session Persistence**: El rol se persiste para restaurar la landing page correcta al reiniciar

---

## 📄 Licencia

Este proyecto está licenciado bajo la [Licencia MIT](LICENSE).

---

<p align="center">
  <sub>Hecho con ❤️ por Emmanuel Londoño Gómez</sub>
</p>
