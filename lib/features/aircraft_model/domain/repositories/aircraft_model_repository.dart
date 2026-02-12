import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/aircraft_model/data/models/aircraft_model_status_response_model.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';

abstract class AircraftModelRepository {
  Future<Either<Failure, List<AircraftModelEntity>>> getAircraftModels();
  Future<Either<Failure, AircraftModelEntity>> getAircraftModelById(String id);
  Future<Either<Failure, List<AircraftModelEntity>>> getAircraftModelsByFamily(
    String family,
  );
  Future<Either<Failure, AircraftModelStatusResponseModel>>
  activateAircraftModel(String id);
  Future<Either<Failure, AircraftModelStatusResponseModel>>
  deactivateAircraftModel(String id);
}
