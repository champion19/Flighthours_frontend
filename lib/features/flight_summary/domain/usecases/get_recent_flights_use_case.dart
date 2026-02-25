import 'package:flight_hours_app/features/flight_summary/data/models/recent_flights_model.dart';
import 'package:flight_hours_app/features/flight_summary/domain/repositories/flight_summary_repository.dart';

/// Use case for fetching recent flights
class GetRecentFlightsUseCase {
  final FlightSummaryRepository repository;

  GetRecentFlightsUseCase({required this.repository});

  Future<RecentFlightsResponseModel> call() => repository.getRecentFlights();
}
