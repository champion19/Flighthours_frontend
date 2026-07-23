import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';
import 'package:flight_hours_app/features/airline_route/domain/repositories/airline_route_repository.dart';

class ResolveAirlineRouteUseCase {
  final AirlineRouteRepository repository;
  ResolveAirlineRouteUseCase({required this.repository});

  Future<Either<Failure, AirlineRouteEntity>> call({
    required String originAirportId,
    required String destinationAirportId,
  }) async {
    return await repository.resolveAirlineRoute(
      originAirportId: originAirportId,
      destinationAirportId: destinationAirportId,
    );
  }
}
