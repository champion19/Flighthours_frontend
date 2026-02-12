import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/flight/domain/entities/flight_entity.dart';
import 'package:flight_hours_app/features/flight/domain/repositories/flight_repository.dart';

/// Use case: Create a new flight record
class CreateFlightUseCase {
  final FlightRepository _repository;

  CreateFlightUseCase({required FlightRepository repository})
    : _repository = repository;

  Future<Either<Failure, FlightEntity>> call({
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
  }) {
    return _repository.createFlight(
      dailyLogbookId: dailyLogbookId,
      flightRealDate: flightRealDate,
      flightNumber: flightNumber,
      airlineRouteId: airlineRouteId,
      licensePlateId: licensePlateId,
      passengers: passengers,
      outTime: outTime,
      takeoffTime: takeoffTime,
      landingTime: landingTime,
      inTime: inTime,
      pilotRole: pilotRole,
      companionName: companionName,
      airTime: airTime,
      blockTime: blockTime,
      dutyTime: dutyTime,
      approachType: approachType,
      flightType: flightType,
    );
  }
}
