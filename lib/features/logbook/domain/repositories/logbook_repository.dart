import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';

/// Repository interface for Logbook operations
abstract class LogbookRepository {
  // ========== Daily Logbook (Header) Operations ==========

  Future<Either<Failure, List<DailyLogbookEntity>>> getDailyLogbooks();

  Future<Either<Failure, DailyLogbookEntity>> getDailyLogbookById(String id);

  Future<Either<Failure, DailyLogbookEntity>> createDailyLogbook({
    required DateTime logDate,
    required int bookPage,
  });

  Future<Either<Failure, bool>> deleteDailyLogbook(String id);

  /// Activate a daily logbook → PATCH /daily-logbooks/:id/activate
  Future<Either<Failure, bool>> activateDailyLogbook(String id);

  /// Deactivate a daily logbook → PATCH /daily-logbooks/:id/deactivate
  Future<Either<Failure, bool>> deactivateDailyLogbook(String id);

  // ========== Logbook Detail (Flight Segment) Operations ==========

  Future<Either<Failure, List<LogbookDetailEntity>>> getLogbookDetails(
    String dailyLogbookId,
  );

  Future<Either<Failure, LogbookDetailEntity>> getLogbookDetailById(String id);

  Future<Either<Failure, LogbookDetailEntity>> createLogbookDetail({
    required String dailyLogbookId,
    required String flightRealDate,
    required String flightNumber,
    required String airlineRouteId,
    required String licensePlateId,
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
  });

  Future<Either<Failure, LogbookDetailEntity>> updateLogbookDetail({
    required String id,
    required String flightRealDate,
    required String flightNumber,
    required String airlineRouteId,
    required String licensePlateId,
    int? passengers,
    String? outTime,
    String? takeoffTime,
    String? landingTime,
    String? inTime,
    String? pilotRole,
    String? crewRole,
    String? companionName,
    String? airTime,
    String? blockTime,
    String? dutyTime,
    String? approachType,
    String? flightType,
  });

  Future<Either<Failure, bool>> deleteLogbookDetail(String id);
}
