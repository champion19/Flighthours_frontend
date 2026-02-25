import 'package:flight_hours_app/features/flight_summary/data/datasources/flight_summary_remote_data_source.dart';
import 'package:flight_hours_app/features/flight_summary/data/models/flight_hours_summary_model.dart';
import 'package:flight_hours_app/features/flight_summary/data/models/flight_alerts_model.dart';
import 'package:flight_hours_app/features/flight_summary/data/models/recent_flights_model.dart';
import 'package:flight_hours_app/features/flight_summary/domain/repositories/flight_summary_repository.dart';

/// Repository implementation that delegates to the remote data source
class FlightSummaryRepositoryImpl implements FlightSummaryRepository {
  final FlightSummaryRemoteDataSource remoteDataSource;

  FlightSummaryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<FlightHoursSummaryResponseModel> getFlightHoursSummary({
    String? referenceDate,
    String? period,
  }) => remoteDataSource.getFlightHoursSummary(
    referenceDate: referenceDate,
    period: period,
  );

  @override
  Future<FlightAlertsResponseModel> getFlightAlerts() =>
      remoteDataSource.getFlightAlerts();

  @override
  Future<RecentFlightsResponseModel> getRecentFlights() =>
      remoteDataSource.getRecentFlights();
}
