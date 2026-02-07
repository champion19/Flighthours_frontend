import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/repositories/aircraft_model_repository.dart';

class ListAircraftModelUseCase {
  final AircraftModelRepository repository;

  ListAircraftModelUseCase({required this.repository});

  Future<List<AircraftModelEntity>> call() async {
    return await repository.getAircraftModels();
  }
}
