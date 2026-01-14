import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';
import 'package:flight_hours_app/features/airline_route/domain/repositories/airline_route_repository.dart';

/// Use case to get a specific airline route by ID
class GetAirlineRouteByIdUseCase {
  final AirlineRouteRepository repository;

  GetAirlineRouteByIdUseCase({required this.repository});

  Future<AirlineRouteEntity?> call(String id) async {
    return await repository.getAirlineRouteById(id);
  }
}
