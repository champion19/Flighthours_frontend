import 'dart:convert';
import 'package:flight_hours_app/core/config/config.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_model.dart';
import 'package:flight_hours_app/features/airline/data/models/airline_status_response_model.dart';
import 'package:http/http.dart' as http;

abstract class AirlineRemoteDataSource {
  Future<List<AirlineModel>> getAirlines();
  Future<AirlineModel?> getAirlineById(String id);
  Future<AirlineStatusResponseModel> activateAirline(String id);
  Future<AirlineStatusResponseModel> deactivateAirline(String id);
}

class AirlineRemoteDataSourceImpl implements AirlineRemoteDataSource {
  @override
  Future<List<AirlineModel>> getAirlines() async {
    final response = await http.get(
      Uri.parse("${Config.baseUrl}/airlines"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return airlineModelFromMap(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  @override
  Future<AirlineModel?> getAirlineById(String id) async {
    final response = await http.get(
      Uri.parse("${Config.baseUrl}/airlines/$id"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
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
    } else {
      return null; // Return null if not found
    }
  }

  @override
  Future<AirlineStatusResponseModel> activateAirline(String id) async {
    final response = await http.patch(
      Uri.parse("${Config.baseUrl}/airlines/$id/activate"),
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return AirlineStatusResponseModel.fromJson(decoded);
    } else {
      // Return error response model for 4xx errors
      return AirlineStatusResponseModel.fromError(decoded);
    }
  }

  @override
  Future<AirlineStatusResponseModel> deactivateAirline(String id) async {
    final response = await http.patch(
      Uri.parse("${Config.baseUrl}/airlines/$id/deactivate"),
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return AirlineStatusResponseModel.fromJson(decoded);
    } else {
      // Return error response model for 4xx errors
      return AirlineStatusResponseModel.fromError(decoded);
    }
  }
}
