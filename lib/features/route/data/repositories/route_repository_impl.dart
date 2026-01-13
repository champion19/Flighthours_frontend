import 'package:flight_hours_app/features/route/data/datasources/route_remote_data_source.dart';
import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';
import 'package:flight_hours_app/features/route/domain/repositories/route_repository.dart';

/// Implementation of RouteRepository using remote data source
class RouteRepositoryImpl implements RouteRepository {
  final RouteRemoteDataSource remoteDataSource;

  RouteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<RouteEntity>> getRoutes() async {
    return await remoteDataSource.getRoutes();
  }

  @override
  Future<RouteEntity?> getRouteById(String id) async {
    return await remoteDataSource.getRouteById(id);
  }
}
