import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';

abstract class AirportRepository {
  Future<List<AirportEntity>> getAirports();
  Future<AirportEntity?> getAirportById(String id);
  Future<AirportStatusResponseModel> activateAirport(String id);
  Future<AirportStatusResponseModel> deactivateAirport(String id);
}
