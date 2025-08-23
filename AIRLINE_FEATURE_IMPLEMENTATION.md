# Implementación de la Característica de Aerolíneas

Este documento resume la implementación de la característica de aerolíneas en la aplicación.

## 1. Estructura de Directorios

Se creó la siguiente estructura de directorios para la característica de aerolíneas:

```
lib/features/airline/
├── data/
│   ├── datasources/
│   │   └── airline_remote_data_source.dart
│   ├── models/
│   │   └── airline_model.dart
│   └── repositories/
│       └── airline_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── airline_entity.dart
│   ├── repositories/
│   │   └── airline_repository.dart
│   └── usecases/
│       └── list_airline_use_case.dart
└── presentation/
    ├── bloc/
    │   ├── airline_bloc.dart
    │   ├── airline_event.dart
    │   └── airline_state.dart
    ├── pages/
    │   └── airline_list_page.dart
    └── widgets/
```

## 2. Capa de Datos

### `airline_remote_data_source.dart`

- Se creó una implementación de `AirlineRemoteDataSource` que simula la obtención de datos de una API.

### `airline_model.dart`

- Se creó el modelo `AirlineModel` que extiende de `AirlineEntity` y agrega la lógica de serialización/deserialización de JSON.

### `airline_repository_impl.dart`

- Se creó la implementación de `AirlineRepository` que utiliza `AirlineRemoteDataSource` para obtener los datos.

## 3. Capa de Dominio

### `airline_entity.dart`

- Se creó la entidad `AirlineEntity` que representa una aerolínea.

### `airline_repository.dart`

- Se creó la abstracción del repositorio `AirlineRepository`.

### `list_airline_use_case.dart`

- Se creó el caso de uso `ListAirlineUseCase` que obtiene la lista de aerolíneas del repositorio.

## 4. Capa de Presentación

### BLoC

- **`airline_bloc.dart`**: Contiene la lógica de negocio para obtener la lista de aerolíneas.
- **`airline_event.dart`**: Define los eventos que pueden ser enviados al `AirlineBloc`.
- **`airline_state.dart`**: Define los estados que puede tener el `AirlineBloc`.

### `airline_list_page.dart`

- Se creó una página que muestra la lista de aerolíneas obtenidas del `AirlineBloc`.

## 5. Inyección de Dependencias

- Se registraron las dependencias de la característica de aerolíneas en el inyector de dependencias (`lib/core/injector/injector.dart`).

## 6. Navegación

- Se agregó una ruta para `AirlineListPage` en `lib/main.dart`.
- Se agregó el `BlocProvider` para `AirlineBloc` en `lib/main.dart`.

## 7. Integración con el Flujo de Registro

- Se actualizó la página `pilot_info_page.dart` para utilizar el `AirlineBloc`.
- Se agregó un `DropdownButtonFormField` a la página de información del piloto para permitir la selección de una aerolínea.
- El `DropdownButtonFormField` se puebla con los datos obtenidos del `AirlineBloc`.
- La aerolínea seleccionada se guarda en el estado del `RegisterBloc` cuando el usuario continúa con el flujo de registro.