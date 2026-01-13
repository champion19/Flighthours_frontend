import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/route/data/models/route_model.dart';

/// Abstract class defining the route remote data source contract
abstract class RouteRemoteDataSource {
  /// Fetch all routes from the API
  Future<List<RouteModel>> getRoutes();

  /// Fetch a specific route by ID (obfuscated or UUID)
  Future<RouteModel?> getRouteById(String id);
}

/// Implementation of RouteRemoteDataSource using Dio
///
/// Uses centralized DioClient for:
/// - Automatic Bearer token injection
/// - Automatic refresh token handling on 401 errors
/// - Better error handling and logging
class RouteRemoteDataSourceImpl implements RouteRemoteDataSource {
  final Dio _dio;

  RouteRemoteDataSourceImpl() : _dio = DioClient().client;

  @override
  Future<List<RouteModel>> getRoutes() async {
    try {
      final response = await _dio.get('/routes');
      return _parseRouteListFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // Try to parse error response, return empty list on failure
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<RouteModel?> getRouteById(String id) async {
    try {
      final response = await _dio.get('/routes/$id');
      return _parseRouteFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // Not found or other error, return null
        return null;
      }
      rethrow;
    }
  }

  /// Parses route list from Map (Dio already decoded JSON)
  ///
  /// Expected format:
  /// {
  ///   "success": true,
  ///   "data": {
  ///     "routes": [...],
  ///     "total": 10
  ///   }
  /// }
  List<RouteModel> _parseRouteListFromMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is Map<String, dynamic> && data.containsKey('routes')) {
          final routes = data['routes'];
          if (routes is List) {
            return List<RouteModel>.from(
              routes.map((x) => RouteModel.fromJson(x as Map<String, dynamic>)),
            );
          }
        }
        // Fallback: data is directly an array
        if (data is List) {
          return List<RouteModel>.from(
            data.map((x) => RouteModel.fromJson(x as Map<String, dynamic>)),
          );
        }
      }
    }

    // Direct array response
    if (decoded is List) {
      return List<RouteModel>.from(
        decoded.map((x) => RouteModel.fromJson(x as Map<String, dynamic>)),
      );
    }

    return [];
  }

  /// Parses single route from wrapped response Map
  ///
  /// Expected format:
  /// {
  ///   "success": true,
  ///   "data": {
  ///     "route": {...}
  ///   }
  /// }
  RouteModel? _parseRouteFromMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is Map<String, dynamic>) {
          // Check for 'route' key
          if (data.containsKey('route')) {
            return RouteModel.fromJson(data['route'] as Map<String, dynamic>);
          }
          // Or data itself is the route object
          return RouteModel.fromJson(data);
        }
      }
    }
    return null;
  }
}
