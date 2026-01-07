import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';
import 'package:flight_hours_app/features/airline/domain/repositories/airline_repository.dart';

class DeactivateAirlineUseCase {
  final AirlineRepository repository;

  DeactivateAirlineUseCase({required this.repository});

  Future<AirlineStatusResponseModel> call(String id) async {
    return await repository.deactivateAirline(id);
  }
}
