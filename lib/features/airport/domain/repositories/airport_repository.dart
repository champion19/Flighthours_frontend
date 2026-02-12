import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';

abstract class AirportRepository {
  Future<Either<Failure, List<AirportEntity>>> getAirports();
  Future<Either<Failure, AirportEntity>> getAirportById(String id);
  Future<Either<Failure, AirportStatusResponseModel>> activateAirport(
    String id,
  );
  Future<Either<Failure, AirportStatusResponseModel>> deactivateAirport(
    String id,
  );
}
