import 'package:flight_hours_app/core/config/config.dart';

import 'package:flight_hours_app/features/airline/data/models/airline_model.dart';
import 'package:http/http.dart' as http;

abstract class AirlineRemoteDataSource {
  Future<List<AirlineModel>> getAirlines();
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
}
