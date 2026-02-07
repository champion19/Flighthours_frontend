import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/repositories/aircraft_model_repository.dart';

/// Use case for fetching aircraft models by family
///
/// Calls GET /aircraft-families/:family endpoint
class GetAircraftModelsByFamilyUseCase {
  final AircraftModelRepository repository;

  GetAircraftModelsByFamilyUseCase({required this.repository});

  Future<List<AircraftModelEntity>> call(String family) async {
    return await repository.getAircraftModelsByFamily(family);
  }
}
