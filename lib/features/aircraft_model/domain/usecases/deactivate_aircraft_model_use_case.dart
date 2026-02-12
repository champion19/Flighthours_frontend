import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/aircraft_model/data/models/aircraft_model_status_response_model.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/repositories/aircraft_model_repository.dart';

class DeactivateAircraftModelUseCase {
  final AircraftModelRepository repository;
  DeactivateAircraftModelUseCase({required this.repository});

  Future<Either<Failure, AircraftModelStatusResponseModel>> call(
    String id,
  ) async {
    return await repository.deactivateAircraftModel(id);
  }
}
