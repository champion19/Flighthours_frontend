import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/tail_number/domain/entities/tail_number_entity.dart';
import 'package:flight_hours_app/features/tail_number/domain/repositories/tail_number_repository.dart';

/// Use case to create a new tail number (aircraft registration)
class CreateTailNumberUseCase {
  final TailNumberRepository _repository;

  CreateTailNumberUseCase(this._repository);

  Future<Either<Failure, TailNumberEntity>> call({
    required String tailNumber,
    required String aircraftModelId,
    required String airlineId,
  }) {
    return _repository.createTailNumber(
      tailNumber: tailNumber,
      aircraftModelId: aircraftModelId,
      airlineId: airlineId,
    );
  }
}
