import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';

/// Abstract repository for route operations
abstract class RouteRepository {
  /// Get all available routes
  Future<List<RouteEntity>> getRoutes();

  /// Get a specific route by ID (supports obfuscated or UUID)
  Future<RouteEntity?> getRouteById(String id);
}
