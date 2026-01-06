import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';

abstract class AirlineRepository {
  Future<List<AirlineEntity>> getAirlines();
  Future<AirlineEntity?> getAirlineById(String id);
}
