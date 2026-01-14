import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/airline_route/data/models/airline_route_model.dart';

/// Abstract class defining the airline route remote data source contract
abstract class AirlineRouteRemoteDataSource {
  /// Fetch all airline routes from the API
  Future<List<AirlineRouteModel>> getAirlineRoutes();

  /// Fetch a specific airline route by ID (obfuscated or UUID)
  Future<AirlineRouteModel?> getAirlineRouteById(String id);
}

/// Implementation of AirlineRouteRemoteDataSource using Dio
///
/// Uses centralized DioClient for:
/// - Automatic Bearer token injection
/// - Automatic refresh token handling on 401 errors
/// - Better error handling and logging
class AirlineRouteRemoteDataSourceImpl implements AirlineRouteRemoteDataSource {
  final Dio _dio;

  AirlineRouteRemoteDataSourceImpl() : _dio = DioClient().client;

  @override
  Future<List<AirlineRouteModel>> getAirlineRoutes() async {
    try {
      final response = await _dio.get('/airline-routes');
      return _parseAirlineRouteListFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // Try to parse error response, return empty list on failure
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<AirlineRouteModel?> getAirlineRouteById(String id) async {
    try {
      final response = await _dio.get('/airline-routes/$id');
      return _parseAirlineRouteFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // Not found or other error, return null
        return null;
      }
      rethrow;
    }
  }

  /// Parses airline route list from Map (Dio already decoded JSON)
  ///
  /// Expected format:
  /// {
  ///   "success": true,
  ///   "data": {
  ///     "airline_routes": [...],
  ///     "total": 10
  ///   }
  /// }
  List<AirlineRouteModel> _parseAirlineRouteListFromMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is Map<String, dynamic> &&
            data.containsKey('airline_routes')) {
          final airlineRoutes = data['airline_routes'];
          if (airlineRoutes is List) {
            return List<AirlineRouteModel>.from(
              airlineRoutes.map(
                (x) => AirlineRouteModel.fromJson(x as Map<String, dynamic>),
              ),
            );
          }
        }
        // Fallback: data is directly an array
        if (data is List) {
          return List<AirlineRouteModel>.from(
            data.map(
              (x) => AirlineRouteModel.fromJson(x as Map<String, dynamic>),
            ),
          );
        }
      }
    }

    // Direct array response
    if (decoded is List) {
      return List<AirlineRouteModel>.from(
        decoded.map(
          (x) => AirlineRouteModel.fromJson(x as Map<String, dynamic>),
        ),
      );
    }

    return [];
  }

  /// Parses single airline route from wrapped response Map
  ///
  /// Expected format:
  /// {
  ///   "success": true,
  ///   "data": {
  ///     "airline_route": {...}
  ///   }
  /// }
  AirlineRouteModel? _parseAirlineRouteFromMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is Map<String, dynamic>) {
          // Check for 'airline_route' key
          if (data.containsKey('airline_route')) {
            return AirlineRouteModel.fromJson(
              data['airline_route'] as Map<String, dynamic>,
            );
          }
          // Or data itself is the airline route object
          return AirlineRouteModel.fromJson(data);
        }
      }
    }
    return null;
  }
}
