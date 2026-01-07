import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';

abstract class AirlineRepository {
  Future<List<AirlineEntity>> getAirlines();
  Future<AirlineEntity?> getAirlineById(String id);
  Future<AirlineStatusResponseModel> activateAirline(String id);
  Future<AirlineStatusResponseModel> deactivateAirline(String id);
}
