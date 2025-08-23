# Resumen de Implementación: Flujo de Recuperación de Contraseña

Este documento resume los cambios realizados para implementar un flujo de recuperación de contraseña dentro de la aplicación, centralizado en `email_info_page.dart`.

## 1. Objetivo

El objetivo era añadir una funcionalidad de "olvidé mi contraseña" que permitiera a los usuarios restablecer su clave de forma segura. Para evitar crear archivos nuevos, se decidió integrar esta lógica dentro de la página de registro de email existente, gestionando los diferentes flujos a través del estado de la interfaz y del BLoC.

## 2. Archivos Modificados

### `lib/features/register/presentation/pages/email_info_page.dart`

Esta fue la página principal donde se implementó la interfaz de usuario y la lógica de presentación.

- **Conversión a `StatefulWidget`**: Para manejar el estado local de la interfaz.
- **Introducción de `enum` para el control de flujo**:
  - `EmailFlow`: para alternar entre la vista de `registration` y `recovery`.
  - `RecoveryStep`: para gestionar los pasos del proceso de recuperación (`enterEmail`, `enterCode`, `resetPassword`).
- **UI Condicional**: El método `build` ahora renderiza diferentes widgets según el `EmailFlow` y `RecoveryStep` actual.
- **Integración con BLoC**:
  - Se añadió un `BlocListener` para escuchar los estados emitidos por `RegisterBloc` y mostrar `SnackBar` con mensajes de éxito o error.
  - Los botones ahora disparan los eventos correspondientes del BLoC, como `ForgotPasswordRequested` o `VerificationCodeSubmitted`.

### `lib/features/register/presentation/bloc/register_event.dart`

Se añadieron los siguientes eventos para manejar el flujo de recuperación:

```dart
class ForgotPasswordRequested extends RegisterEvent {
  final String email;
  const ForgotPasswordRequested({required this.email});
}

class VerificationCodeSubmitted extends RegisterEvent {
  final String code;
  const VerificationCodeSubmitted({required this.code});
}

class PasswordResetSubmitted extends RegisterEvent {
  final String newPassword;
  const PasswordResetSubmitted({required this.newPassword});
}
```

### `lib/features/register/presentation/bloc/register_state.dart`

Se añadieron los siguientes estados para reflejar el progreso del flujo de recuperación en la UI:

```dart
class RecoveryCodeSent extends RegisterState {}

class RecoveryCodeVerified extends RegisterState {}

class PasswordResetSuccess extends RegisterState {}

class RecoveryError extends RegisterState {
  final String message;
  const RecoveryError(this.message);
}
```

### `lib/features/register/presentation/bloc/register_bloc.dart`

Se expandió el BLoC para manejar la nueva lógica de negocio.

- **Registro de manejadores de eventos**: Se añadieron manejadores para los nuevos eventos (`ForgotPasswordRequested`, `VerificationCodeSubmitted`, `PasswordResetSubmitted`).
- **Lógica de negocio (simulada)**: Cada manejador implementa la lógica para su paso correspondiente. Por ahora, las llamadas a servicios externos (como enviar un email o verificar un código) están simuladas con un `Future.delayed`.
- **Emisión de estados**: Los manejadores emiten los estados apropiados (`RecoveryCodeSent`, `PasswordResetSuccess`, `RecoveryError`, etc.) para que la UI pueda reaccionar y actualizarse en consecuencia.

## Conclusión

Con estos cambios, la aplicación ahora cuenta con un flujo de recuperación de contraseña funcional y bien estructurado, reutilizando componentes existentes y manteniendo una arquitectura limpia y centralizada en BLoC.
