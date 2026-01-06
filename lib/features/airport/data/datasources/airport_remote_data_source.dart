import 'dart:convert';
import 'package:flight_hours_app/core/config/config.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_model.dart';
import 'package:flight_hours_app/features/airport/data/models/airport_status_response_model.dart';
import 'package:http/http.dart' as http;

abstract class AirportRemoteDataSource {
  Future<List<AirportModel>> getAirports();
  Future<AirportModel?> getAirportById(String id);
  Future<AirportStatusResponseModel> activateAirport(String id);
  Future<AirportStatusResponseModel> deactivateAirport(String id);
}

class AirportRemoteDataSourceImpl implements AirportRemoteDataSource {
  @override
  Future<List<AirportModel>> getAirports() async {
    final response = await http.get(
      Uri.parse("${Config.baseUrl}/airports"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return airportModelFromMap(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  @override
  Future<AirportModel?> getAirportById(String id) async {
    final response = await http.get(
      Uri.parse("${Config.baseUrl}/airports/$id"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
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
    } else {
      return null; // Return null if not found
    }
  }

  @override
  Future<AirportStatusResponseModel> activateAirport(String id) async {
    final response = await http.patch(
      Uri.parse("${Config.baseUrl}/airports/$id/activate"),
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return AirportStatusResponseModel.fromJson(decoded);
    } else {
      // Return error response model for 4xx errors
      return AirportStatusResponseModel.fromError(decoded);
    }
  }

  @override
  Future<AirportStatusResponseModel> deactivateAirport(String id) async {
    final response = await http.patch(
      Uri.parse("${Config.baseUrl}/airports/$id/deactivate"),
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return AirportStatusResponseModel.fromJson(decoded);
    } else {
      // Return error response model for 4xx errors
      return AirportStatusResponseModel.fromError(decoded);
    }
  }
}
