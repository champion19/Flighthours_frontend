import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_model.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';

abstract class AirlineRemoteDataSource {
  Future<List<AirlineModel>> getAirlines();
  Future<AirlineModel?> getAirlineById(String id);
  Future<AirlineStatusResponseModel> activateAirline(String id);
  Future<AirlineStatusResponseModel> deactivateAirline(String id);
}

/// Implementation of airline remote data source using Dio
///
/// Migrated from http package to Dio for:
/// - Automatic Bearer token injection via interceptor
/// - Automatic refresh token handling on 401 errors
/// - Better error handling and logging
/// - Automatic JSON parsing (Map instead of String)
class AirlineRemoteDataSourceImpl implements AirlineRemoteDataSource {
  final Dio _dio;

  AirlineRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? DioClient().client;

  @override
  Future<List<AirlineModel>> getAirlines() async {
    try {
      final response = await _dio.get('/airlines');
      // Dio already parses JSON to Map, use helper function for Map
      return _parseAirlineListFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // Try to parse error response, return empty list on failure
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<AirlineModel?> getAirlineById(String id) async {
    try {
      final response = await _dio.get('/airlines/$id');
      return _parseAirlineFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // Not found or other error, return null
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<AirlineStatusResponseModel> activateAirline(String id) async {
    try {
      final response = await _dio.patch('/airlines/$id/activate');
      return AirlineStatusResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return AirlineStatusResponseModel.fromError(e.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<AirlineStatusResponseModel> deactivateAirline(String id) async {
    try {
      final response = await _dio.patch('/airlines/$id/deactivate');
      return AirlineStatusResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return AirlineStatusResponseModel.fromError(e.response!.data);
      }
      rethrow;
    }
  }

  /// Parses airline list from Map (Dio already decoded JSON)
  List<AirlineModel> _parseAirlineListFromMap(dynamic decoded) {
    // Expected format: {success: true, data: {airlines: [...]}}
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is Map<String, dynamic> && data.containsKey('airlines')) {
          final airlines = data['airlines'];
          if (airlines is List) {
            return List<AirlineModel>.from(
              airlines.map(
                (x) => AirlineModel.fromJson(x as Map<String, dynamic>),
              ),
            );
          }
        }
        // Fallback: data is directly an array
        if (data is List) {
          return List<AirlineModel>.from(
            data.map((x) => AirlineModel.fromJson(x as Map<String, dynamic>)),
          );
        }
      }
    }

    // Direct array response
    if (decoded is List) {
      return List<AirlineModel>.from(
        decoded.map((x) => AirlineModel.fromJson(x as Map<String, dynamic>)),
      );
    }

    return [];
  }

  /// Parses single airline from wrapped response Map
  AirlineModel? _parseAirlineFromMap(dynamic decoded) {
    // Handle wrapped response: {success: true, data: {airline: {...}}}
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is Map<String, dynamic>) {
          // Check for 'airline' key
          if (data.containsKey('airline')) {
            return AirlineModel.fromJson(
              data['airline'] as Map<String, dynamic>,
            );
          }
          // Or data itself is the airline
          return AirlineModel.fromJson(data);
        }
      }
    }
    return null;
  }
}
