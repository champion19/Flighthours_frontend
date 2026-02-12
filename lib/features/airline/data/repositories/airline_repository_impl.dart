import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/airline/data/datasources/airline_remote_data_source.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';
import 'package:flight_hours_app/features/airline/domain/repositories/airline_repository.dart';

class AirlineRepositoryImpl implements AirlineRepository {
  final AirlineRemoteDataSource remoteDataSource;

  AirlineRepositoryImpl({required this.remoteDataSource});

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
  Future<Either<Failure, List<AirlineEntity>>> getAirlines() async {
    try {
      return Right(await remoteDataSource.getAirlines());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, AirlineEntity>> getAirlineById(String id) async {
    try {
      final result = await remoteDataSource.getAirlineById(id);
      if (result == null) {
        return Left(Failure(message: 'Airline not found', statusCode: 404));
      }
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, AirlineStatusResponseModel>> activateAirline(
    String id,
  ) async {
    try {
      return Right(await remoteDataSource.activateAirline(id));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, AirlineStatusResponseModel>> deactivateAirline(
    String id,
  ) async {
    try {
      return Right(await remoteDataSource.deactivateAirline(id));
    } catch (e) {
      return Left(_handleError(e));
    }
  }
}
