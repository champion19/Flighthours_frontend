import 'package:flight_hours_app/features/airline_route/data/datasources/airline_route_remote_data_source.dart';
import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';
import 'package:flight_hours_app/features/airline_route/domain/repositories/airline_route_repository.dart';

/// Implementation of AirlineRouteRepository using remote data source
class AirlineRouteRepositoryImpl implements AirlineRouteRepository {
  final AirlineRouteRemoteDataSource remoteDataSource;

  AirlineRouteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AirlineRouteEntity>> getAirlineRoutes() async {
    return await remoteDataSource.getAirlineRoutes();
  }

  @override
  Future<AirlineRouteEntity?> getAirlineRouteById(String id) async {
    return await remoteDataSource.getAirlineRouteById(id);
  }
}
