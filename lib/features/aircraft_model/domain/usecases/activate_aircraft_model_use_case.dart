import 'package:flight_hours_app/features/aircraft_model/data/models/aircraft_model_status_response_model.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/repositories/aircraft_model_repository.dart';

class ActivateAircraftModelUseCase {
  final AircraftModelRepository repository;

  ActivateAircraftModelUseCase({required this.repository});

  Future<AircraftModelStatusResponseModel> call(String id) async {
    return await repository.activateAircraftModel(id);
  }
}
