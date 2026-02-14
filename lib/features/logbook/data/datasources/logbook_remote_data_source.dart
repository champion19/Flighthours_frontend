import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/logbook/data/models/daily_logbook_model.dart';
import 'package:flight_hours_app/features/logbook/data/models/logbook_detail_model.dart';

/// Abstract class defining the logbook remote data source contract
abstract class LogbookRemoteDataSource {
  // ========== Daily Logbook Operations ==========

  /// Fetch all daily logbooks for the authenticated employee
  Future<List<DailyLogbookModel>> getDailyLogbooks();

  /// Fetch a specific daily logbook by ID
  Future<DailyLogbookModel?> getDailyLogbookById(String id);

  /// Create a new daily logbook
  Future<DailyLogbookModel?> createDailyLogbook({
    required DateTime logDate,
    required int bookPage,
  });

  /// Activate a daily logbook → PATCH /daily-logbooks/:id/activate
  Future<bool> activateDailyLogbook(String id);

  /// Deactivate a daily logbook → PATCH /daily-logbooks/:id/deactivate
  Future<bool> deactivateDailyLogbook(String id);

  /// Delete a daily logbook
  Future<bool> deleteDailyLogbook(String id);

  // ========== Logbook Detail Operations ==========

  /// Fetch all details for a specific daily logbook
  Future<List<LogbookDetailModel>> getLogbookDetails(String dailyLogbookId);

  /// Fetch a specific logbook detail by ID
  Future<LogbookDetailModel?> getLogbookDetailById(String id);

  /// Create a new logbook detail
  Future<LogbookDetailModel?> createLogbookDetail({
    required String dailyLogbookId,
    required Map<String, dynamic> data,
  });

  /// Update an existing logbook detail
  Future<LogbookDetailModel?> updateLogbookDetail({
    required String id,
    required Map<String, dynamic> data,
  });

  /// Delete a logbook detail
  Future<bool> deleteLogbookDetail(String id);
}

/// Implementation of LogbookRemoteDataSource using Dio
class LogbookRemoteDataSourceImpl implements LogbookRemoteDataSource {
  final Dio _dio;

  LogbookRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? DioClient().client;

  // ========== Daily Logbook Operations ==========

  @override
  Future<List<DailyLogbookModel>> getDailyLogbooks() async {
    try {
      print('[LogbookDataSource] Calling GET /daily-logbooks');
      final response = await _dio.get('/daily-logbooks');
      print('[LogbookDataSource] Response status: ${response.statusCode}');
      print(
        '[LogbookDataSource] Response data type: ${response.data.runtimeType}',
      );
      print('[LogbookDataSource] Response data: ${response.data}');
      final result = _parseLogbookListFromMap(response.data);
      print('[LogbookDataSource] Parsed ${result.length} logbooks');
      return result;
    } on DioException catch (e) {
      print('[LogbookDataSource] DioException: ${e.message}');
      print('[LogbookDataSource] Response: ${e.response?.data}');
      if (e.response != null) {
        // Return empty list on error
        return [];
      }
      rethrow;
    } catch (e) {
      print('[LogbookDataSource] Unexpected error: $e');
      return [];
    }
  }

