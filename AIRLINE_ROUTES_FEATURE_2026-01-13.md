# Implementación Feature Airline Routes

**Fecha:** 2026-01-13
**Feature:** `airline_route`

## Resumen

Se implementó la funcionalidad completa de **Airline Routes** que permite listar y visualizar las rutas asociadas a aerolíneas. Cuando el usuario presiona el botón "View", se consultan los detalles de la ruta usando la feature `route` existente.

## Arquitectura

Se siguió la arquitectura **Clean Architecture** existente en el proyecto:

```
lib/features/airline_route/
├── data/
│   ├── datasources/
│   │   └── airline_route_remote_data_source.dart
│   ├── models/
│   │   └── airline_route_model.dart
│   └── repositories/
│       └── airline_route_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── airline_route_entity.dart
│   ├── repositories/
│   │   └── airline_route_repository.dart
│   └── usecases/
│       ├── get_airline_route_by_id_use_case.dart
│       └── list_airline_routes_use_case.dart
└── presentation/
    ├── bloc/
    │   ├── airline_route_bloc.dart
    │   ├── airline_route_event.dart
    │   └── airline_route_state.dart
    └── pages/
        └── airline_routes_page.dart
```

## Endpoints Utilizados

| Endpoint | Descripción |
|----------|-------------|
| `GET /airline-routes` | Lista todas las rutas de aerolíneas |
| `GET /airline-routes/:id` | Obtiene una ruta de aerolínea por ID |
| `GET /routes/:id` | Consulta los detalles de la ruta (feature route) |

## Modelo de Datos

### AirlineRouteEntity

```dart
class AirlineRouteEntity {
  final String id;           // ID ofuscado (para mostrar como AR-0125)
  final String? uuid;        // UUID real de la base de datos
  final String routeId;      // ID de la ruta asociada
  final String airlineId;    // ID de la aerolínea asociada
  final String? routeName;   // Nombre de la ruta (ej: "JFK → LAX")
  final String? airlineName; // Nombre de la aerolínea
  final String? originAirportCode;       // Código IATA origen
  final String? destinationAirportCode;  // Código IATA destino
  final String? status;      // "active", "inactive", "pending"
}
```

## UI Implementada

La interfaz sigue el diseño proporcionado:

1. **Header**: Título "Airline Routes" con botón de retroceso
2. **Botón "Add New Airline Route"**: Para crear nuevas rutas (placeholder)
3. **Barra de búsqueda**: Filtra por ID, ruta o nombre de aerolínea
4. **Cards de rutas**: Muestran:
   - Código AR (ej: AR-0125)
   - Ruta con códigos IATA (ej: JFK → LAX)
   - Nombre de la aerolínea
   - Badge de estado con colores:
     - ✅ Verde: Active
     - ⏳ Amarillo: Pending
     - ⚫ Gris: Inactive
   - Botones "View" y "Edit"

## Flujo del Botón "View"

Cuando el usuario presiona "View" en una tarjeta:

1. Se muestra un indicador de carga
2. Se llama a `GetRouteByIdUseCase` con el `routeId` de la airline route
3. Se obtienen los detalles completos de la ruta desde el backend
4. Se muestra un bottom sheet con:
   - Información del vuelo (origen → destino)
   - Nombres de aeropuertos
   - Países
   - Tipo de ruta (Nacional/Internacional)
   - Tiempo estimado de vuelo
   - Estado de la ruta de aerolínea

## Inyección de Dependencias

Se actualizó `lib/core/injector/injector.dart`:

```dart
// Airline Route
@Register.factory(ListAirlineRoutesUseCase)
@Register.factory(GetAirlineRouteByIdUseCase)
@Register.factory(AirlineRouteRepository, from: AirlineRouteRepositoryImpl)
@Register.factory(AirlineRouteRemoteDataSource, from: AirlineRouteRemoteDataSourceImpl)
```

Se regeneró `injector.g.dart` con:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Próximos Pasos (TODO)

- [ ] Implementar página "Add New Airline Route"
- [ ] Implementar página "Edit Airline Route"
- [ ] Agregar navegación desde el dashboard principal
- [ ] Implementar funcionalidad de cambio de estado (activate/deactivate)

## Archivos Modificados

| Archivo | Cambio |
|---------|--------|
| `lib/core/injector/injector.dart` | Agregados imports y registros de AirlineRoute |
| `lib/core/injector/injector.g.dart` | Regenerado automáticamente |

## Archivos Creados

| Archivo | Descripción |
|---------|-------------|
| `domain/entities/airline_route_entity.dart` | Entidad de dominio |
| `domain/repositories/airline_route_repository.dart` | Contrato del repositorio |
| `domain/usecases/list_airline_routes_use_case.dart` | Caso de uso para listar |
| `domain/usecases/get_airline_route_by_id_use_case.dart` | Caso de uso para obtener por ID |
| `data/models/airline_route_model.dart` | Modelo con serialización JSON |
| `data/datasources/airline_route_remote_data_source.dart` | DataSource remoto con Dio |
| `data/repositories/airline_route_repository_impl.dart` | Implementación del repositorio |
| `presentation/bloc/airline_route_event.dart` | Eventos del BLoC |
| `presentation/bloc/airline_route_state.dart` | Estados del BLoC |
| `presentation/bloc/airline_route_bloc.dart` | BLoC principal |
| `presentation/pages/airline_routes_page.dart` | Página principal |

## Testing

```bash
flutter analyze lib/features/airline_route/
# No issues found!
```

La feature compila sin errores y está lista para integrarse con el backend.
