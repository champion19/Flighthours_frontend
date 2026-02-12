import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';

abstract class AirlineRepository {
  Future<Either<Failure, List<AirlineEntity>>> getAirlines();
  Future<Either<Failure, AirlineEntity>> getAirlineById(String id);
  Future<Either<Failure, AirlineStatusResponseModel>> activateAirline(
    String id,
  );
  Future<Either<Failure, AirlineStatusResponseModel>> deactivateAirline(
    String id,
  );
}
