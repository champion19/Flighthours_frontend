import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/airline_route/data/datasources/airline_route_remote_data_source.dart';
import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';
import 'package:flight_hours_app/features/airline_route/domain/repositories/airline_route_repository.dart';

/// Implementation of AirlineRouteRepository using remote data source
class AirlineRouteRepositoryImpl implements AirlineRouteRepository {
  final AirlineRouteRemoteDataSource remoteDataSource;

  AirlineRouteRepositoryImpl({required this.remoteDataSource});

  Failure _handleError(dynamic e) {
    if (e is DioException && e.response != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        return Failure(
          message: data['message']?.toString() ?? 'Server error',
          code: data['code']?.toString(),
          statusCode: e.response!.statusCode,
        );
      }
      return Failure(
        message: 'Server error',
        statusCode: e.response!.statusCode,
      );
    }
    return Failure(message: 'Unexpected error occurred');
  }

  @override
  Future<Either<Failure, List<AirlineRouteEntity>>> getAirlineRoutes() async {
    try {
      return Right(await remoteDataSource.getAirlineRoutes());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, AirlineRouteEntity>> getAirlineRouteById(
    String id,
  ) async {
    try {
      final result = await remoteDataSource.getAirlineRouteById(id);
      if (result == null) {
        return Left(
          Failure(message: 'Airline route not found', statusCode: 404),
        );
      }
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }
}