  @override
  Future<DailyLogbookModel?> getDailyLogbookById(String id) async {
    try {
      final response = await _dio.get('/daily-logbooks/$id');
      return _parseLogbookFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<DailyLogbookModel?> createDailyLogbook({
    required DateTime logDate,
    required int bookPage,
  }) async {
    try {
      final response = await _dio.post(
        '/daily-logbooks',
        data: DailyLogbookModel.createRequest(
          logDate: logDate,
          bookPage: bookPage,
        ),
      );
      return _parseLogbookFromMap(response.data);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<bool> activateDailyLogbook(String id) async {
    try {
      await _dio.patch('/daily-logbooks/$id/activate');
      return true;
    } on DioException {
      return false;
    }
  }

  @override
  Future<bool> deactivateDailyLogbook(String id) async {
    try {
      await _dio.patch('/daily-logbooks/$id/deactivate');
      return true;
    } on DioException {
      return false;
    }
  }

  @override
  Future<bool> deleteDailyLogbook(String id) async {
    try {
      await _dio.delete('/daily-logbooks/$id');
      return true;
    } on DioException {
      return false;
    }
  }

  // ========== Logbook Detail Operations ==========

  @override
  Future<List<LogbookDetailModel>> getLogbookDetails(
    String dailyLogbookId,
  ) async {
    try {
      final response = await _dio.get(
        '/daily-logbooks/$dailyLogbookId/details',
      );
      return _parseDetailListFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<LogbookDetailModel?> getLogbookDetailById(String id) async {
    try {
      final response = await _dio.get('/daily-logbook-details/$id');
      return _parseDetailFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<LogbookDetailModel?> createLogbookDetail({
    required String dailyLogbookId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post(
        '/daily-logbooks/$dailyLogbookId/details',
        data: data,
      );
      return _parseDetailFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<LogbookDetailModel?> updateLogbookDetail({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.put('/daily-logbook-details/$id', data: data);
      return _parseDetailFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<bool> deleteLogbookDetail(String id) async {
    try {
      await _dio.delete('/daily-logbook-details/$id');
      return true;
    } on DioException {
      return false;
    }
  }

  // ========== Parsing Helpers ==========

  /// Parse logbook list from response
  /// Handles multiple formats:
  /// - { "daily_logbooks": [...] } (actual backend response)
  /// - { "data": { "daily_logbooks": [...] } }
  /// - { "data": [...] }
  /// - [...]
  List<DailyLogbookModel> _parseLogbookListFromMap(dynamic decoded) {
    print('[LogbookDataSource] Parsing response...');

    if (decoded is Map<String, dynamic>) {
      // Check for daily_logbooks directly in root (actual backend format)
      if (decoded.containsKey('daily_logbooks')) {
        final logbooks = decoded['daily_logbooks'];
        print(
          '[LogbookDataSource] Found daily_logbooks in root, type: ${logbooks.runtimeType}',
        );
        if (logbooks is List) {
          return List<DailyLogbookModel>.from(
            logbooks.map(
              (x) => DailyLogbookModel.fromJson(x as Map<String, dynamic>),
            ),
          );
        }
      }

      // Check in data key
      if (decoded.containsKey('data')) {
        final data = decoded['data'];

        // Check for nested key in data
        if (data is Map<String, dynamic> &&
            data.containsKey('daily_logbooks')) {
          final logbooks = data['daily_logbooks'];
          if (logbooks is List) {
            return List<DailyLogbookModel>.from(
              logbooks.map(
                (x) => DailyLogbookModel.fromJson(x as Map<String, dynamic>),
              ),
            );
          }
        }

        // Direct array in data
        if (data is List) {
          return List<DailyLogbookModel>.from(
            data.map(
              (x) => DailyLogbookModel.fromJson(x as Map<String, dynamic>),
            ),
          );
        }
      }
    }

    // Direct array response
    if (decoded is List) {
      return List<DailyLogbookModel>.from(
        decoded.map(
          (x) => DailyLogbookModel.fromJson(x as Map<String, dynamic>),
        ),
      );
    }

    print('[LogbookDataSource] Could not parse logbooks, returning empty list');
    return [];
  }

  /// Parse single logbook from response
  DailyLogbookModel? _parseLogbookFromMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is Map<String, dynamic>) {
          // Check for nested key
          if (data.containsKey('daily_logbook')) {
            return DailyLogbookModel.fromJson(
              data['daily_logbook'] as Map<String, dynamic>,
            );
          }
          // Data itself is the logbook
          return DailyLogbookModel.fromJson(data);
        }
      }
    }
    return null;
  }

  /// Parse detail list from response
  /// Expected: { "success": true, "data": [...] }
  List<LogbookDetailModel> _parseDetailListFromMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data')) {
        final data = decoded['data'];

        // Check for nested key
        if (data is Map<String, dynamic> && data.containsKey('details')) {
          final details = data['details'];
          if (details is List) {
            return List<LogbookDetailModel>.from(
              details.map(
                (x) => LogbookDetailModel.fromJson(x as Map<String, dynamic>),
              ),
            );
          }
        }

        // Direct array in data
        if (data is List) {
          return List<LogbookDetailModel>.from(
            data.map(
              (x) => LogbookDetailModel.fromJson(x as Map<String, dynamic>),
            ),
          );
        }
      }
    }

    // Direct array response
    if (decoded is List) {
      return List<LogbookDetailModel>.from(
        decoded.map(
          (x) => LogbookDetailModel.fromJson(x as Map<String, dynamic>),
        ),
      );
    }

    return [];
  }

  /// Parse single detail from response
  LogbookDetailModel? _parseDetailFromMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is Map<String, dynamic>) {
          // Check for nested key
          if (data.containsKey('detail')) {
            return LogbookDetailModel.fromJson(
              data['detail'] as Map<String, dynamic>,
            );
          }
          if (data.containsKey('daily_logbook_detail')) {
            return LogbookDetailModel.fromJson(
              data['daily_logbook_detail'] as Map<String, dynamic>,
            );
          }
          // Data itself is the detail
          return LogbookDetailModel.fromJson(data);
        }
      }
    }
    return null;
  }
}
