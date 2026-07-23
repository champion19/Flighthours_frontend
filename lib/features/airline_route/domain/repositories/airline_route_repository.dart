import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';

/// Abstract repository for airline route operations
abstract class AirlineRouteRepository {
  /// Get all airline routes
  Future<Either<Failure, List<AirlineRouteEntity>>> getAirlineRoutes();

  /// Get a specific airline route by ID (supports obfuscated or UUID)
  Future<Either<Failure, AirlineRouteEntity>> getAirlineRouteById(String id);

  /// Resolves (or auto-requests as pending) the authenticated employee's
  /// airline link for an origin/destination airport pair.
  Future<Either<Failure, AirlineRouteEntity>> resolveAirlineRoute({
    required String originAirportId,
    required String destinationAirportId,
  });
}
