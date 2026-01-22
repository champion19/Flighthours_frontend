import 'package:flight_hours_app/features/logbook/data/datasources/logbook_remote_data_source.dart';
import 'package:flight_hours_app/features/logbook/data/models/logbook_detail_model.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';

/// Implementation of LogbookRepository
/// Bridges domain layer with data layer
class LogbookRepositoryImpl implements LogbookRepository {
  final LogbookRemoteDataSource _remoteDataSource;

  LogbookRepositoryImpl({required LogbookRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  // ========== Daily Logbook Operations ==========

  @override
  Future<List<DailyLogbookEntity>> getDailyLogbooks() async {
    return await _remoteDataSource.getDailyLogbooks();
  }

  @override
  Future<DailyLogbookEntity?> getDailyLogbookById(String id) async {
    return await _remoteDataSource.getDailyLogbookById(id);
  }

  @override
  Future<DailyLogbookEntity?> createDailyLogbook({
    required DateTime logDate,
    required int bookPage,
  }) async {
    return await _remoteDataSource.createDailyLogbook(
      logDate: logDate,
      bookPage: bookPage,
    );
  }

  @override
  Future<DailyLogbookEntity?> updateDailyLogbook({
    required String id,
    required DateTime logDate,
    required int bookPage,
    required bool status,
  }) async {
    return await _remoteDataSource.updateDailyLogbook(
      id: id,
      logDate: logDate,
      bookPage: bookPage,
      status: status,
    );
  }

  @override
  Future<bool> deleteDailyLogbook(String id) async {
    return await _remoteDataSource.deleteDailyLogbook(id);
  }

  // ========== Logbook Detail Operations ==========

  @override
  Future<List<LogbookDetailEntity>> getLogbookDetails(
    String dailyLogbookId,
  ) async {
    return await _remoteDataSource.getLogbookDetails(dailyLogbookId);
  }

  @override
  Future<LogbookDetailEntity?> getLogbookDetailById(String id) async {
    return await _remoteDataSource.getLogbookDetailById(id);
  }

  @override
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
  }) async {
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

    return await _remoteDataSource.createLogbookDetail(
      dailyLogbookId: dailyLogbookId,
      data: data,
    );
  }

  @override
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
  }) async {
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

    return await _remoteDataSource.updateLogbookDetail(id: id, data: data);
  }

  @override
  Future<bool> deleteLogbookDetail(String id) async {
    return await _remoteDataSource.deleteLogbookDetail(id);
  }
}
