import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/flight/domain/entities/flight_entity.dart';
import 'package:flight_hours_app/features/flight/domain/repositories/flight_repository.dart';

/// Use case: Get a flight by its ID
class GetFlightByIdUseCase {
  final FlightRepository _repository;

  GetFlightByIdUseCase({required FlightRepository repository})
    : _repository = repository;

  Future<Either<Failure, FlightEntity>> call(String id) {
    return _repository.getFlightById(id);
  }
}
