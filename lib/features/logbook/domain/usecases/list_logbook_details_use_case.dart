import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';

/// Use case for listing all details (flight segments) of a daily logbook
class ListLogbookDetailsUseCase {
  final LogbookRepository _repository;

  ListLogbookDetailsUseCase({required LogbookRepository repository})
    : _repository = repository;

  /// Execute the use case
  /// [dailyLogbookId] - The ID of the daily logbook to get details for
  Future<List<LogbookDetailEntity>> call(String dailyLogbookId) async {
    return await _repository.getLogbookDetails(dailyLogbookId);
  }
}
