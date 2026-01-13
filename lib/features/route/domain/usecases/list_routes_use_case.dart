import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';
import 'package:flight_hours_app/features/route/domain/repositories/route_repository.dart';

/// Use case to list all available flight routes
class ListRoutesUseCase {
  final RouteRepository repository;

  ListRoutesUseCase({required this.repository});

  Future<List<RouteEntity>> call() async {
    return await repository.getRoutes();
  }
}
