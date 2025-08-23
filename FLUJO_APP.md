
# Documentación del Flujo de la Aplicación

Este documento explica el flujo de la aplicación, con un enfoque en la interacción entre la interfaz de usuario (UI), el manejo de estado con BLoC y la navegación entre páginas.

## 1. Punto de Entrada (`main.dart`)

- La aplicación se inicia en `main.dart`.
- Se inicializa un `MultiBlocProvider` que provee los BLoCs `LoginBloc` y `RegisterBloc` al árbol de widgets. Esto permite que cualquier widget descendiente pueda acceder a estos BLoCs.
- La página principal es `AuthPage`.

## 2. `AuthPage` - El Conmutador de Autenticación

- `AuthPage` es un `StatefulWidget` que actúa como un simple conmutador entre las páginas de inicio de sesión y registro.
- Mantiene un estado interno (`_state`) para decidir qué página mostrar: `LoginPage` o `RegisterPage`.
- Proporciona callbacks a las páginas hijas (`onSwitchToRegister` y `onSwitchToLogin`) para que puedan solicitar el cambio de página.

## 3. Flujo de Registro (`RegisterPage` y `PageView`)

El flujo de registro es un proceso de varios pasos gestionado por un `PageView` dentro de `RegisterPage`.

### 3.1. `RegisterPage`

- `RegisterPage` contiene un `PageView` que no permite el desplazamiento manual (`NeverScrollableScrollPhysics`). La navegación entre las páginas del `PageView` es controlada programáticamente.
- Utiliza un `BlocListener` para escuchar los cambios de estado en `RegisterBloc`.

### 3.2. Pasos del `PageView`

El `PageView` consta de tres páginas:

1.  **`PersonalInfoPage`**:
    *   Muestra un formulario para que el usuario ingrese su información personal.
    *   Al enviar el formulario, se dispara un evento `EnterPersonalInfo` en `RegisterBloc`.

2.  **`PilotInfoPage`**:
    *   Muestra un formulario para la información del piloto.
    *   Se activa después de que la información personal se ha completado.
    *   Al enviar, se dispara un evento `EnterPilotInfo` en `RegisterBloc`.

3.  **`PasswordInfoPage`**:
    *   El último paso, donde el usuario establece su contraseña.
    *   Al enviar, se dispara el evento `RegisterSubmitted`.

### 3.3. Interacción con `RegisterBloc` y Navegación

El `BlocListener` en `RegisterPage` reacciona a los estados emitidos por `RegisterBloc` para controlar la navegación:

-   **`PersonalInfoCompleted`**: Cuando `RegisterBloc` emite este estado, el `BlocListener` llama a `_navigateToNextPage()`, que avanza el `PageView` a `PilotInfoPage`.
-   **`PilotInfoCompleted`**: De manera similar, este estado avanza el `PageView` a `PasswordInfoPage`.
-   **`RegisterSuccess`**: Indica que el registro fue exitoso. El `BlocListener` llama a `_handleRegisterSuccess()`, que a su vez utiliza el callback `onSwitchToLogin` para volver a la página de inicio de sesión.
-   **`RegisterError`**: Si ocurre un error, se muestra un `SnackBar` con el mensaje de error.

## 4. El Rol de `RegisterBloc`

`RegisterBloc` es el cerebro detrás del flujo de registro.

-   **Estado (`RegisterState`)**: Mantiene el estado actual del proceso de registro. Esto incluye:
    *   `RegisterInitial`: El estado inicial.
    *   `RegisterLoading`: Indica que una operación está en curso.
    *   `PersonalInfoCompleted`: Contiene la entidad `EmployeeEntityRegister` con la información personal.
    *   `PilotInfoCompleted`: Contiene la entidad `EmployeeEntityRegister` con la información personal y de piloto.
    *   `RegisterSuccess`: Estado final de éxito.
    *   `RegisterError`: Estado de error con un mensaje.

-   **Eventos (`RegisterEvent`)**: Son las acciones que la UI envía al BLoC:
    *   `EnterPersonalInfo`: Se envía desde `PersonalInfoPage`.
    *   `EnterPilotInfo`: Se envía desde `PilotInfoPage`.
    *   `RegisterSubmitted`: Se envía desde `PasswordInfoPage` para finalizar el registro.

-   **Lógica de Negocio**: El BLoC recibe eventos, procesa la información (por ejemplo, llamando a un servicio para guardar los datos) y emite nuevos estados. La UI reacciona a estos cambios de estado de forma declarativa.

## Diagrama de Flujo Simplificado

```
main.dart
   |
   v
AuthPage
   |
   +--> LoginPage
   |
   +--> RegisterPage
         |
         v
      PageView
         |
         +--> PersonalInfoPage --(EnterPersonalInfo event)--> RegisterBloc
         |                                                     |
         |                                                     v
         |                                                 (PersonalInfoCompleted state)
         |                                                     |
         +<----------------------------------------------------+ (Navega a la siguiente página)
         |
         +--> PilotInfoPage --(EnterPilotInfo event)--> RegisterBloc
         |                                                 |
         |                                                 v
         |                                             (PilotInfoCompleted state)
         |                                                 |
         +<------------------------------------------------+ (Navega a la siguiente página)
         |
         +--> PasswordInfoPage --(RegisterSubmitted event)--> RegisterBloc
                                                             |
                                                             v
                                                         (RegisterSuccess state)
                                                             |
                                                             v
                                                         AuthPage (vuelve a Login)
```
