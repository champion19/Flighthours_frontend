import 'package:flight_hours_app/features/flight_summary/data/models/flight_hours_summary_model.dart';
import 'package:flight_hours_app/features/flight_summary/data/models/flight_alerts_model.dart';
import 'package:flight_hours_app/features/flight_summary/data/models/recent_flights_model.dart';

// States for the Flight Summary BLoC

abstract class FlightSummaryState {}

class FlightSummaryInitial extends FlightSummaryState {}

// ==================== Overall Summary (Home donut — never filtered) ====================

class OverallSummaryLoading extends FlightSummaryState {}

class OverallSummarySuccess extends FlightSummaryState {
  final FlightHoursSummaryData data;

  OverallSummarySuccess({required this.data});
}

class OverallSummaryError extends FlightSummaryState {
  final String message;

  OverallSummaryError({required this.message});
}

// ==================== Filtered Flight Hours Summary (Alerts stat cards) ====================

class FlightHoursSummaryLoading extends FlightSummaryState {}

class FlightHoursSummarySuccess extends FlightSummaryState {
  final FlightHoursSummaryData data;

  FlightHoursSummarySuccess({required this.data});
}

class FlightHoursSummaryError extends FlightSummaryState {
  final String message;

  FlightHoursSummaryError({required this.message});
}

// ==================== Flight Alerts ====================

class FlightAlertsLoading extends FlightSummaryState {}

class FlightAlertsSuccess extends FlightSummaryState {
  final List<FlightAlertData> alerts;

  FlightAlertsSuccess({required this.alerts});
}

class FlightAlertsError extends FlightSummaryState {
  final String message;

  FlightAlertsError({required this.message});
}

// ==================== Recent Flights ====================

class RecentFlightsLoading extends FlightSummaryState {}

class RecentFlightsSuccess extends FlightSummaryState {
  final List<RecentFlightData> flights;

  RecentFlightsSuccess({required this.flights});
}

class RecentFlightsError extends FlightSummaryState {
  final String message;

  RecentFlightsError({required this.message});
}
