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
    required String licensePlateId,
    int? passengers,
    String? outTime,
    String? takeoffTime,
    String? landingTime,
    String? inTime,
    String? pilotRole,
    String? crewRole,
    String? companionName,
    String? airTime,
    String? blockTime,
    String? dutyTime,
    String? approachType,
    String? flightType,
  }) async {
    return await _repository.updateLogbookDetail(
      id: id,
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
      crewRole: crewRole,
      companionName: companionName,
      airTime: airTime,
      blockTime: blockTime,
      dutyTime: dutyTime,
      approachType: approachType,
      flightType: flightType,
    );
  }
}
