import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/tail_number/data/models/tail_number_model.dart';

/// Abstract data source for Tail Number remote operations
abstract class TailNumberRemoteDataSource {
  Future<List<TailNumberModel>> listTailNumbers();
  Future<TailNumberModel> getTailNumberByPlate(String plate);
}

/// Implementation of [TailNumberRemoteDataSource] using Dio
class TailNumberRemoteDataSourceImpl implements TailNumberRemoteDataSource {
  final Dio _dio;

  TailNumberRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? DioClient().client;

  @override
  Future<List<TailNumberModel>> listTailNumbers() async {
    final response = await _dio.get('/tail-numbers');
    final decoded = response.data;

    // Backend returns: {registrations: [...], total: N, _links: [...]}
    if (decoded is Map<String, dynamic>) {
      final registrations = decoded['registrations'];
      if (registrations is List) {
        debugPrint('✅ listTailNumbers: Found ${registrations.length} plates');
        return registrations
            .map((x) => TailNumberModel.fromJson(x as Map<String, dynamic>))
            .toList();
      }
    }

    return [];
  }

  @override
  Future<TailNumberModel> getTailNumberByPlate(String plate) async {
    // GET /tail-numbers/:plate — searches by plate number
    final response = await _dio.get('/tail-numbers/$plate');
    final decoded = response.data;

    debugPrint('🔍 getTailNumberByPlate response: $decoded');

    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data') &&
          decoded['data'] is Map<String, dynamic>) {
        return TailNumberModel.fromJson(
          decoded['data'] as Map<String, dynamic>,
        );
      }
      return TailNumberModel.fromJson(decoded);
    }

    throw Exception('Unexpected response format');
  }
}
