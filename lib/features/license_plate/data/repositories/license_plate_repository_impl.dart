import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/license_plate/data/datasources/license_plate_remote_data_source.dart';
import 'package:flight_hours_app/features/license_plate/domain/entities/license_plate_entity.dart';
import 'package:flight_hours_app/features/license_plate/domain/repositories/license_plate_repository.dart';

/// Implementation of [LicensePlateRepository]
class LicensePlateRepositoryImpl implements LicensePlateRepository {
  final LicensePlateRemoteDataSource _remoteDataSource;

  LicensePlateRepositoryImpl(this._remoteDataSource);

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
  Future<Either<Failure, List<LicensePlateEntity>>> listLicensePlates() async {
    try {
      return Right(await _remoteDataSource.listLicensePlates());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, LicensePlateEntity>> getLicensePlateByPlate(
    String plate,
  ) async {
    try {
      return Right(await _remoteDataSource.getLicensePlateByPlate(plate));
    } catch (e) {
      return Left(_handleError(e));
    }
  }
}
