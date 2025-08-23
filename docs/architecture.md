
# Arquitectura de la Aplicación

Esta aplicación de Flutter sigue una arquitectura limpia, separando las responsabilidades en diferentes capas. Esto facilita el mantenimiento, la escalabilidad y la realización de pruebas.

## Capas de la Arquitectura

La aplicación se divide en tres capas principales:

1.  **Capa de Presentación:** Responsable de la interfaz de usuario (UI) y la interacción con el usuario.
2.  **Capa de Dominio:** Contiene la lógica de negocio de la aplicación.
3.  **Capa de Datos:** Encargada de obtener y almacenar datos de diferentes fuentes (API, base de datos local, etc.).

### Estructura de Carpetas

La estructura de carpetas refleja esta arquitectura:

```
lib/
├── core/
│   ├── authpage.dart
│   ├── config/
│   ├── errors/
│   ├── injector/
│   └── validator/
├── features/
│   ├── login/
│   └── register/
└── main.dart
```

-   **`core`**: Contiene la lógica y las funcionalidades principales que son compartidas por toda la aplicación.
    -   **`config`**: Clases de configuración, como la inyección de dependencias.
    -   **`errors`**: Manejo de errores y excepciones personalizadas.
    -   **`injector`**: Configuración de la inyección de dependencias (por ejemplo, con `get_it`).
    -   **`validator`**: Funciones de validación reutilizables.
-   **`features`**: Cada funcionalidad de la aplicación (por ejemplo, `login`, `register`) tiene su propio directorio.
    -   **`[feature_name]`**:
        -   **`data`**: Implementación de la capa de datos.
            -   **`datasources`**: Fuentes de datos (remotas o locales).
            -   **`models`**: Modelos de datos específicos de la fuente de datos.
            -   **`repositories`**: Implementación de los repositorios del dominio.
        -   **`domain`**: Lógica de negocio de la funcionalidad.
            -   **`entities`**: Entidades de negocio.
            -   **`repositories`**: Contratos (clases abstractas) para los repositorios.
            -   **`usecases`**: Casos de uso que encapsulan la lógica de negocio.
        -   **`presentation`**: Capa de presentación de la funcionalidad.
            -   **`bloc`**: Business Logic Component (BLoC) para gestionar el estado.
            -   **`pages`**: Pantallas de la aplicación.
            -   **`widgets`**: Widgets reutilizables.
-   **`main.dart`**: Punto de entrada de la aplicación.

## Flujo de Navegación con PageView

La navegación entre las pantallas de registro (`personal_info_page.dart`, `pilot_info_page.dart`, etc.) se gestiona mediante un `PageView`.

### PageView

El `PageView` es un widget de Flutter que permite crear una lista de páginas deslizables. Cada página ocupa toda la pantalla del `PageView`.

### PageController

Para controlar el `PageView`, se utiliza un `PageController`. Este controlador permite:

-   **Navegar a una página específica:** `pageController.animateToPage()`
-   **Navegar a la siguiente página:** `pageController.nextPage()`
-   **Navegar a la página anterior:** `pageController.previousPage()`

### Implementación

En tu aplicación, el `PageView` se encuentra probablemente en una pantalla principal que contiene las diferentes etapas del registro. Cada etapa es un widget separado (por ejemplo, `Personalinfo`, `PilotInfoPage`).

El `PageController` se crea en el estado de esta pantalla principal y se pasa como parámetro a cada una de las páginas del `PageView`.

Cuando el usuario completa la información en una página y presiona el botón "Continuar", se llama al método `nextPage()` del `PageController` para mostrar la siguiente página de registro.

**Ejemplo:**

```dart
// En la pantalla principal del registro
final _pageController = PageController();

PageView(
  controller: _pageController,
  children: [
    Personalinfo(pageController: _pageController),
    PilotInfoPage(pageController: _pageController),
    // ... otras páginas de registro
  ],
);

// En el widget de una página de registro (por ejemplo, Personalinfo)
ElevatedButton(
  onPressed: () {
    // ... validar el formulario
    widget.pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  },
  child: const Text('Continuar'),
);
```

Este enfoque permite una navegación fluida y controlada entre las diferentes etapas del proceso de registro.



