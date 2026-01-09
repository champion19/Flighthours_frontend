import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_model.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';

abstract class AirportRemoteDataSource {
  Future<List<AirportModel>> getAirports();
  Future<AirportModel?> getAirportById(String id);
  Future<AirportStatusResponseModel> activateAirport(String id);
  Future<AirportStatusResponseModel> deactivateAirport(String id);
}

/// Implementation of airport remote data source using Dio
///
/// Migrated from http package to Dio for:
/// - Automatic Bearer token injection via interceptor
/// - Automatic refresh token handling on 401 errors
/// - Better error handling and logging
/// - Automatic JSON parsing (Map instead of String)
class AirportRemoteDataSourceImpl implements AirportRemoteDataSource {
  final Dio _dio;

  AirportRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? DioClient().client;

  @override
  Future<List<AirportModel>> getAirports() async {
    try {
      final response = await _dio.get('/airports');
      // Dio already parses JSON to Map, use helper function for Map
      return _parseAirportListFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // Try to parse error response, return empty list on failure
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<AirportModel?> getAirportById(String id) async {
    try {
      final response = await _dio.get('/airports/$id');
      return _parseAirportFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // Not found or other error, return null
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<AirportStatusResponseModel> activateAirport(String id) async {
    try {
      final response = await _dio.patch('/airports/$id/activate');
      return AirportStatusResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return AirportStatusResponseModel.fromError(e.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<AirportStatusResponseModel> deactivateAirport(String id) async {
    try {
      final response = await _dio.patch('/airports/$id/deactivate');
      return AirportStatusResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return AirportStatusResponseModel.fromError(e.response!.data);
      }
      rethrow;
    }
  }

  /// Parses airport list from Map (Dio already decoded JSON)
  List<AirportModel> _parseAirportListFromMap(dynamic decoded) {
    // Expected format: {success: true, data: {airports: [...]}}
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is Map<String, dynamic> && data.containsKey('airports')) {
          final airports = data['airports'];
          if (airports is List) {
            return List<AirportModel>.from(
              airports.map(
                (x) => AirportModel.fromJson(x as Map<String, dynamic>),
              ),
            );
          }
        }
        // Fallback: data is directly an array
        if (data is List) {
          return List<AirportModel>.from(
            data.map((x) => AirportModel.fromJson(x as Map<String, dynamic>)),
          );
        }
      }
    }

    // Direct array response
    if (decoded is List) {
      return List<AirportModel>.from(
        decoded.map((x) => AirportModel.fromJson(x as Map<String, dynamic>)),
      );
    }

    return [];
  }

  /// Parses single airport from wrapped response Map
  AirportModel? _parseAirportFromMap(dynamic decoded) {
    // Handle wrapped response: {success: true, data: {airport: {...}}}
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is Map<String, dynamic>) {
          // Check for 'airport' key
          if (data.containsKey('airport')) {
            return AirportModel.fromJson(
              data['airport'] as Map<String, dynamic>,
            );
          }
          // Or data itself is the airport object
          return AirportModel.fromJson(data);
        }
      }
    }
    return null;
  }
}
