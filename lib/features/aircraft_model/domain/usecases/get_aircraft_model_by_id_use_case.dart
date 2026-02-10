import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/repositories/aircraft_model_repository.dart';

/// Use case to get an aircraft model by its ID
class GetAircraftModelByIdUseCase {
  final AircraftModelRepository _repository;

  GetAircraftModelByIdUseCase(this._repository);

  Future<AircraftModelEntity> call(String id) {
    return _repository.getAircraftModelById(id);
  }
}
