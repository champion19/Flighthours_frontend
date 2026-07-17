import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:dio/dio.dart';
import 'package:flight_hours_app/features/tail_number/data/datasources/tail_number_remote_data_source.dart';
import 'package:flight_hours_app/features/tail_number/domain/entities/tail_number_entity.dart';
import 'package:flight_hours_app/features/tail_number/domain/repositories/tail_number_repository.dart';

class TailNumberRepositoryImpl implements TailNumberRepository {
  final TailNumberRemoteDataSource remoteDataSource;

  TailNumberRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<TailNumberEntity>>> listTailNumbers() async {
    try {
      final result = await remoteDataSource.listTailNumbers();
      return Right(result);
    } on DioException catch (e) {
      debugPrint('❌ listTailNumbers error: ${e.message}');
      return Left(Failure(message: e.message ?? 'Server error'));
    } catch (e) {
      debugPrint('❌ listTailNumbers unexpected: $e');
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TailNumberEntity>> getTailNumberByPlate(
    String plate,
  ) async {
    try {
      final result = await remoteDataSource.getTailNumberByPlate(plate);
      return Right(result);
    } on DioException catch (e) {
      debugPrint('❌ getTailNumberByPlate error: ${e.message}');
      final msg =
          e.response?.data?['message']?.toString() ?? e.message ?? 'Not found';
      return Left(Failure(message: msg));
    } catch (e) {
      debugPrint('❌ getTailNumberByPlate unexpected: $e');
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TailNumberEntity>> createTailNumber({
    required String tailNumber,
    required String aircraftModelId,
    required String airlineId,
  }) async {
    try {
      final result = await remoteDataSource.createTailNumber(
        tailNumber: tailNumber,
        aircraftModelId: aircraftModelId,
        airlineId: airlineId,
      );
      return Right(result);
    } on DioException catch (e) {
      debugPrint('❌ createTailNumber error: ${e.message}');
      // 409 Conflict → tail number already exists (backend MAT_AGR_ERR_03403)
      if (e.response?.statusCode == 409) {
        return Left(
          Failure(
            message: 'Esa matrícula ya existe. Búscala de nuevo para usarla.',
          ),
        );
      }
      final msg =
          e.response?.data?['message']?.toString() ??
          e.message ??
          'No se pudo guardar la matrícula';
      return Left(Failure(message: msg));
    } catch (e) {
      debugPrint('❌ createTailNumber unexpected: $e');
      return Left(Failure(message: e.toString()));
    }
  }
}
