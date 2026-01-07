import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';
import 'package:flight_hours_app/features/airline/domain/repositories/airline_repository.dart';

class ActivateAirlineUseCase {
  final AirlineRepository repository;

  ActivateAirlineUseCase({required this.repository});

  Future<AirlineStatusResponseModel> call(String id) async {
    return await repository.activateAirline(id);
  }
}
