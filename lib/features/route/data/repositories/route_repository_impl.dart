import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/route/data/datasources/route_remote_data_source.dart';
import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';
import 'package:flight_hours_app/features/route/domain/repositories/route_repository.dart';

/// Implementation of RouteRepository using remote data source
class RouteRepositoryImpl implements RouteRepository {
  final RouteRemoteDataSource remoteDataSource;

  RouteRepositoryImpl({required this.remoteDataSource});

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
  Future<Either<Failure, List<RouteEntity>>> getRoutes() async {
    try {
      return Right(await remoteDataSource.getRoutes());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, RouteEntity>> getRouteById(String id) async {
    try {
      final result = await remoteDataSource.getRouteById(id);
      if (result == null) {
        return Left(Failure(message: 'Route not found', statusCode: 404));
      }
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }
}
