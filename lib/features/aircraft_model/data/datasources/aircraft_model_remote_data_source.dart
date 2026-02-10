import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/aircraft_model/data/models/aircraft_model_model.dart';
import 'package:flight_hours_app/features/aircraft_model/data/models/aircraft_model_status_response_model.dart';

abstract class AircraftModelRemoteDataSource {
  Future<List<AircraftModelModel>> getAircraftModels();
  Future<AircraftModelModel> getAircraftModelById(String id);
  Future<List<AircraftModelModel>> getAircraftModelsByFamily(String family);
  Future<AircraftModelStatusResponseModel> activateAircraftModel(String id);
  Future<AircraftModelStatusResponseModel> deactivateAircraftModel(String id);
}

/// Implementation of aircraft model remote data source using Dio
///
/// Uses Dio for:
/// - Automatic Bearer token injection via interceptor
/// - Automatic refresh token handling on 401 errors
/// - Better error handling and logging
/// - Automatic JSON parsing (Map instead of String)
class AircraftModelRemoteDataSourceImpl
    implements AircraftModelRemoteDataSource {
  final Dio _dio;

  AircraftModelRemoteDataSourceImpl({Dio? dio})
    : _dio = dio ?? DioClient().client;

  @override
  Future<List<AircraftModelModel>> getAircraftModels() async {
    try {
      final response = await _dio.get('/aircraft-models');
      return _parseAircraftModelListFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<AircraftModelModel> getAircraftModelById(String id) async {
    final response = await _dio.get('/aircraft-models/$id');
    final decoded = response.data;

    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data') &&
          decoded['data'] is Map<String, dynamic>) {
        return AircraftModelModel.fromJson(
          decoded['data'] as Map<String, dynamic>,
        );
      }
      return AircraftModelModel.fromJson(decoded);
    }

    throw Exception('Unexpected response format');
  }

  @override
  Future<List<AircraftModelModel>> getAircraftModelsByFamily(
    String family,
  ) async {
    try {
      final response = await _dio.get('/aircraft-families/$family');
      return _parseAircraftModelListFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<AircraftModelStatusResponseModel> activateAircraftModel(
    String id,
  ) async {
    try {
      final response = await _dio.patch('/aircraft-models/$id/activate');
      return AircraftModelStatusResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return AircraftModelStatusResponseModel.fromError(e.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<AircraftModelStatusResponseModel> deactivateAircraftModel(
    String id,
  ) async {
    try {
      final response = await _dio.patch('/aircraft-models/$id/deactivate');
      return AircraftModelStatusResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return AircraftModelStatusResponseModel.fromError(e.response!.data);
      }
      rethrow;
    }
  }

  /// Parses aircraft model list from Map (Dio already decoded JSON)
  ///
  /// Supports both camelCase and snake_case keys:
  /// - `aircraftModels` (frontend convention)
  /// - `aircraft_models` (backend Go JSON tags)
  List<AircraftModelModel> _parseAircraftModelListFromMap(dynamic decoded) {
    // Expected format: {success: true, data: {aircraft_models: [...], total: N}}
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is Map<String, dynamic>) {
          // Try snake_case first (backend format), then camelCase
          final models = data['aircraft_models'] ?? data['aircraftModels'];
          if (models is List) {
            return List<AircraftModelModel>.from(
              models.map(
                (x) => AircraftModelModel.fromJson(x as Map<String, dynamic>),
              ),
            );
          }
        }
        // Fallback: data is directly an array
        if (data is List) {
          return List<AircraftModelModel>.from(
            data.map(
              (x) => AircraftModelModel.fromJson(x as Map<String, dynamic>),
            ),
          );
        }
      }
    }

    // Direct array response
    if (decoded is List) {
      return List<AircraftModelModel>.from(
        decoded.map(
          (x) => AircraftModelModel.fromJson(x as Map<String, dynamic>),
        ),
      );
    }

    return [];
  }
}
