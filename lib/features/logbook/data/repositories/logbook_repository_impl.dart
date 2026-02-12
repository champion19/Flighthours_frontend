import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/logbook/data/datasources/logbook_remote_data_source.dart';
import 'package:flight_hours_app/features/logbook/data/models/logbook_detail_model.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';

/// Implementation of LogbookRepository
class LogbookRepositoryImpl implements LogbookRepository {
  final LogbookRemoteDataSource _remoteDataSource;

  LogbookRepositoryImpl({required LogbookRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

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

  // ========== Daily Logbook Operations ==========

  @override
  Future<Either<Failure, List<DailyLogbookEntity>>> getDailyLogbooks() async {
    try {
      return Right(await _remoteDataSource.getDailyLogbooks());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, DailyLogbookEntity>> getDailyLogbookById(
    String id,
  ) async {
    try {
      final result = await _remoteDataSource.getDailyLogbookById(id);
      if (result == null) {
        return Left(
          Failure(message: 'Daily logbook not found', statusCode: 404),
        );
      }
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, DailyLogbookEntity>> createDailyLogbook({
    required DateTime logDate,
    required int bookPage,
  }) async {
    try {
      final result = await _remoteDataSource.createDailyLogbook(
        logDate: logDate,
        bookPage: bookPage,
      );
      if (result == null) {
        return Left(Failure(message: 'Failed to create daily logbook'));
      }
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, DailyLogbookEntity>> updateDailyLogbook({
    required String id,
    required DateTime logDate,
    required int bookPage,
    required bool status,
  }) async {
    try {
      final result = await _remoteDataSource.updateDailyLogbook(
        id: id,
        logDate: logDate,
        bookPage: bookPage,
        status: status,
      );
      if (result == null) {
        return Left(Failure(message: 'Failed to update daily logbook'));
      }
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteDailyLogbook(String id) async {
    try {
      return Right(await _remoteDataSource.deleteDailyLogbook(id));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  // ========== Logbook Detail Operations ==========

  @override
  Future<Either<Failure, List<LogbookDetailEntity>>> getLogbookDetails(
    String dailyLogbookId,
  ) async {
    try {
      return Right(await _remoteDataSource.getLogbookDetails(dailyLogbookId));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, LogbookDetailEntity>> getLogbookDetailById(
    String id,
  ) async {
    try {
      final result = await _remoteDataSource.getLogbookDetailById(id);
      if (result == null) {
        return Left(
          Failure(message: 'Logbook detail not found', statusCode: 404),
        );
      }
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, LogbookDetailEntity>> createLogbookDetail({
    required String dailyLogbookId,
    required String flightRealDate,
    required String flightNumber,
    required String airlineRouteId,
    required String actualAircraftRegistrationId,
    required int passengers,
    required String outTime,
    required String takeoffTime,
    required String landingTime,
    required String inTime,
    required String pilotRole,
    required String companionName,
    required String airTime,
    required String blockTime,
    required String dutyTime,
    required String approachType,
    required String flightType,
  }) async {
    try {
      final data = LogbookDetailModel.createRequest(
        flightRealDate: flightRealDate,
        flightNumber: flightNumber,
        airlineRouteId: airlineRouteId,
        actualAircraftRegistrationId: actualAircraftRegistrationId,
        passengers: passengers,
        outTime: outTime,
        takeoffTime: takeoffTime,
        landingTime: landingTime,
        inTime: inTime,
        pilotRole: pilotRole,
        companionName: companionName,
        airTime: airTime,
        blockTime: blockTime,
        dutyTime: dutyTime,
        approachType: approachType,
        flightType: flightType,
      );

      final result = await _remoteDataSource.createLogbookDetail(
        dailyLogbookId: dailyLogbookId,
        data: data,
      );
      if (result == null) {
        return Left(Failure(message: 'Failed to create logbook detail'));
      }
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, LogbookDetailEntity>> updateLogbookDetail({
    required String id,
    required String flightRealDate,
    required String flightNumber,
    required String airlineRouteId,
    required String actualAircraftRegistrationId,
    required int passengers,
    required String outTime,
    required String takeoffTime,
    required String landingTime,
    required String inTime,
    required String pilotRole,
    required String companionName,
    required String airTime,
    required String blockTime,
    required String dutyTime,
    required String approachType,
    required String flightType,
  }) async {
    try {
      final data = LogbookDetailModel.updateRequest(
        flightRealDate: flightRealDate,
        flightNumber: flightNumber,
        airlineRouteId: airlineRouteId,
        actualAircraftRegistrationId: actualAircraftRegistrationId,
        passengers: passengers,
        outTime: outTime,
        takeoffTime: takeoffTime,
        landingTime: landingTime,
        inTime: inTime,
        pilotRole: pilotRole,
        companionName: companionName,
        airTime: airTime,
        blockTime: blockTime,
        dutyTime: dutyTime,
        approachType: approachType,
        flightType: flightType,
      );

      final result = await _remoteDataSource.updateLogbookDetail(
        id: id,
        data: data,
      );
      if (result == null) {
        return Left(Failure(message: 'Failed to update logbook detail'));
      }
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteLogbookDetail(String id) async {
    try {
      return Right(await _remoteDataSource.deleteLogbookDetail(id));
    } catch (e) {
      return Left(_handleError(e));
    }
  }
}
