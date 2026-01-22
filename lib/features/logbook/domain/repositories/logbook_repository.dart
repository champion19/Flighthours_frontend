import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';

/// Repository interface for Logbook operations
/// Defines the contract between domain and data layers
abstract class LogbookRepository {
  // ========== Daily Logbook (Header) Operations ==========

  /// Fetch all daily logbooks for the authenticated employee
  Future<List<DailyLogbookEntity>> getDailyLogbooks();

  /// Fetch a specific daily logbook by ID
  Future<DailyLogbookEntity?> getDailyLogbookById(String id);

  /// Create a new daily logbook
  Future<DailyLogbookEntity?> createDailyLogbook({
    required DateTime logDate,
    required int bookPage,
  });

  /// Update an existing daily logbook
  Future<DailyLogbookEntity?> updateDailyLogbook({
    required String id,
    required DateTime logDate,
    required int bookPage,
    required bool status,
  });

  /// Delete a daily logbook
  Future<bool> deleteDailyLogbook(String id);

  // ========== Logbook Detail (Flight Segment) Operations ==========

  /// Fetch all details for a specific daily logbook
  Future<List<LogbookDetailEntity>> getLogbookDetails(String dailyLogbookId);

  /// Fetch a specific logbook detail by ID
  Future<LogbookDetailEntity?> getLogbookDetailById(String id);

  /// Create a new logbook detail (flight segment)
  Future<LogbookDetailEntity?> createLogbookDetail({
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
  });

  /// Update an existing logbook detail
  Future<LogbookDetailEntity?> updateLogbookDetail({
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
  });

  /// Delete a logbook detail
  Future<bool> deleteLogbookDetail(String id);
}
