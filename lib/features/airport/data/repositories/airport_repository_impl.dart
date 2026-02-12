import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/airport/data/datasources/airport_remote_data_source.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';
import 'package:flight_hours_app/features/airport/domain/repositories/airport_repository.dart';

class AirportRepositoryImpl implements AirportRepository {
  final AirportRemoteDataSource remoteDataSource;

  AirportRepositoryImpl({required this.remoteDataSource});

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
  Future<Either<Failure, List<AirportEntity>>> getAirports() async {
    try {
      return Right(await remoteDataSource.getAirports());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, AirportEntity>> getAirportById(String id) async {
    try {
      final result = await remoteDataSource.getAirportById(id);
      if (result == null) {
        return Left(Failure(message: 'Airport not found', statusCode: 404));
      }
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, AirportStatusResponseModel>> activateAirport(
    String id,
  ) async {
    try {
      return Right(await remoteDataSource.activateAirport(id));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, AirportStatusResponseModel>> deactivateAirport(
    String id,
  ) async {
    try {
      return Right(await remoteDataSource.deactivateAirport(id));
    } catch (e) {
      return Left(_handleError(e));
    }
  }
}
