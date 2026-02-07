import 'package:flight_hours_app/features/aircraft_model/data/models/aircraft_model_status_response_model.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';

abstract class AircraftModelRepository {
  Future<List<AircraftModelEntity>> getAircraftModels();
  Future<List<AircraftModelEntity>> getAircraftModelsByFamily(String family);
  Future<AircraftModelStatusResponseModel> activateAircraftModel(String id);
  Future<AircraftModelStatusResponseModel> deactivateAircraftModel(String id);
}
