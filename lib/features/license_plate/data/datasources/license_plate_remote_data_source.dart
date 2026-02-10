import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/license_plate/data/models/license_plate_model.dart';

/// Abstract data source for License Plate remote operations
abstract class LicensePlateRemoteDataSource {
  Future<List<LicensePlateModel>> listLicensePlates();
  Future<LicensePlateModel> getLicensePlateByPlate(String plate);
}

/// Implementation of [LicensePlateRemoteDataSource] using Dio
class LicensePlateRemoteDataSourceImpl implements LicensePlateRemoteDataSource {
  final Dio _dio;

  LicensePlateRemoteDataSourceImpl({Dio? dio})
    : _dio = dio ?? DioClient().client;

  @override
  Future<List<LicensePlateModel>> listLicensePlates() async {
    final response = await _dio.get('/license-plates');
    final decoded = response.data;

    // Backend returns: {registrations: [...], total: N, _links: [...]}
    if (decoded is Map<String, dynamic>) {
      final registrations = decoded['registrations'];
      if (registrations is List) {
        debugPrint('✅ listLicensePlates: Found ${registrations.length} plates');
        return registrations
            .map((x) => LicensePlateModel.fromJson(x as Map<String, dynamic>))
            .toList();
      }
    }

    return [];
  }

  @override
  Future<LicensePlateModel> getLicensePlateByPlate(String plate) async {
    // GET /license-plates/:plate — searches by plate number
    final response = await _dio.get('/license-plates/$plate');
    final decoded = response.data;

    debugPrint('🔍 getLicensePlateByPlate response: $decoded');

    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data') &&
          decoded['data'] is Map<String, dynamic>) {
        return LicensePlateModel.fromJson(
          decoded['data'] as Map<String, dynamic>,
        );
      }
      return LicensePlateModel.fromJson(decoded);
    }

    throw Exception('Unexpected response format');
  }
}
