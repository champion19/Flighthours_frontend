import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/flight/domain/entities/flight_entity.dart';
import 'package:flight_hours_app/features/flight/domain/repositories/flight_repository.dart';

/// Use case: Update an existing flight record
class UpdateFlightUseCase {
  final FlightRepository _repository;

  UpdateFlightUseCase({required FlightRepository repository})
    : _repository = repository;

  Future<Either<Failure, FlightEntity>> call({
    required String id,
    required String flightRealDate,
    required String flightNumber,
    required String originAirportId,
    required String destinationAirportId,
    required String tailNumberId,
    int? passengers,
    String? outTime,
    String? takeoffTime,
    String? landingTime,
    String? inTime,
    String? pilotRole,
    String? airTime,
    String? blockTime,
    String? dutyTime,
    String? approachType,
    String? flightType,
  }) {
    return _repository.updateFlight(
      id: id,
      flightRealDate: flightRealDate,
      flightNumber: flightNumber,
      originAirportId: originAirportId,
      destinationAirportId: destinationAirportId,
      tailNumberId: tailNumberId,
      passengers: passengers,
      outTime: outTime,
      takeoffTime: takeoffTime,
      landingTime: landingTime,
      inTime: inTime,
      pilotRole: pilotRole,
      airTime: airTime,
      blockTime: blockTime,
      dutyTime: dutyTime,
      approachType: approachType,
      flightType: flightType,
    );
  }
}
