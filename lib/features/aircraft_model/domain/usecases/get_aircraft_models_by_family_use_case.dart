import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/repositories/aircraft_model_repository.dart';

class GetAircraftModelsByFamilyUseCase {
  final AircraftModelRepository repository;
  GetAircraftModelsByFamilyUseCase({required this.repository});

  Future<Either<Failure, List<AircraftModelEntity>>> call(String family) async {
    return await repository.getAircraftModelsByFamily(family);
  }
}
