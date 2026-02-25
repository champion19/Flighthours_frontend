import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/network/dio_client.dart';
import 'package:flight_hours_app/features/flight_summary/data/models/flight_hours_summary_model.dart';
import 'package:flight_hours_app/features/flight_summary/data/models/flight_alerts_model.dart';
import 'package:flight_hours_app/features/flight_summary/data/models/recent_flights_model.dart';

/// Abstract interface for flight summary remote data operations
abstract class FlightSummaryRemoteDataSource {
  /// Fetches flight hours summary for the authenticated employee
  /// [period]: monthly, bimonthly, quarterly, semiannual, annual
  /// [referenceDate]: date to calculate period from (YYYY-MM-DD)
  Future<FlightHoursSummaryResponseModel> getFlightHoursSummary({
    String? referenceDate,
    String? period,
  });

  /// Fetches flight alerts for the authenticated employee
  Future<FlightAlertsResponseModel> getFlightAlerts();

  /// Fetches the 5 most recent flights for the authenticated employee
  Future<RecentFlightsResponseModel> getRecentFlights();
}

/// Implementation using Dio
class FlightSummaryRemoteDataSourceImpl
    implements FlightSummaryRemoteDataSource {
  final Dio _dio;

  FlightSummaryRemoteDataSourceImpl({Dio? dio})
    : _dio = dio ?? DioClient().client;

  @override
  Future<FlightHoursSummaryResponseModel> getFlightHoursSummary({
    String? referenceDate,
    String? period,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (referenceDate != null) queryParams['reference_date'] = referenceDate;
      if (period != null) queryParams['period'] = period;

      final response = await _dio.get(
        '/employees/flight-hours-summary',
        queryParameters: queryParams,
      );
      return FlightHoursSummaryResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return FlightHoursSummaryResponseModel.fromMap(e.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<FlightAlertsResponseModel> getFlightAlerts() async {
    try {
      final response = await _dio.get('/employees/flight-alerts');
      return FlightAlertsResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return FlightAlertsResponseModel.fromMap(e.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<RecentFlightsResponseModel> getRecentFlights() async {
    try {
      final response = await _dio.get('/employees/recent-flights');
      return RecentFlightsResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return RecentFlightsResponseModel.fromMap(e.response!.data);
      }
      rethrow;
    }
  }
}
