import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/flight/data/models/flight_model.dart';

/// Abstract contract for flight remote data source
abstract class FlightRemoteDataSource {
  /// Fetch all flights for the authenticated employee
  /// GET /employees/flights
  Future<List<FlightModel>> getEmployeeFlights();

  /// Fetch a specific flight detail by ID
  /// GET /daily-logbook-details/:id
  Future<FlightModel?> getFlightById(String id);

  /// Create a new flight (logbook detail)
  /// POST /daily-logbooks/:logbookId/details
  Future<FlightModel?> createFlight({
    required String dailyLogbookId,
    required Map<String, dynamic> data,
  });

  /// Update an existing flight
  /// PUT /daily-logbook-details/:id
  Future<FlightModel?> updateFlight({
    required String id,
    required Map<String, dynamic> data,
  });

  /// Fetch the employee's daily logbooks to get the logbook ID
  /// GET /daily-logbooks
  Future<String?> getEmployeeLogbookId();
}

/// Implementation using Dio HTTP client
class FlightRemoteDataSourceImpl implements FlightRemoteDataSource {
  final Dio _dio;

  FlightRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? DioClient().client;

  // ========== Flight Operations ==========

  @override
  Future<List<FlightModel>> getEmployeeFlights() async {
    try {
      print('[FlightDataSource] Calling GET /employees/flights');
      final response = await _dio.get('/employees/flights');
      print('[FlightDataSource] Response status: ${response.statusCode}');
      return _parseFlightListFromMap(response.data);
    } on DioException catch (e) {
      print('[FlightDataSource] DioException: ${e.message}');
      if (e.response != null) return [];
      rethrow;
    } catch (e) {
      print('[FlightDataSource] Unexpected error: $e');
      return [];
    }
  }

  @override
  Future<FlightModel?> getFlightById(String id) async {
    try {
      final response = await _dio.get('/daily-logbook-details/$id');
      return _parseFlightFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) return null;
      rethrow;
    }
  }

  @override
  Future<FlightModel?> createFlight({
    required String dailyLogbookId,
    required Map<String, dynamic> data,
  }) async {
    try {
      print('[FlightDataSource] POST /daily-logbooks/$dailyLogbookId/details');
      print('[FlightDataSource] Payload: $data');
      final response = await _dio.post(
        '/daily-logbooks/$dailyLogbookId/details',
        data: data,
      );
      print('[FlightDataSource] Response status: ${response.statusCode}');
      print('[FlightDataSource] Response data: ${response.data}');
      return _parseFlightFromMap(response.data);
    } on DioException catch (e) {
      print('[FlightDataSource] Create DioError: ${e.response?.statusCode}');
      print('[FlightDataSource] Create error body: ${e.response?.data}');
      // Rethrow so the BLoC can report the actual error
      rethrow;
    } catch (e) {
      print('[FlightDataSource] Unexpected create error: $e');
      rethrow;
    }
  }

  @override
  Future<FlightModel?> updateFlight({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.put('/daily-logbook-details/$id', data: data);
      return _parseFlightFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) return null;
      rethrow;
    }
  }

  @override
  Future<String?> getEmployeeLogbookId() async {
    try {
      print('[FlightDataSource] Calling GET /daily-logbooks');
      final response = await _dio.get('/daily-logbooks');
      final logbooks = _parseLogbookList(response.data);
      if (logbooks.isNotEmpty) {
        return logbooks.first['id']?.toString();
      }
      return null;
    } on DioException catch (e) {
      print('[FlightDataSource] DioException getting logbook: ${e.message}');
      if (e.response != null) return null;
      rethrow;
    }
  }

  // ========== Parsing Helpers ==========

  /// Parse flight list from various response formats
  List<FlightModel> _parseFlightListFromMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      // { "data": [...] } or { "data": { "flights": [...] } }
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is List) {
          return data
              .map((x) => FlightModel.fromJson(x as Map<String, dynamic>))
              .toList();
        }
        if (data is Map<String, dynamic>) {
          // Check nested keys
          for (final key in ['flights', 'details', 'daily_logbook_details']) {
            if (data.containsKey(key) && data[key] is List) {
              return (data[key] as List)
                  .map((x) => FlightModel.fromJson(x as Map<String, dynamic>))
                  .toList();
            }
          }
        }
      }
      // { "flights": [...] } at root
      for (final key in ['flights', 'details', 'daily_logbook_details']) {
        if (decoded.containsKey(key) && decoded[key] is List) {
          return (decoded[key] as List)
              .map((x) => FlightModel.fromJson(x as Map<String, dynamic>))
              .toList();
        }
      }
    }
    if (decoded is List) {
      return decoded
          .map((x) => FlightModel.fromJson(x as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Parse single flight from response
  FlightModel? _parseFlightFromMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is Map<String, dynamic>) {
          // Check nested keys
          for (final key in ['detail', 'daily_logbook_detail', 'flight']) {
            if (data.containsKey(key) && data[key] is Map<String, dynamic>) {
              return FlightModel.fromJson(data[key] as Map<String, dynamic>);
            }
          }
          // Data itself is the flight
          return FlightModel.fromJson(data);
        }
      }
    }
    return null;
  }

  /// Parse logbook list to extract IDs
  List<Map<String, dynamic>> _parseLogbookList(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('daily_logbooks') &&
          decoded['daily_logbooks'] is List) {
        return List<Map<String, dynamic>>.from(decoded['daily_logbooks']);
      }
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
        if (data is Map<String, dynamic> &&
            data.containsKey('daily_logbooks')) {
          return List<Map<String, dynamic>>.from(data['daily_logbooks']);
        }
      }
    }
    if (decoded is List) {
      return List<Map<String, dynamic>>.from(decoded);
    }
    return [];
  }
}
