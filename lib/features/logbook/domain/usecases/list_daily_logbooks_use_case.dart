import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';

/// Use case for listing all daily logbooks of the authenticated employee
class ListDailyLogbooksUseCase {
  final LogbookRepository _repository;

  ListDailyLogbooksUseCase({required LogbookRepository repository})
    : _repository = repository;

  /// Execute the use case
  Future<List<DailyLogbookEntity>> call() async {
    return await _repository.getDailyLogbooks();
  }
}
