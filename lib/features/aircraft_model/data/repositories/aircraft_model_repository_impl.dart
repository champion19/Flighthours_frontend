import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/aircraft_model/data/datasources/aircraft_model_remote_data_source.dart';
import 'package:flight_hours_app/features/aircraft_model/data/models/aircraft_model_status_response_model.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/repositories/aircraft_model_repository.dart';

class AircraftModelRepositoryImpl implements AircraftModelRepository {
  final AircraftModelRemoteDataSource remoteDataSource;

  AircraftModelRepositoryImpl({required this.remoteDataSource});

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
  Future<Either<Failure, List<AircraftModelEntity>>> getAircraftModels() async {
    try {
      return Right(await remoteDataSource.getAircraftModels());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, AircraftModelEntity>> getAircraftModelById(
    String id,
  ) async {
    try {
      return Right(await remoteDataSource.getAircraftModelById(id));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<AircraftModelEntity>>> getAircraftModelsByFamily(
    String family,
  ) async {
    try {
      return Right(await remoteDataSource.getAircraftModelsByFamily(family));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, AircraftModelStatusResponseModel>>
  activateAircraftModel(String id) async {
    try {
      return Right(await remoteDataSource.activateAircraftModel(id));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, AircraftModelStatusResponseModel>>
  deactivateAircraftModel(String id) async {
    try {
      return Right(await remoteDataSource.deactivateAircraftModel(id));
    } catch (e) {
      return Left(_handleError(e));
    }
  }
}
