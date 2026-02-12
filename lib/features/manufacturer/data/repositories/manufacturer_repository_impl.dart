import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/manufacturer/data/datasources/manufacturer_remote_data_source.dart';
import 'package:flight_hours_app/features/manufacturer/domain/entities/manufacturer_entity.dart';
import 'package:flight_hours_app/features/manufacturer/domain/repositories/manufacturer_repository.dart';

class ManufacturerRepositoryImpl implements ManufacturerRepository {
  final ManufacturerRemoteDataSource remoteDataSource;

  ManufacturerRepositoryImpl({required this.remoteDataSource});

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
  Future<Either<Failure, List<ManufacturerEntity>>> getManufacturers() async {
    try {
      return Right(await remoteDataSource.getManufacturers());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, ManufacturerEntity>> getManufacturerById(
    String id,
  ) async {
    try {
      final result = await remoteDataSource.getManufacturerById(id);
      if (result == null) {
        return Left(
          Failure(message: 'Manufacturer not found', statusCode: 404),
        );
      }
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }
}
