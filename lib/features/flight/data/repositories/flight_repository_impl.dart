import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/flight/data/datasources/flight_remote_data_source.dart';
import 'package:flight_hours_app/features/flight/data/models/flight_model.dart';
import 'package:flight_hours_app/features/flight/domain/entities/flight_entity.dart';
import 'package:flight_hours_app/features/flight/domain/repositories/flight_repository.dart';

/// Implementation of FlightRepository
class FlightRepositoryImpl implements FlightRepository {
  final FlightRemoteDataSource _remoteDataSource;

  FlightRepositoryImpl({required FlightRemoteDataSource remoteDataSource})
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

  @override
  Future<Either<Failure, List<FlightEntity>>> getEmployeeFlights() async {
    try {
      final result = await _remoteDataSource.getEmployeeFlights();
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, FlightEntity>> getFlightById(String id) async {
    try {
      final result = await _remoteDataSource.getFlightById(id);
      if (result == null) {
        return Left(Failure(message: 'Flight not found', statusCode: 404));
      }
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, FlightEntity>> createFlight({
    required String dailyLogbookId,
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
    String? companionName,
    String? airTime,
    String? blockTime,
    String? dutyTime,
    String? approachType,
    String? flightType,
  }) async {
    try {
      final data = FlightModel.createRequest(
        flightRealDate: flightRealDate,
        flightNumber: flightNumber,
        airlineRouteId: airlineRouteId,
        licensePlateId: licensePlateId,
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

      final result = await _remoteDataSource.createFlight(
        dailyLogbookId: dailyLogbookId,
        data: data,
      );
      if (result == null) {
        return Left(Failure(message: 'Failed to create flight'));
      }
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, FlightEntity>> updateFlight({
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
    String? companionName,
    String? airTime,
    String? blockTime,
    String? dutyTime,
    String? approachType,
    String? flightType,
  }) async {
    try {
      final data = FlightModel.updateRequest(
        flightRealDate: flightRealDate,
        flightNumber: flightNumber,
        airlineRouteId: airlineRouteId,
        licensePlateId: licensePlateId,
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

      final result = await _remoteDataSource.updateFlight(id: id, data: data);
      if (result == null) {
        return Left(Failure(message: 'Failed to update flight'));
      }
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, String>> getEmployeeLogbookId() async {
    try {
      final result = await _remoteDataSource.getEmployeeLogbookId();
      if (result == null) {
        return Left(Failure(message: 'No logbook found for employee'));
      }
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }
}
