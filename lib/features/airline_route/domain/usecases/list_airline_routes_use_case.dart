import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';
import 'package:flight_hours_app/features/airline_route/domain/repositories/airline_route_repository.dart';

/// Use case to list all airline routes
class ListAirlineRoutesUseCase {
  final AirlineRouteRepository repository;

  ListAirlineRoutesUseCase({required this.repository});

  Future<List<AirlineRouteEntity>> call() async {
    return await repository.getAirlineRoutes();
  }
}
