import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';
import 'package:flight_hours_app/features/route/domain/repositories/route_repository.dart';

/// Use case to get a specific route by ID
class GetRouteByIdUseCase {
  final RouteRepository repository;

  GetRouteByIdUseCase({required this.repository});

  Future<RouteEntity?> call(String id) async {
    return await repository.getRouteById(id);
  }
}
