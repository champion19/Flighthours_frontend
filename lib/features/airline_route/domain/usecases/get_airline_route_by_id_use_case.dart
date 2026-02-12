import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';
import 'package:flight_hours_app/features/airline_route/domain/repositories/airline_route_repository.dart';

class GetAirlineRouteByIdUseCase {
  final AirlineRouteRepository repository;
  GetAirlineRouteByIdUseCase({required this.repository});

  Future<Either<Failure, AirlineRouteEntity>> call(String id) async {
    return await repository.getAirlineRouteById(id);
  }
}
