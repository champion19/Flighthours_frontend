import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/manufacturer/data/models/manufacturer_model.dart';

abstract class ManufacturerRemoteDataSource {
  Future<List<ManufacturerModel>> getManufacturers();
  Future<ManufacturerModel?> getManufacturerById(String id);
}

class ManufacturerRemoteDataSourceImpl implements ManufacturerRemoteDataSource {
  final Dio _dio;

  ManufacturerRemoteDataSourceImpl({Dio? dio})
    : _dio = dio ?? DioClient().client;

  @override
  Future<List<ManufacturerModel>> getManufacturers() async {
    try {
      final response = await _dio.get('/manufacturers');
      return _parseManufacturerListFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<ManufacturerModel?> getManufacturerById(String id) async {
    try {
      final response = await _dio.get('/manufacturers/$id');
      return _parseManufacturerFromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return null;
      }
      rethrow;
    }
  }

  List<ManufacturerModel> _parseManufacturerListFromMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is Map<String, dynamic> && data.containsKey('manufacturers')) {
          final manufacturers = data['manufacturers'];
          if (manufacturers is List) {
            return List<ManufacturerModel>.from(
              manufacturers.map(
                (x) => ManufacturerModel.fromJson(x as Map<String, dynamic>),
              ),
            );
          }
        }
        if (data is List) {
          return List<ManufacturerModel>.from(
            data.map(
              (x) => ManufacturerModel.fromJson(x as Map<String, dynamic>),
            ),
          );
        }
      }
    }
    if (decoded is List) {
      return List<ManufacturerModel>.from(
        decoded.map(
          (x) => ManufacturerModel.fromJson(x as Map<String, dynamic>),
        ),
      );
    }
    return [];
  }

  ManufacturerModel? _parseManufacturerFromMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is Map<String, dynamic>) {
          if (data.containsKey('manufacturer')) {
            return ManufacturerModel.fromJson(
              data['manufacturer'] as Map<String, dynamic>,
            );
          }
          return ManufacturerModel.fromJson(data);
        }
      }
    }
    return null;
  }
}
