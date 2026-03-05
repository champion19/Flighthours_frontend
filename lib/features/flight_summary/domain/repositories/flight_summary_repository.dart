import 'package:flight_hours_app/features/flight_summary/data/models/flight_hours_summary_model.dart';
import 'package:flight_hours_app/features/flight_summary/data/models/flight_alerts_model.dart';
import 'package:flight_hours_app/features/flight_summary/data/models/recent_flights_model.dart';

/// Abstract repository interface for flight summary operations
abstract class FlightSummaryRepository {
  Future<FlightHoursSummaryResponseModel> getFlightHoursSummary({
    String? referenceDate,
    String? period,
  });

  Future<FlightAlertsResponseModel> getFlightAlerts();

  Future<RecentFlightsResponseModel> getRecentFlights();
}
