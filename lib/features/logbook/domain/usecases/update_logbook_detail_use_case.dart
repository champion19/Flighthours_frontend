import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';

/// Use case for updating an existing logbook detail (flight segment)
class UpdateLogbookDetailUseCase {
  final LogbookRepository _repository;

  UpdateLogbookDetailUseCase({required LogbookRepository repository})
    : _repository = repository;

  Future<Either<Failure, LogbookDetailEntity>> call({
    required String id,
    required String flightRealDate,
    required String flightNumber,
    required String airlineRouteId,
    required String actualAircraftRegistrationId,
    required int passengers,
    required String outTime,
    required String takeoffTime,
    required String landingTime,
    required String inTime,
    required String pilotRole,
    required String companionName,
    required String airTime,
    required String blockTime,
    required String dutyTime,
    required String approachType,
    required String flightType,
  }) async {
    return await _repository.updateLogbookDetail(
      id: id,
      flightRealDate: flightRealDate,
      flightNumber: flightNumber,
      airlineRouteId: airlineRouteId,
      actualAircraftRegistrationId: actualAircraftRegistrationId,
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
