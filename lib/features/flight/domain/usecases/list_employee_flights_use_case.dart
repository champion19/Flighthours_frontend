import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/flight/domain/entities/flight_entity.dart';
import 'package:flight_hours_app/features/flight/domain/repositories/flight_repository.dart';

/// Use case: List all flights for the authenticated employee
class ListEmployeeFlightsUseCase {
  final FlightRepository _repository;

  ListEmployeeFlightsUseCase({required FlightRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<FlightEntity>>> call() {
    return _repository.getEmployeeFlights();
  }
}
