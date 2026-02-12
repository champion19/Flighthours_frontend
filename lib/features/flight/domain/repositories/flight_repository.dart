import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/flight/domain/entities/flight_entity.dart';

/// Repository interface for Flight operations
abstract class FlightRepository {
  /// Fetch all flights for the authenticated employee
  Future<Either<Failure, List<FlightEntity>>> getEmployeeFlights();

  /// Fetch a specific flight by ID
  Future<Either<Failure, FlightEntity>> getFlightById(String id);

  /// Create a new flight (logbook detail)
  Future<Either<Failure, FlightEntity>> createFlight({
    required String dailyLogbookId,
    required String flightRealDate,
    required String flightNumber,
    required String airlineRouteId,
    required String licensePlateId,
    int? passengers,
    String? outTime,
    String? takeoffTime,
    String? landingTime,
    String? inTime,
    String? pilotRole,
    String? companionName,
    String? airTime,
    String? blockTime,
    String? dutyTime,
    String? approachType,
    String? flightType,
  });

  /// Update an existing flight
  Future<Either<Failure, FlightEntity>> updateFlight({
    required String id,
    required String flightRealDate,
    required String flightNumber,
    required String airlineRouteId,
    required String licensePlateId,
    int? passengers,
    String? outTime,
    String? takeoffTime,
    String? landingTime,
    String? inTime,
    String? pilotRole,
    String? companionName,
    String? airTime,
    String? blockTime,
    String? dutyTime,
    String? approachType,
    String? flightType,
  });

  /// Get the employee's daily logbook ID
  Future<Either<Failure, String>> getEmployeeLogbookId();
}
