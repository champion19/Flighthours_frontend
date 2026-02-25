import 'package:flight_hours_app/features/flight_summary/data/models/flight_hours_summary_model.dart';
import 'package:flight_hours_app/features/flight_summary/domain/repositories/flight_summary_repository.dart';

/// Use case for fetching flight hours summary
class GetFlightHoursSummaryUseCase {
  final FlightSummaryRepository repository;

  GetFlightHoursSummaryUseCase({required this.repository});

  Future<FlightHoursSummaryResponseModel> call({
    String? referenceDate,
    String? period,
  }) => repository.getFlightHoursSummary(
    referenceDate: referenceDate,
    period: period,
  );
}
