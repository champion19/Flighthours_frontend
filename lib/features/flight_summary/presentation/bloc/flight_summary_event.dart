// Events for the Flight Summary BLoC

abstract class FlightSummaryEvent {}

/// Load overall flight hours (for Home donut chart — never filtered)
class LoadOverallSummary extends FlightSummaryEvent {}

/// Load flight hours summary with filters (for Alerts stat cards)
class LoadFlightHoursSummary extends FlightSummaryEvent {
  final String? referenceDate;
  final String? period;

  LoadFlightHoursSummary({this.referenceDate, this.period});
}

/// Load flight alerts (for bell icon + alerts page)
class LoadFlightAlerts extends FlightSummaryEvent {}

/// Load recent flights (for home page list)
class LoadRecentFlights extends FlightSummaryEvent {}
