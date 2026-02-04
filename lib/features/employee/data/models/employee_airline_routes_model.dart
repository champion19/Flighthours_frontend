import 'package:flight_hours_app/features/airline_route/data/models/airline_route_model.dart';
import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';

/// Response model for GET /employees/airline-routes endpoint
class EmployeeAirlineRoutesResponseModel {
  final bool success;
  final String code;
  final String message;
  final List<AirlineRouteEntity> data;

  EmployeeAirlineRoutesResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory EmployeeAirlineRoutesResponseModel.fromMap(
    Map<String, dynamic> json,
  ) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return EmployeeAirlineRoutesResponseModel(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data:
          dataList
              .map(
                (item) =>
                    AirlineRouteModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}
