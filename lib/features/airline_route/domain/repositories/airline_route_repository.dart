import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';

/// Abstract repository for airline route operations
abstract class AirlineRouteRepository {
  /// Get all airline routes
  Future<List<AirlineRouteEntity>> getAirlineRoutes();

  /// Get a specific airline route by ID (supports obfuscated or UUID)
  Future<AirlineRouteEntity?> getAirlineRouteById(String id);
}
