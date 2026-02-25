import 'package:flight_hours_app/features/flight_summary/data/models/flight_alerts_model.dart';
import 'package:flight_hours_app/features/flight_summary/domain/repositories/flight_summary_repository.dart';

/// Use case for fetching flight alerts
class GetFlightAlertsUseCase {
  final FlightSummaryRepository repository;

  GetFlightAlertsUseCase({required this.repository});

  Future<FlightAlertsResponseModel> call() => repository.getFlightAlerts();
}
