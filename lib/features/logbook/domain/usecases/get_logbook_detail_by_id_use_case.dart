import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/repositories/logbook_repository.dart';

/// Use case for getting a specific logbook detail by ID
class GetLogbookDetailByIdUseCase {
  final LogbookRepository _repository;

  GetLogbookDetailByIdUseCase({required LogbookRepository repository})
    : _repository = repository;

  /// Execute the use case
  /// [id] - The ID of the logbook detail to fetch
  Future<LogbookDetailEntity?> call(String id) async {
    return await _repository.getLogbookDetailById(id);
  }
}
